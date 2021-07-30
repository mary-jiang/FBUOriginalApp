//
//  PostCell.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "PostCell.h"
#import "UIImageView+AFNetworking.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *profilePictureTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapProfile)];
    [self.profileImageView addGestureRecognizer:profilePictureTapGestureRecognizer];
    [self.profileImageView setUserInteractionEnabled:true];
    
    UITapGestureRecognizer *usernameLabelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapProfile)];
    [self.usernameLabel addGestureRecognizer:usernameLabelTapGestureRecognizer];
    [self.usernameLabel setUserInteractionEnabled:true];
}

- (void)didTapProfile {
    [self.delegate postCellUserTapped:self user:self.author];
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

- (void)setTopic:(Topic *)topic {
    _topic = topic;
    
    self.topicLabel.text = self.topic.name;
    NSURL *imageURL = [NSURL URLWithString:self.topic.image];
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

- (void)displayPlaceholder {
    self.profileImageView.image = nil;
    self.topicImageView.image = nil;
    
    self.usernameLabel.text = @"";
    self.topicLabel.text = @"";
    self.likesButton.alpha = 0;
    self.contentLabel.text = @"";
}

- (IBAction)didTapLike:(id)sender {
    [self.delegate likedPostCell:self withPost:self.post];
}
@end
