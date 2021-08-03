//
//  DetailViewController.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/29/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DetailViewControllerDelegate

- (void)likedPostWithId:(NSString *)objectId;

@end

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) id<DetailViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
