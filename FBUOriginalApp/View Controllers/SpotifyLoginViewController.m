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

@interface SpotifyLoginViewController ()

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
    
    NSString *redirect_uri = @"https://github.com/mary-jiang/";
    
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


@end
