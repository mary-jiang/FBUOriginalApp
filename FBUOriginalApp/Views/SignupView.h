//
//  SignupView.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SignupViewDelegate

- (void)didConnectWithSpotify; // called when sign up view detects someone trying to connect account with spotify
- (void)didSignup; // called when sign up view detects someone trying to sign up

@end

@interface SignupView : UIView

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) id<SignupViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
