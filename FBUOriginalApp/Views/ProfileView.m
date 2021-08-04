//
//  ProfileView.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "ProfileView.h"
#import "UIImageView+AFNetworking.h"

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
    
    UITapGestureRecognizer *artist1TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapArtist1)];
    [self.artist1ImageView addGestureRecognizer:artist1TapGestureRecognizer];
    [self.artist1ImageView setUserInteractionEnabled:true];
    
    UITapGestureRecognizer *artist2TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapArtist2)];
    [self.artist2ImageView addGestureRecognizer:artist2TapGestureRecognizer];
    [self.artist2ImageView setUserInteractionEnabled:true];
    
    UITapGestureRecognizer *artist3TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapArtist3)];
    [self.artist3ImageView addGestureRecognizer:artist3TapGestureRecognizer];
    [self.artist3ImageView setUserInteractionEnabled:true];
    
    UITapGestureRecognizer *song1TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSong1)];
    [self.song1ImageView addGestureRecognizer:song1TapGestureRecognizer];
    [self.song1ImageView setUserInteractionEnabled:true];
    
    UITapGestureRecognizer *song2TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSong2)];
    [self.song2ImageView addGestureRecognizer:song2TapGestureRecognizer];
    [self.song2ImageView setUserInteractionEnabled:true];
    
    UITapGestureRecognizer *song3TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSong3)];
    [self.song3ImageView addGestureRecognizer:song3TapGestureRecognizer];
    [self.song3ImageView setUserInteractionEnabled:true];
    
    UITapGestureRecognizer *followersTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapFollowers)];
    [self.followersLabel addGestureRecognizer:followersTapGestureRecognizer];
    [self.followersLabel setUserInteractionEnabled:true];
    
    UITapGestureRecognizer *followingTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapFollowing)];
    [self.followingLabel addGestureRecognizer:followingTapGestureRecognizer];
    [self.followingLabel setUserInteractionEnabled:true];
}

- (void)createFollowRelatedTapGestureRecognizers {
    UITapGestureRecognizer *followersTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapFollowers)];
    [self.followersLabel addGestureRecognizer:followersTapGestureRecognizer];
    [self.followersLabel setUserInteractionEnabled:true];
    
    UITapGestureRecognizer *followingTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapFollowing)];
    [self.followingLabel addGestureRecognizer:followingTapGestureRecognizer];
    [self.followingLabel setUserInteractionEnabled:true];
}

- (void)disableFollowing {
    [self.followButton setEnabled:false];
    self.followButton.alpha = 0;
}

// if following is true make the button say "unfollow", else says "follow"
- (void)updateFollowButton:(BOOL)following{
    if (following) {
        [self.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
    } else {
        [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
    }
}

- (void)didTapProfile {
    [self.delegate didTapProfilePicture];
}

- (void)didTapArtist1 {
    [self.delegate didTapArtist1];
}

- (void)didTapArtist2 {
    [self.delegate didTapArtist2];
}

- (void)didTapArtist3 {
    [self.delegate didTapArtist3];
}

- (void)didTapSong1 {
    [self.delegate didTapSong1];
}

- (void)didTapSong2 {
    [self.delegate didTapSong2];
}

- (void)didTapSong3 {
    [self.delegate didTapSong3];
}

- (void)didTapFollowers {
    [self.delegate didTapFollowers];
}

- (void)didTapFollowing {
    [self.delegate didTapFollowing];
}

- (IBAction)followButtonPressed:(id)sender {
    [self.delegate didTapFollow];
}

- (void)displayBeforeLoadingPlaceholders {
    self.artist1ImageView.image = nil;
    self.artist2ImageView.image = nil;
    self.artist3ImageView.image = nil;
    
    self.artist1ImageView.layer.cornerRadius = 5;
    self.artist2ImageView.layer.cornerRadius = 5;
    self.artist3ImageView.layer.cornerRadius = 5;
    
    self.artist1Label.text = @"";
    self.artist2Label.text = @"";
    self.artist3Label.text = @"";
    
    self.song1ImageView.image = nil;
    self.song2ImageView.image = nil;
    self.song3ImageView.image = nil;
    
    self.song1ImageView.layer.cornerRadius = 5;
    self.song2ImageView.layer.cornerRadius = 5;
    self.song3ImageView.layer.cornerRadius = 5;
    
    self.song1Label.text = @"";
    self.song2Label.text = @"";
    self.song3Label.text = @"";
}

- (void)displayNoArtistDataPlaceholders {
    NSURL *placeholderURL = [NSURL URLWithString:@"https://www.firstbenefits.org/wp-content/uploads/2017/10/placeholder.png"];
    NSData *placeholderData = [NSData dataWithContentsOfURL:placeholderURL];
    UIImage *placeholderImage = [UIImage imageWithData:placeholderData];
    
    self.artist1ImageView.image = placeholderImage;
    self.artist2ImageView.image = placeholderImage;
    self.artist3ImageView.image = placeholderImage;
    
    self.artist1Label.text = @"N/A";
    self.artist2Label.text = @"N/A";
    self.artist3Label.text = @"N/A";
}

- (void)displayNoSongDataPlaceholders {
    NSURL *placeholderURL = [NSURL URLWithString:@"https://www.firstbenefits.org/wp-content/uploads/2017/10/placeholder.png"];
    NSData *placeholderData = [NSData dataWithContentsOfURL:placeholderURL];
    UIImage *placeholderImage = [UIImage imageWithData:placeholderData];

    self.song1ImageView.image = placeholderImage;
    self.song2ImageView.image = placeholderImage;
    self.song3ImageView.image = placeholderImage;
    
    self.song1Label.text = @"N/A";
    self.song2Label.text = @"N/A";
    self.song3Label.text = @"N/A";
}

- (void)updateProfilePicture:(UIImage *)image {
    self.profileImageView.image = image;
}

- (void)updateUIBasedOnUser:(PFUser *)user{
    self.usernameLabel.text = user[@"username"];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2;
    
    NSURL *profileURL;
    PFFileObject *profilePicture = user[@"profilePicture"];
    if (profilePicture != nil) {
        profileURL = [NSURL URLWithString:profilePicture.url];
    } else {
        profileURL = [NSURL URLWithString:@"https://www.firstbenefits.org/wp-content/uploads/2017/10/placeholder.png"];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:profileURL];
    [self.profileImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (response) {
            self.profileImageView.alpha = 0;
            self.profileImageView.image = image;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.profileImageView.alpha = 1;
            }];
        } else {
            self.profileImageView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        // for now do nothing when fails
    }];
    
    NSArray *following = user[@"following"];
    self.followingLabel.text = [NSString stringWithFormat:@"%lu Following", following.count];
}

