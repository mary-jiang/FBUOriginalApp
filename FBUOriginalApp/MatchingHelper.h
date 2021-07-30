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

+ (void)getUserMatchWithCompletion:(PFUser *)newUser completion:(void(^)(PFUser *, NSError *))completion;
@end

NS_ASSUME_NONNULL_END
