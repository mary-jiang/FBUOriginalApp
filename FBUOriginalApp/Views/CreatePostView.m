//
//  CreatePostView.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "CreatePostView.h"

@implementation CreatePostView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createTopicTapGestureRecognizer {
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapTopic)];
    [self.chosenTopicWrapper addGestureRecognizer:profileTapGestureRecognizer];
    [self.chosenTopicWrapper setUserInteractionEnabled:true];
}

// tell the delegate that the topic section was tapped
- (void)didTapTopic {
    [self.delegate didTapTopic];
}

- (void)updateTopic:(Topic *)topic {
    self.chosenTopicLabel.text = topic.name;
    NSURL *imageURL = [NSURL URLWithString:topic.image];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    self.chosenTopicImageView.image = [UIImage imageWithData:imageData];
}

@end