- (void)updateFollowersLabelWithNumber:(NSUInteger)numOfFollowers {
    self.followersLabel.text = [NSString stringWithFormat:@"%lu Followers", numOfFollowers];
}

- (void)updateAllArtistsWithTopics:(NSArray *)topics {
    [self updateArtist1WithTopic:topics[0]];
    [self updateArtist2WithTopic:topics[1]];
    [self updateArtist3WithTopic:topics[2]];
}

- (void)updateArtist1WithTopic:(Topic *)topic{
    self.artist1Label.text = topic.name;
    NSURL *imageURL = [NSURL URLWithString:topic.image];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    [self.artist1ImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (response) {
            self.artist1ImageView.alpha = 0;
            self.artist1ImageView.image = image;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.artist1ImageView.alpha = 1;
            }];
        } else {
            self.artist1ImageView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        // for now do nothing when fails
    }];
}

- (void)updateArtist2WithTopic:(Topic *)topic{
    self.artist2Label.text = topic.name;
    NSURL *imageURL = [NSURL URLWithString:topic.image];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    [self.artist2ImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (response) {
            self.artist2ImageView.alpha = 0;
            self.artist2ImageView.image = image;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.artist2ImageView.alpha = 1;
            }];
        } else {
            self.artist2ImageView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        // for now do nothing when fails
    }];
}

- (void)updateArtist3WithTopic:(Topic *)topic{
    self.artist3Label.text = topic.name;
    NSURL *imageURL = [NSURL URLWithString:topic.image];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    [self.artist3ImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (response) {
            self.artist3ImageView.alpha = 0;
            self.artist3ImageView.image = image;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.artist3ImageView.alpha = 1;
            }];
        } else {
            self.artist3ImageView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        // for now do nothing when fails
    }];
}

- (void)updateAllSongsWithTopics:(NSArray *)topics {
    [self updateSong1WithTopic:topics[0]];
    [self updateSong2WithTopic:topics[1]];
    [self updateSong3WithTopic:topics[2]];
}

- (void)updateSong1WithTopic:(Topic *)topic{
    self.song1Label.text = topic.name;
    NSURL *imageURL = [NSURL URLWithString:topic.image];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    [self.song1ImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (response) {
            self.song1ImageView.alpha = 0;
            self.song1ImageView.image = image;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.song1ImageView.alpha = 1;
            }];
        } else {
            self.song1ImageView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        // for now do nothing when fails
    }];
}

- (void)updateSong2WithTopic:(Topic *)topic{
    self.song2Label.text = topic.name;
    NSURL *imageURL = [NSURL URLWithString:topic.image];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    [self.song2ImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (response) {
            self.song2ImageView.alpha = 0;
            self.song2ImageView.image = image;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.song2ImageView.alpha = 1;
            }];
        } else {
            self.song2ImageView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        // for now do nothing when fails
    }];
}

- (void)updateSong3WithTopic:(Topic *)topic{
    self.song3Label.text = topic.name;
    NSURL *imageURL = [NSURL URLWithString:topic.image];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    [self.song3ImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (response) {
            self.song3ImageView.alpha = 0;
            self.song3ImageView.image = image;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.song3ImageView.alpha = 1;
            }];
        } else {
            self.song3ImageView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        // for now do nothing when fails
    }];
}


@end
