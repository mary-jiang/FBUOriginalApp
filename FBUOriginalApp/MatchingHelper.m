//
//  MatchingHelper.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/21/21.
//

#import "MatchingHelper.h"
#import "APIManager.h"

@implementation MatchingHelper

- (void)mostListenedToGenres:(NSString *)authorization {
    NSMutableDictionary *genreFrequencyList = [NSMutableDictionary dictionary];
    // only artists have genre information
    [[APIManager shared] getTopArtistsWithCompletion:authorization numberOfArtists:50 completion:^(NSDictionary *results, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
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
            NSLog(@"%@", sortedGenres);
        }
    }];
}

@end
