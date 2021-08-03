//
//  CreatePostViewController.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CreatePostViewControllerDelegate

- (void)createdPost;

@end

@interface CreatePostViewController : UIViewController

@property (weak, nonatomic) id<CreatePostViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
