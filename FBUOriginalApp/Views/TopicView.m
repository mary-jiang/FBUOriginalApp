//
//  TopicView.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 8/4/21.
//

#import "TopicView.h"
#import "UIImageView+AFNetworking.h"

@implementation TopicView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)updateUIBasedOnTopic:(Topic *)topic{
    self.topicLabel.text = topic.name;
    
    self.topicImageView.layer.cornerRadius = 5;
    
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

- (void)updateFollowButton:(BOOL)following{
    if (following) {
        [self.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
    } else {
        [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
    }
}

- (IBAction)didTapFollow:(id)sender {
    [self.delegate didTapFollow];
}

@end
