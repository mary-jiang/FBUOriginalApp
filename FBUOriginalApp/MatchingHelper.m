//
//  MatchingHelper.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/21/21.
//

#import "MatchingHelper.h"
#import "APIManager.h"

@implementation MatchingHelper

// TODO: in future, implement some way to exclude some users from recommendation (ex. exclude already following users from recommendation)
// TODO: (maybe, possible feature idea) store recommended user somewhere until user follows that user or asks for a new recommendation to avoid excess calculations
+ (void)getUserMatchWithCompletion: (PFUser *)newUser completion:(void(^)(PFUser *, NSError *))completion{
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" notEqualTo:newUser.objectId];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFUser *oldUser = (PFUser *) object;
        [MatchingHelper compareTwoUsersWithCompletion:newUser user2:oldUser previousScore:nil previousUser:nil completion:completion];
    }];
}

+ (void)compareTwoUsersWithCompletion: (PFUser *)user1 user2: (PFUser *)user2
                        previousScore: (NSNumber *) prevScore previousUser: (PFUser *) prevUser
                           completion:(void(^)(PFUser *, NSError *))completion{
    // user 1 will always be the new user we are trying to add in which is guarenteed to have a valid token
    // user 2 may or may not have a valid token, refresh user 2's token to ensure it can be used before anything is done
    
    [[APIManager shared] refreshTokenWithCompletion:user2[@"refreshToken"] completion:^(NSDictionary *tokens, NSError *error) {
        [MatchingHelper calculateCompatibilityWithCompletion:user1[@"spotifyToken"] user2:tokens[@"access_token"] completion:^(NSNumber *score, NSError *error) {
            if (error != nil) {
                completion(nil, error);
            } else {
                // if score < prevScore don't even check user2's other connections, send prevUser as recommendation
                if (prevScore != nil && [score doubleValue] < [prevScore doubleValue]) {
                    [MatchingHelper addScoreToParse:score user1:user1 user2:user2];
                    completion(prevUser, nil);
                } else {
                    PFQuery *query = [PFQuery queryWithClassName:@"CompatibilityScore"];
                    [query whereKey:@"user1" equalTo:user2]; // this gets all compatibiltiy scores that user2 has with other users already
                    [query whereKey:@"user2" notEqualTo:user1]; //exclude any already calculate values between these two users
                    [query orderByAscending:@"score"]; // make Parse give us a sorted array so that we can search faster
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (error != nil) {
                            completion(nil, error);
                        } else {
                            if (objects != nil && [objects count] > 0) {
                                // make a dummy CompatibilityScore PFObject to search against
                                PFObject *searchObject = [PFObject objectWithClassName:@"CompatibilityScore"];
                                searchObject[@"score"] = score;
                                
                                // use built in NSArray binary search will give either index of exact matchor the index score should be inserted at to keep sorted
                                // aka index - 1 is less than searchObject, index is greater than searchObject
                                NSUInteger searchIndex = [objects indexOfObject:searchObject inSortedRange:NSMakeRange(0, [objects count])
                                                                        options:NSBinarySearchingFirstEqual | NSBinarySearchingInsertionIndex
                                                                usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                                    double obj1Num = [obj1[@"score"] doubleValue];
                                    double obj2Num = [obj2[@"score"] doubleValue];
                                    if (obj1Num > obj2Num) {
                                        return NSOrderedDescending;
                                    } else if (obj1Num < obj2Num) {
                                        return NSOrderedAscending;
                                    } else {
                                        return NSOrderedSame;
                                    }
                                }];
                                
                                // nextUser will be chosen by whatever user2-nextUser score closest to user1-user2 score
                                PFUser *nextUser;
                                
                                // deal with cases based on searchIndex to find next user to jump to
                                // searchIndex = 0, all values in objects greater than search object, closest is the first object of the array
                                // searchIndex = objects count, all values in objects less than search object, closest is last object of the array
                                // else we check index and index - 1 (either side of the searchObject) to see which one is closer
                                if (searchIndex == 0) {
                                    nextUser = objects[0][@"user2"];
                                } else if (searchIndex == [objects count]) {
                                    nextUser = objects[[objects count] - 1][@"user2"];
                                } else {
                                    double leftDifference = [score doubleValue] - [objects[searchIndex - 1][@"score"] doubleValue];
                                    double rightDifference = [objects[searchIndex][@"score"] doubleValue] - [score doubleValue];
                                    if (leftDifference < rightDifference) { // leftDifference < rightDifference means object at searchIndex - 1 is closer
                                        nextUser = objects[searchIndex - 1][@"user2"];
                                    } else { // else object at searchIndex is closer
                                        nextUser = objects[searchIndex][@"user2"];
                                    }
                                }
                               
                                // done with user 2 table so can safely add user1-user2 connection
                                [MatchingHelper addScoreToParse:score user1:user1 user2:user2];
                                
                                // fetch nextUser to continue checking cycle with user1 and nextUser
                                [nextUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                    if (error != nil) {
                                        completion(nil, error);
                                    } else {
                                        [MatchingHelper compareTwoUsersWithCompletion:user1 user2:nextUser previousScore:score previousUser:user2 completion:completion];
                                    }
                                }];
                            } else {
                                // nothing in the array, add user1-user2 connection to parse, send user2 as rec (already passed prevScore check)
                                [MatchingHelper addScoreToParse:score user1:user1 user2:user2];
                                completion(user2, nil);
                            }
                            
                        }
                    }];
                }
            }
        }];
    }];
    
    
}

