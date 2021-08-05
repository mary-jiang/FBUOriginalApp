//
//  TopicPostCell.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 8/4/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TopicPostCellDelegate;

@interface TopicPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *likesButton;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) PFUser *author;

@property (weak, nonatomic) id<TopicPostCellDelegate> delegate;

@end

@protocol TopicPostCellDelegate

- (void)tappedUser:(PFUser *)user;
- (void)likedTopicPostCell:(TopicPostCell *)cell withPost:(Post *)post;

@end

NS_ASSUME_NONNULL_END
