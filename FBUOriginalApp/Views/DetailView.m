//
//  DetailView.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/29/21.
//

#import "DetailView.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"

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
    self.timestampLabel.text = [self getRelativeTimeStampString:post.createdAt];
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
    [self.delegate didTapLike];
}

- (NSString *)getRelativeTimeStampString:(NSDate *)date {
    NSDate *today = [NSDate date];
    int minutes = (int)[today minutesFrom:date];
    if(minutes > 10080){ // more than a week ago
        //format MM/DD/YY
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
        return [formatter stringFromDate:date];
    }else if(minutes > 1440){ // more than a day ago, but less than a week ago
        int days = (int)[today daysFrom:date];
        return [NSString stringWithFormat:@"%d days ago", days];
    }else if(minutes > 60){ // more than an hour ago, but less than a day ago
        int hours = (int)[today hoursFrom:date];
        return [NSString stringWithFormat:@"%d hours ago", hours];
    }else if(minutes == 0){ // seconds ago, but less than a minute ago
        int seconds = (int)[today secondsFrom:date];
        return [NSString stringWithFormat:@"%d seconds ago", seconds];
    }else{ // more than a minute ago, but less than an hour ago
        return [NSString stringWithFormat:@"%d minutes ago", minutes];
    }
}

@end
