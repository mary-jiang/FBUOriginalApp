//
//  SignupView.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "SignupView.h"

@implementation SignupView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)didTapSpotify:(id)sender {
    [self.delegate didConnectWithSpotify];
}

- (IBAction)didTapSignup:(id)sender {
    [self.delegate didSignup];
}

- (void)displayConnectedToSpotify {
    [self.connectSpotifyButton setTitle:@"Spotify Connected" forState:UIControlStateNormal];
    [self.connectSpotifyButton setEnabled:false];
}

@end