+ (void)calculateCompatibilityWithCompletion: (NSString *)user1 user2: (NSString *)user2 completion:(void(^)(NSNumber *, NSError *))completion{
    __block NSArray *user1Artists;
    __block NSArray *user2Artists;
    __block NSArray *user1Songs;
    __block NSArray *user2Songs;
    __block NSArray *user1Genres;
    __block NSArray *user2Genres;
    
    __block double score = 0;
    
    [[APIManager shared] getTopArtistsWithCompletion:user1 numberOfArtists:50 completion:^(NSDictionary *results, NSError *error) {
        if (error != nil) {
            completion(nil, error);
        } else {
            user1Artists = [MatchingHelper spotifyIdArrayFromDictionaries:results[@"items"]];
            [[APIManager shared] getTopArtistsWithCompletion:user2 numberOfArtists:50 completion:^(NSDictionary *results, NSError *error) {
                if (error != nil) {
                    completion(nil, error);
                } else {
                    user2Artists = [MatchingHelper spotifyIdArrayFromDictionaries:results[@"items"]];
                    [[APIManager shared] getTopSongsWithCompletion:user1 numberOfSongs:50 completion:^(NSDictionary *results, NSError *error) {
                        if (error != nil) {
                            completion(nil, error);
                        } else {
                            user1Songs = [MatchingHelper spotifyIdArrayFromDictionaries:results[@"items"]];
                            [[APIManager shared] getTopSongsWithCompletion:user2 numberOfSongs:50 completion:^(NSDictionary *results, NSError *error) {
                                if (error != nil) {
                                    completion(nil, error);
                                } else {
                                    user2Songs = [MatchingHelper spotifyIdArrayFromDictionaries:results[@"items"]];
                                    [MatchingHelper mostListenedToGenresWithCompletion:user1 completion:^(NSArray *results, NSError *error) {
                                        if (error != nil) {
                                            completion(nil, error);
                                        } else {
                                            user1Genres = results;
                                            [MatchingHelper mostListenedToGenresWithCompletion:user2 completion:^(NSArray *results, NSError *error) {
                                                if (error != nil) {
                                                    completion(nil, error);
                                                } else {
                                                    user2Genres = results;
                                                    
                                                    double artistScore =
                                                    [MatchingHelper calculatePartialScore:user1Artists user2:user2Artists withMultipler:2.0];
                                                    double songScore = [MatchingHelper calculatePartialScore:user1Songs user2:user2Songs withMultipler:1.5];
                                                    double genreScore = [MatchingHelper calculatePartialScore:user1Genres user2:user2Genres withMultipler:1.0];
                                                    
                                                    score = artistScore + songScore + genreScore;
                                                    
                                                    completion([NSNumber numberWithDouble:score], nil);
                                                }
                                            }];
                                        }
                                    }];
                                }
                            }];
                        }
                    }];
                }
            }];
        }
    }];
}

