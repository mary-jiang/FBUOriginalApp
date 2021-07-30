//
//  DetailView.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/29/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Topic.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DetailViewDelegate

- (void)didTapLike;
- (void)didTapProfile;
- (void)didTapPostCommentWithText: (NSString *)text;

@end

@interface DetailView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topicImageView;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIButton *likesButton;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) id<DetailViewDelegate> delegate;

- (void)createTapGestureRecognizers;

- (void)displayPlaceholders;
- (void)updateUIBasedOnPost:(Post *)post;
- (void)updateUIBasedOnTopic:(Topic *)topic;
- (void)updateUIBasedOnAuthor:(PFUser *)user;

@end

NS_ASSUME_NONNULL_END
