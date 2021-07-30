//
//  CommentCell.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/29/21.
//

#import "CommentCell.h"
#import "UIImageView+AFNetworking.h"

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setComment:(PFObject *)comment {
    _comment = comment;
    
    self.commentLabel.text = self.comment[@"text"];
}

- (void)setAuthor:(PFUser *)author {
    _author = author;
    
    self.usernameLabel.text = self.author[@"username"];
    
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
