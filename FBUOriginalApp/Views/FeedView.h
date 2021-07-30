//
//  FeedView.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FeedViewDelegate

- (void)doubleTappedCell:(UITableViewCell *)cell;
- (void)singleTappedCell:(UITableViewCell *)cell;

@end

@interface FeedView : UIView

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) id<FeedViewDelegate> delegate;

- (void)createTapGestureRecognizers;

@end

NS_ASSUME_NONNULL_END
