//
//  SpotifyLoginView.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/13/21.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyLoginView : UIView

@property (weak, nonatomic) IBOutlet WKWebView *webkitView;

@end

NS_ASSUME_NONNULL_END
