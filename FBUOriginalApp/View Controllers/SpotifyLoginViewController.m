//
//  SpotifyLoginViewController.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/13/21.
//

#import "SpotifyLoginViewController.h"
#import <WebKit/WebKit.h>
#import "SpotifyLoginView.h"
#import "APIManager.h"

@interface SpotifyLoginViewController () <WKNavigationDelegate>

@property (strong, nonatomic) IBOutlet SpotifyLoginView *spotifyLoginView;

@end

@implementation SpotifyLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.spotifyLoginView.webkitView.navigationDelegate = self;
    
    // code to pull api keys from keys.plist
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *key= [dict objectForKey: @"client_id"];
    
    NSString *redirect_uri = @"fbuoriginalapp://";
    
    // prompt log in
    NSString *urlString = [NSString stringWithFormat:@"https://accounts.spotify.com/authorize?client_id=%@&scope=user-read-recently-played+user-top-read+user-library-read&redirect_uri=%@&response_type=code", key, redirect_uri];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [self.spotifyLoginView.webkitView loadRequest:request];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// for all redirects done we need to check if we are redirecting to our custom scheme
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *requestURLString = navigationAction.request.URL.absoluteString;
    // check for custom scheme
    if ([requestURLString hasPrefix:@"fbuoriginalapp"]) {
        // if we find a redirect with custom scheme, pull the needed code from the url, exchange it for the access token dictionary
        NSString *authorizationCode = [requestURLString stringByReplacingOccurrencesOfString:@"fbuoriginalapp://?code=" withString:@""];
        [[APIManager shared] exchangeCodeForTokenWithCompletion:authorizationCode completion:^(NSDictionary * tokenDictionary, NSError * error) {
            if (error != nil) {
                NSLog(@"Error exchanging token: %@", error.localizedDescription);
            } else {
                [self.delegate didGetToken:tokenDictionary];
            }
        }];
        
        // cancel the redirect and dismiss this view controller
        decisionHandler(WKNavigationActionPolicyCancel);
        [self dismissViewControllerAnimated:true completion:nil];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}


@end
