//
//  LoginView.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "LoginView.h"

@implementation LoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)didTapLogIn:(id)sender {
    [self.delegate didLogin];
}

@end
