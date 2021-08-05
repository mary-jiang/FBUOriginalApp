//
//  TopicPostCell.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 8/4/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopicPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *likesButton;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) PFUser *author;

@end

NS_ASSUME_NONNULL_END
