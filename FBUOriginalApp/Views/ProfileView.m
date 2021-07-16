//
//  ProfileView.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "ProfileView.h"

@implementation ProfileView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createAllTapGestureRecognizers {
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapProfile)];
    [self.profileImageView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileImageView setUserInteractionEnabled:true];
}

- (void)didTapProfile {
    [self.delegate didTapProfilePicture];
}

- (void)updateProfilePicture:(UIImage *)image {
    self.profileImageView.image = image;
}

@end
