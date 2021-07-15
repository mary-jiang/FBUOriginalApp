//
//  PostCell.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "PostCell.h"

@implementation PostCell

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
    self.likesLabel.text = [NSString stringWithFormat:@"%@ Likes", self.post[@"likeCount"]];
}

- (void)setTopic:(Topic *)topic {
    _topic = topic;
    
    self.topicLabel.text = self.topic.name;
    NSURL *imageURL = [NSURL URLWithString:self.topic.image];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    self.topicImageView.image = [UIImage imageWithData:imageData];
}

- (void)setAuthor:(PFUser *)author {
    _author = author;
    
    self.usernameLabel.text = self.author[@"username"];
    
    // check to see if there is a profile picture
    PFFileObject *profilePicture = author[@"profilepicture"];
    if (profilePicture != nil) {
        NSURL *profileURL = [NSURL URLWithString:profilePicture.url];
        NSData *profileData = [NSData dataWithContentsOfURL:profileURL];
        self.profileImageView.image = [UIImage imageWithData:profileData];
    }
}

@end
