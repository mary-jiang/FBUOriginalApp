//
//  PostCell.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Topic.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PostCellDelegate;

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topicImageView;

@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) Topic *topic;
@property (strong, nonatomic) PFUser *author;

@property (weak, nonatomic) id<PostCellDelegate> delegate;

@end

@protocol PostCellDelegate

- (void)postCell: (PostCell *)postCell didTap: (PFUser *)user;

@end

NS_ASSUME_NONNULL_END
