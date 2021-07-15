//
//  APIManager.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/13/21.
//

#import "APIManager.h"

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)exchangeCodeForTokenWithCompletion:(NSString *)code completion:(void(^)(NSDictionary *, NSError *))completion{
    // get client id and client secret from Keys.plist
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *key = [dict objectForKey: @"client_id"];
    NSString *secret = [dict objectForKey:@"client_secret"];
    
    // encode client id and client secret in a base 64 encoded string
    NSString *clientIDAndSecretString = [NSString stringWithFormat:@"%@:%@", key, secret];
    NSData *clientIDAndSecretData = [clientIDAndSecretString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *clientIDandSecretEncoded = [clientIDAndSecretData base64EncodedStringWithOptions:0];
    
    // create data for request body parameters
    NSString *queryParameters = [NSString stringWithFormat:@"grant_type=authorization_code&code=%@&redirect_uri=fbuoriginalapp://", code];
    NSData *queryData = [queryParameters dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:@"https://accounts.spotify.com/api/token"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    // set body data
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:queryData];
    // set header data
    [request setValue:[NSString stringWithFormat:@"Basic %@", clientIDandSecretEncoded] forHTTPHeaderField:@"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               completion(nil, error);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               completion(dataDictionary, nil);
           }
       }];
    [task resume];
}

- (void)refreshTokenWithCompletion:(NSString *)refreshToken completion:(void(^)(NSDictionary *, NSError *))completion {
    // get client id and client secret from Keys.plist
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *key = [dict objectForKey: @"client_id"];
    NSString *secret = [dict objectForKey:@"client_secret"];
    
    // encode client id and client secret in a base 64 encoded string
    NSString *clientIDAndSecretString = [NSString stringWithFormat:@"%@:%@", key, secret];
    NSData *clientIDAndSecretData = [clientIDAndSecretString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *clientIDandSecretEncoded = [clientIDAndSecretData base64EncodedStringWithOptions:0];
    
    // create data for reuqest body parameters
    NSString *queryParameters = [NSString stringWithFormat:@"grant_type=refresh_token&refresh_token=%@", refreshToken];
    NSData *queryData = [queryParameters dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:@"https://accounts.spotify.com/api/token"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    // set body data
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:queryData];
    // set header data
    [request setValue:[NSString stringWithFormat:@"Basic %@", clientIDandSecretEncoded] forHTTPHeaderField:@"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               completion(nil, error);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               completion(dataDictionary, nil);
           }
       }];
    [task resume];
}

- (void)searchSpotifyWithCompletion:(NSString *)query type:(NSString *)type authorization:(NSString *)authorization completion:(void(^)(NSDictionary *, NSError *))completion {
    // the search query must be encoded
    NSString *encodedQuery = [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    // construct request
    NSString *urlString = [NSString stringWithFormat:@"https://api.spotify.com/v1/search?q=%@&type=%@", encodedQuery, type];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", authorization] forHTTPHeaderField:@"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               completion(nil, error);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               completion(dataDictionary, nil);
           }
       }];
    [task resume];
}

- (void)getTopicWithCompletion: (NSString *)spotifyId type:(NSString *)type authorization:(NSString *)authorization completion:(void(^)(NSDictionary *, NSError *))completion {
    NSString *urlString = [NSString stringWithFormat:@"https://api.spotify.com/v1/%@s/%@", type, spotifyId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", authorization] forHTTPHeaderField:@"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               completion(nil, error);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               completion(dataDictionary, nil);
           }
       }];
    [task resume];
}

@end
