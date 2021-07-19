//
//  SpotifySearchView.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "SpotifySearchView.h"

@implementation SpotifySearchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSString *)getType {
    NSArray *types = @[@"album", @"artist", @"track"];
    return types[self.typeSegmentedControl.selectedSegmentIndex];
}

- (void)artistsOnly {
    [self.typeSegmentedControl setEnabled:false forSegmentAtIndex:0];
    [self.typeSegmentedControl setEnabled:false forSegmentAtIndex:2];
    self.typeSegmentedControl.selectedSegmentIndex = 1;
}

- (void)songsOnly {
    [self.typeSegmentedControl setEnabled:false forSegmentAtIndex:0];
    [self.typeSegmentedControl setEnabled:false forSegmentAtIndex:1];
    self.typeSegmentedControl.selectedSegmentIndex = 2;
}

@end
