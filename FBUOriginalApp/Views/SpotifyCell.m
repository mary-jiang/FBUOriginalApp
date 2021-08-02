//
//  SpotifyCell.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "SpotifyCell.h"

@implementation SpotifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTopic:(Topic *)topic {
    _topic = topic;
    
    self.nameLabel.text = self.topic.name;
    
    self.associatedImageView.layer.cornerRadius = 5;
    NSURL *imageURL = [NSURL URLWithString:self.topic.image];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    self.associatedImageView.image = [UIImage imageWithData:imageData];
}

@end
