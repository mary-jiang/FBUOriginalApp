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

@end
