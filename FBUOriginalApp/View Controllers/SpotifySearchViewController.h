//
//  SpotifySearchViewController.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SpotifySearchViewControllerDelegate

- (void)didChooseTopic:(Topic *)topic;

@end

@interface SpotifySearchViewController : UIViewController

@property (weak, nonatomic) id<SpotifySearchViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
