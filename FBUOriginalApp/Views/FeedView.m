//
//  FeedView.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "FeedView.h"

@implementation FeedView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createTapGestureRecognizers {
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self.tableView addGestureRecognizer:doubleTap];

    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.tableView addGestureRecognizer:singleTap];
}

-(void)singleTap:(UITapGestureRecognizer*)tap {
    if (UIGestureRecognizerStateEnded == tap.state) {
        CGPoint p = [tap locationInView:tap.view];
        NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:p];
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self.delegate singleTappedCell:cell];
    }
}

-(void)doubleTap:(UITapGestureRecognizer*)tap {
    if (UIGestureRecognizerStateEnded == tap.state) {
        CGPoint p = [tap locationInView:tap.view];
        NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:p];
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self.delegate doubleTappedCell:cell];
    }
}

@end
