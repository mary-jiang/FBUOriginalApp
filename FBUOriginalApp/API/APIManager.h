//
//  APIManager.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/13/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (instancetype)shared;
- (void)exchangeCodeForTokenWithCompletion:(NSString *)code completion:(void(^)(NSDictionary *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
