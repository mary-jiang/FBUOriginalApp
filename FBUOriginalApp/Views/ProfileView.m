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

- (void)updateUIBasedOnUser: (PFUser *) user{
    self.usernameLabel.text = user[@"username"];
    
    PFFileObject *profilePicture = user[@"profilePicture"];
    if (profilePicture != nil) {
        NSURL *profileURL = [NSURL URLWithString:profilePicture.url];
        NSData *profileData = [NSData dataWithContentsOfURL:profileURL];
        self.profileImageView.image = [UIImage imageWithData:profileData];
    }
}

- (void)updateArtist1WithTopic: (Topic *) topic{
    self.artist1Label.text = topic.name;
    NSURL *imageURL = [NSURL URLWithString:topic.image];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    self.artist1ImageView.image = [UIImage imageWithData:imageData];
}

- (void)updateArtist2WithTopic: (Topic *) topic{
    self.artist2Label.text = topic.name;
    NSURL *imageURL = [NSURL URLWithString:topic.image];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    self.artist2ImageView.image = [UIImage imageWithData:imageData];
}

- (void)updateArtist3WithTopic: (Topic *) topic{
    self.artist3Label.text = topic.name;
    NSURL *imageURL = [NSURL URLWithString:topic.image];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    self.artist3ImageView.image = [UIImage imageWithData:imageData];
}

@end
