//
//  TopicPostCell.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 8/4/21.
//

#import "TopicPostCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TopicPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    _post = post;
    
    self.contentLabel.text = self.post[@"text"];
    if (self.post[@"likedBy"] != nil && [self.post[@"likedBy"] containsObject:[PFUser currentUser].objectId]) {
        [self.likesButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
    } else {
        [self.likesButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    }
    [self.likesButton setTitle:[NSString stringWithFormat:@"%@", self.post[@"likeCount"]] forState:UIControlStateNormal];
    self.likesButton.alpha = 1;
}

- (void)setAuthor:(PFUser *)author {
    _author = author;
    
    self.usernameLabel.text = self.author[@"username"];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2;
    
    NSURL *profileURL;
    PFFileObject *profilePicture = self.author[@"profilePicture"];
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
}

@end
