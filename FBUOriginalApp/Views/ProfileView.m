//
//  ProfileView.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "ProfileView.h"

@implementation ProfileView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createAllTapGestureRecognizers {
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapProfile)];
    [self.profileImageView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileImageView setUserInteractionEnabled:true];
    
    UITapGestureRecognizer *artist1TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapArtist1)];
    [self.artist1ImageView addGestureRecognizer:artist1TapGestureRecognizer];
    [self.artist1ImageView setUserInteractionEnabled:true];
    
    UITapGestureRecognizer *artist2TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapArtist2)];
    [self.artist2ImageView addGestureRecognizer:artist2TapGestureRecognizer];
    [self.artist2ImageView setUserInteractionEnabled:true];
    
    UITapGestureRecognizer *artist3TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapArtist3)];
    [self.artist3ImageView addGestureRecognizer:artist3TapGestureRecognizer];
    [self.artist3ImageView setUserInteractionEnabled:true];
}

- (void)didTapProfile {
    [self.delegate didTapProfilePicture];
}

- (void)didTapArtist1 {
    [self.delegate didTapArtist1];
}

- (void)didTapArtist2 {
    [self.delegate didTapArtist2];
}

- (void)didTapArtist3 {
    [self.delegate didTapArtist3];
}

- (void)updateProfilePicture:(UIImage *)image {
    self.profileImageView.image = image;
}

- (void)updateUIBasedOnUser: (PFUser *) user{
    self.usernameLabel.text = user[@"username"];
    
    PFFileObject *profilePicture = user[@"profilePicture"];
    if (profilePicture != nil) {
        NSURL *profileURL = [NSURL URLWithString:profilePicture.url];
        NSData *profileData = [NSData dataWithContentsOfURL:profileURL];
        self.profileImageView.image = [UIImage imageWithData:profileData];
    }
}

- (void)updateAllArtistsWithTopics: (NSArray *)topics {
    [self updateArtist1WithTopic:topics[0]];
    [self updateArtist2WithTopic:topics[1]];
    [self updateArtist3WithTopic:topics[2]];
}

- (void)updateArtist1WithTopic: (Topic *) topic{
    self.artist1Label.text = topic.name;
    NSURL *imageURL = [NSURL URLWithString:topic.image];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    self.artist1ImageView.image = [UIImage imageWithData:imageData];
}

- (void)updateArtist2WithTopic: (Topic *) topic{
    self.artist2Label.text = topic.name;
    NSURL *imageURL = [NSURL URLWithString:topic.image];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    self.artist2ImageView.image = [UIImage imageWithData:imageData];
}

- (void)updateArtist3WithTopic: (Topic *) topic{
    self.artist3Label.text = topic.name;
    NSURL *imageURL = [NSURL URLWithString:topic.image];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    self.artist3ImageView.image = [UIImage imageWithData:imageData];
}

- (void)updateAllSongsWithTopics: (NSArray *) topics {
    [self updateSong1WithTopic:topics[0]];
    [self updateSong2WithTopic:topics[1]];
    [self updateSong3WithTopic:topics[2]];
}

- (void)updateSong1WithTopic: (Topic *) topic{
    self.song1Label.text = topic.name;
    NSURL *imageURL = [NSURL URLWithString:topic.image];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    self.song1ImageView.image = [UIImage imageWithData:imageData];
}

- (void)updateSong2WithTopic: (Topic *) topic{
    self.song2Label.text = topic.name;
    NSURL *imageURL = [NSURL URLWithString:topic.image];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    self.song2ImageView.image = [UIImage imageWithData:imageData];
}

- (void)updateSong3WithTopic: (Topic *) topic{
    self.song3Label.text = topic.name;
    NSURL *imageURL = [NSURL URLWithString:topic.image];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    self.song3ImageView.image = [UIImage imageWithData:imageData];
}


@end
