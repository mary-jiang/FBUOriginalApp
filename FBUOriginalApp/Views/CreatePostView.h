//
//  CreatePostView.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CreatePostViewDelegate

- (void)didTapTopic;

@end

@interface CreatePostView : UIView

@property (weak, nonatomic) IBOutlet UILabel *chosenTopicLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chosenTopicImageView;
@property (weak, nonatomic) IBOutlet UIView *chosenTopicWrapper;
@property (weak, nonatomic) id<CreatePostViewDelegate> delegate;

- (void)createTopicTapGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
