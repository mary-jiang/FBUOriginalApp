//
//  ProfileView.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Topic.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ProfileViewDelegate

- (void)didTapProfilePicture;

- (void)didTapArtist1;
- (void)didTapArtist2;
- (void)didTapArtist3;

- (void)didTapSong1;
- (void)didTapSong2;
- (void)didTapSong3;

- (void)didTapFollowers;
- (void)didTapFollowing;
- (void)didTapFollow;

@end

@interface ProfileView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artist1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *artist2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *artist3ImageView;
@property (weak, nonatomic) IBOutlet UILabel *artist1Label;
@property (weak, nonatomic) IBOutlet UILabel *artist2Label;
@property (weak, nonatomic) IBOutlet UILabel *artist3Label;
@property (weak, nonatomic) IBOutlet UIImageView *song1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *song2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *song3ImageView;
@property (weak, nonatomic) IBOutlet UILabel *song1Label;
@property (weak, nonatomic) IBOutlet UILabel *song2Label;
@property (weak, nonatomic) IBOutlet UILabel *song3Label;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;

@property (weak, nonatomic) id<ProfileViewDelegate> delegate;

- (void)createAllTapGestureRecognizers;
- (void)createFollowRelatedTapGestureRecognizers;
- (void)disableFollowing;
- (void)updateFollowButton:(BOOL)following;
- (void)updateProfilePicture:(UIImage *)image;
- (void)updateUIBasedOnUser:(PFUser *)user;
- (void)displayBeforeLoadingPlaceholders;
- (void)displayNoArtistDataPlaceholders;
- (void)displayNoSongDataPlaceholders;
- (void)updateFollowersLabelWithNumber:(NSUInteger)numOfFollowers;

- (void)updateAllArtistsWithTopics:(NSArray *)topics;
- (void)updateArtist1WithTopic:(Topic *)topic;
- (void)updateArtist2WithTopic:(Topic *)topic;
- (void)updateArtist3WithTopic:(Topic *)topic;

- (void)updateAllSongsWithTopics:(NSArray *)topics;
- (void)updateSong1WithTopic:(Topic *)topic;
- (void)updateSong2WithTopic:(Topic *)topic;
- (void)updateSong3WithTopic:(Topic *)topic;

@end

NS_ASSUME_NONNULL_END
