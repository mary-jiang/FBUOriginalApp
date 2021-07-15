//
//  SpotifyCell.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *associatedImageView;
@property (strong, nonatomic) Topic *topic;

@end

NS_ASSUME_NONNULL_END
