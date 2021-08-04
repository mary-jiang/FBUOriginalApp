//
//  TopicView.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 8/4/21.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopicView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *topicImageView;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)updateUIBasedOnTopic:(Topic *)topic;

@end

NS_ASSUME_NONNULL_END