// TODO: in future, make it so when adding scores if already score will update that score instead of ignoring (in case of music taste changes for example)
// will never add repeat scores to Parse (if already a score between user1-user2 will not add a new one)
+ (void)addScoreToParse: (NSNumber *)score user1: (PFUser *)user1 user2: (PFUser *)user2 {
    // first check if there is already a score between these two users, if there already is don't add a repeat
    PFQuery *query = [PFQuery queryWithClassName:@"CompatibilityScore"];
    [query whereKey:@"user1" equalTo:user1];
    [query whereKey:@"user2" equalTo:user2];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error != nil) {
            NSLog(@"Error with checking if score already exists in Parse or not: %@", error.localizedDescription);
        } else {
            if (objects == nil || [objects count] == 0) {
                // make 2 compatibility score objects to represent the score relationship in both directions (user1->user2 and user2->user1)
                PFObject *compatibilityScore1 = [PFObject objectWithClassName:@"CompatibilityScore"];
                compatibilityScore1[@"user1"] = user1;
                compatibilityScore1[@"user2"] = user2;
                compatibilityScore1[@"score"] = score;
                
                PFObject *compatibilityScore2 =[PFObject objectWithClassName:@"CompatibilityScore"];
                compatibilityScore2[@"user1"] = user2;
                compatibilityScore2[@"user2"] = user1;
                compatibilityScore2[@"score"] = score;
                
                [compatibilityScore1 saveInBackground];
                [compatibilityScore2 saveInBackground];
            }
        }
    }];
}

+ (NSArray *)spotifyIdArrayFromDictionaries: (NSArray *)dictionaries {
    NSMutableArray *ids = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        [ids addObject:dictionary[@"id"]];
    }
    return (NSArray *) ids;
}

+ (double)calculatePartialScore: (NSArray *)user1 user2: (NSArray *)user2 withMultipler: (double)multiplier{
    double scoreTotal = 0;
    
    NSMutableSet *set1 = [NSMutableSet setWithArray:user1];
    NSSet *set2 = [NSSet setWithArray:user2];
    [set1 intersectSet:set2];
    
    NSArray *overlap = [set1 allObjects];
    
    // award points for just having a match (10 points for each match found and the multiplier only applies to match, not bonus points)
    scoreTotal += (10.0 * multiplier * (double) overlap.count);
    
    // award bonus points based on position of match compared to each other (shorter array's length - offset)
    int baseBonus = (int) MIN(user1.count, user2.count);
    for (NSString *match in overlap) {
        int index1 = (int) [user1 indexOfObject:match];
        int index2 = (int) [user2 indexOfObject:match];
        
        int offset = abs(index1 - index2);
        
        scoreTotal += (double)(baseBonus - offset);
    }
    
    return scoreTotal;
}

+ (void)mostListenedToGenresWithCompletion:(NSString *)authorization completion:(void(^)(NSArray *, NSError *))completion {
    NSMutableDictionary *genreFrequencyList = [NSMutableDictionary dictionary];
    // only artists have genre information
    [[APIManager shared] getTopArtistsWithCompletion:authorization numberOfArtists:50 completion:^(NSDictionary *results, NSError *error) {
        if (error != nil) {
            completion(nil, error);
        } else {
            NSArray *artists = results[@"items"];
            for (NSDictionary *artist in artists) {
                NSArray *genres = artist[@"genres"];
                for (NSString *genre in genres) {
                    if (genreFrequencyList[genre] != nil) {
                        NSNumber *value = genreFrequencyList[genre];
                        genreFrequencyList[genre] = [NSNumber numberWithInt:[value intValue] + 1];
                    } else {
                        [genreFrequencyList setValue:[NSNumber numberWithInt:1] forKey:genre];
                    }
                }
            }
            NSArray *sortedGenres = [genreFrequencyList keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                if ([obj1 intValue] > [obj2 intValue]) {
                    return NSOrderedAscending;
                } else if ([obj1 intValue] < [obj2 intValue]) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
            }];
            
            completion(sortedGenres, nil);
            
        }
    }];
}

@end
