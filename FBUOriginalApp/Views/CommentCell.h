//
//  CommentCell.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/29/21.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (strong, nonatomic) PFUser *author;
@property (strong, nonatomic) PFObject *comment;

@end

NS_ASSUME_NONNULL_END
