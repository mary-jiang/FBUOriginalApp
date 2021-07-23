//
//  MatchingHelper.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/21/21.
//

#import "MatchingHelper.h"
#import "APIManager.h"

@implementation MatchingHelper

// TODO: actually implementing the matching algorithim here (will use the other methods in here to help)
+ (void)getUserMatch: (PFUser *)newUser {
    
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

+ (void)addScoreToParse: (NSNumber *)score user1: (PFUser *)user1 user2: (PFUser *)user2 {
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
