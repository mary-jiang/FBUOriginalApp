//
//  DetailView.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/29/21.
//

#import "DetailView.h"
#import "UIImageView+AFNetworking.h"

@implementation DetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)displayPlaceholders {
    self.profileImageView.image = nil;
    self.topicImageView.image = nil;
    
    self.usernameLabel.text = @"";
    self.topicLabel.text = @"";
    self.contentLabel.text = @"";
    self.timestampLabel.text = @"";
    self.likesButton.alpha = 0;
}

- (void)updateUIBasedOnPost: (Post *)post {
    self.contentLabel.text = post[@"text"];
    if (post[@"likedBy"] != nil && [post[@"likedBy"] containsObject:[PFUser currentUser].objectId]) {
        [self.likesButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
    } else {
        [self.likesButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    }
    [self.likesButton setTitle:[NSString stringWithFormat:@"%@", post[@"likeCount"]] forState:UIControlStateNormal];
    self.likesButton.alpha = 1;
}

- (void)updateUIBasedOnTopic: (Topic *) topic {
    self.topicLabel.text = topic.name;
    NSURL *imageURL = [NSURL URLWithString:topic.image];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    [self.topicImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (response) {
            self.topicImageView.alpha = 0;
            self.topicImageView.image = image;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.topicImageView.alpha = 1;
            }];
        } else {
            self.topicImageView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        // for now do nothing when fails
    }];
}

- (void)updateUIBasedOnAuthor: (PFUser *)user {
    self.usernameLabel.text = user[@"username"];
    
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
}


- (IBAction)didTapLike:(id)sender {
    
}

@end
