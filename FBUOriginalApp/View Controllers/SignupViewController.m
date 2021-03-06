//
//  SignupViewController.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "SignupViewController.h"
#import "SignupView.h"
#import "SpotifyLoginViewController.h"
#import <Parse/Parse.h>

@interface SignupViewController () <SignupViewDelegate, SpotifyLoginViewControllerDelegate>

@property (strong, nonatomic) IBOutlet SignupView *signupView;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *refreshToken;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.signupView.delegate = self;
}

- (void)didSignup {
    [self registerUser];
}

- (void)didConnectWithSpotify {
    [self performSegueWithIdentifier:@"spotifyAuthSegue" sender:nil];
}

// called when the SpotifyLoginViewController successfully obtains the access token info from Spotify
- (void)didGetToken:(NSDictionary *)token {
    self.accessToken = token[@"access_token"];
    self.refreshToken = token[@"refresh_token"];
    
    [self.signupView displayConnectedToSpotify];
}

- (void)registerUser {
    if (self.accessToken != nil && self.refreshToken != nil) {
        PFUser *newUser = [PFUser user];
    
        newUser.username = self.signupView.usernameField.text;
        newUser.password = self.signupView.passwordField.text;
        newUser[@"spotifyToken"] = self.accessToken;
        newUser[@"refreshToken"] = self.refreshToken;
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error signing up user: %@", error.localizedDescription);
            } else {
                NSLog(@"User sucessfully registered");
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }];
    } else {
        NSLog(@"No authorization or refresh token, did not sign up user");
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"spotifyAuthSegue"]) {
        SpotifyLoginViewController *spotifyLoginViewController = [segue destinationViewController];
        spotifyLoginViewController.delegate = self;
    }
}


@end
