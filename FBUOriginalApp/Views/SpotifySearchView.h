//
//  SpotifySearchView.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SpotifySearchViewDelegate

- (void)changedType;

@end

@interface SpotifySearchView : UIView

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) id<SpotifySearchViewDelegate> delegate;

- (NSString *)getType;
- (void)artistsOnly; // sets the segmented control so that only artists can be searched
- (void)songsOnly; // sets the segmented control so that only songs can be searched

@end

NS_ASSUME_NONNULL_END
