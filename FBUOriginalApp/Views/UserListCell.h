//
//  UserListCell.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 8/4/21.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) PFUser *user;

@end

NS_ASSUME_NONNULL_END
