//
//  TopicView.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 8/4/21.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TopicViewDelegate

- (void)didTapFollow;

@end

@interface TopicView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *topicImageView;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) id<TopicViewDelegate> delegate;

- (void)updateUIBasedOnTopic:(Topic *)topic;
- (void)updateFollowButton:(BOOL)following;

@end

NS_ASSUME_NONNULL_END
