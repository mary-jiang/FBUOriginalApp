//
//  SpotifyLoginViewController.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/13/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SpotifyLoginViewControllerDelegate

- (void)didGetToken: (NSDictionary *)token;

@end

@interface SpotifyLoginViewController : UIViewController

@property (weak, nonatomic) id<SpotifyLoginViewControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
