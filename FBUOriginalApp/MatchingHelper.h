//
//  MatchingHelper.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/21/21.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface MatchingHelper : NSObject

+ (void)calculateCompatibility: (NSString *)user1 user2: (NSString *)user2;
+ (void)addScoreToParse: (double)score user1: (PFUser *)user1 user2: (PFUser *)user2;

@end

NS_ASSUME_NONNULL_END
