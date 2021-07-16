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
- (void)refreshTokenWithCompletion:(NSString *)refreshToken completion:(void(^)(NSDictionary *, NSError *))completion;
- (void)searchSpotifyWithCompletion:(NSString *)query type:(NSString *)type authorization:(NSString *)authorization completion:(void(^)(NSDictionary *, NSError *))completion;
- (void)getMultipleTopicsWithCompletion: (NSString *)ids type:(NSString *)type authorization:(NSString *)authorization completion:(void(^)(NSDictionary *, NSError *))completion;
- (void)getTopicWithCompletion: (NSString *)spotifyId type:(NSString *)type authorization:(NSString *)authorization completion:(void(^)(NSDictionary *, NSError *))completion;
- (void)getTopArtistsWithCompletion: (NSString *)authorization completion:(void(^)(NSDictionary *, NSError *))completion;
- (void)getTopSongsWithCompletion: (NSString *)authorization completion:(void(^)(NSDictionary *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
