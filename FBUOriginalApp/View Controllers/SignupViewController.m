//
//  SignupViewController.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "SignupViewController.h"
#import "SignupView.h"

@interface SignupViewController () <SignupViewDelegate>

@property (strong, nonatomic) IBOutlet SignupView *signupView;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.signupView.delegate = self;
}

- (void)didSignup {
    NSLog(@"tapped signup");
}

- (void)didConnectWithSpotify {
    NSLog(@"tapped connect with spotify");
    [self performSegueWithIdentifier:@"spotifyAuthSegue" sender:nil];
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
