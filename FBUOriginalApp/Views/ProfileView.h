//
//  ProfileView.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ProfileViewDelegate

- (void)didTapProfilePicture;

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

@property (weak, nonatomic) id<ProfileViewDelegate> delegate;

- (void)createAllTapGestureRecognizers;
- (void)updateProfilePicture:(UIImage *)image;
- (void)updateUIBasedOnUser: (PFUser *) user;

@end

NS_ASSUME_NONNULL_END
