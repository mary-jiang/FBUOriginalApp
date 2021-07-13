//
//  LoginView.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LoginViewDelegate

- (void)didLogin; // called when the log in view detects someone trying to login

@end

@interface LoginView : UIView

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) id<LoginViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
