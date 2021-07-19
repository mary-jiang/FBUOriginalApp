//
//  UserCell.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "UserCell.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(PFUser *)user {
    _user = user;
    
    self.usernameLabel.text = self.user.username;
    
    PFFileObject *profilePicture = self.user[@"profilePicture"];
    if (profilePicture != nil) {
        NSURL *profileURL = [NSURL URLWithString:profilePicture.url];
        NSData *profileData = [NSData dataWithContentsOfURL:profileURL];
        self.profileImageView.image = [UIImage imageWithData:profileData];
    }
}

@end
