//
//  ProfileViewController.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "ProfileViewController.h"
#import "ProfileView.h"
#import "APIManager.h"
#import "Topic.h"
#import "SpotifySearchViewController.h"

@interface ProfileViewController () <ProfileViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SpotifySearchViewControllerDelegate>

@property (strong, nonatomic) IBOutlet ProfileView *profileView;
@property (strong, nonatomic) UIImagePickerController *imagePickerVC;
@property (strong, nonatomic) NSString *itemToBeChanged;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.profileView.delegate = self;
    
    // if we were not passed in a user this is the current user's profile, should be able to edit profile picture
    if (self.user == nil) {
        self.user = [PFUser currentUser];
        
        [self.profileView createAllTapGestureRecognizers];
        
        self.imagePickerVC = [UIImagePickerController new];
        self.imagePickerVC.delegate = self;
        self.imagePickerVC.allowsEditing = YES;
        
        // need to check if the camera is supported on device before trying to present it
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            NSLog(@"Camera 🚫 available so we will use photo library instead");
            self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    
    // check if the user already has top artists, if not pull them from spotify (only check 1 because all or nothing)
    if (self.user[@"artist1"] == nil) {
        [[APIManager shared] getTopArtistsWithCompletion:self.user[@"spotifyToken"] completion:^(NSDictionary *results, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", error.localizedDescription);
            } else {
                NSArray *artists = results[@"items"];
                self.user[@"artist1"] = artists[0][@"id"];
                self.user[@"artist2"] = artists[1][@"id"];
                self.user[@"artist3"] = artists[2][@"id"];
                [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        [self updateTopArtists];
                    } else {
                        NSLog(@"%@", error.localizedDescription);
                    }
                }];
            }
        }];
    } else {
        [self updateTopArtists];
    }
    
    // check if the user already has top songs, if not pull them from spotify (only check 1 because all or nothing)
    if (self.user[@"song1"] == nil) {
        [[APIManager shared] getTopSongsWithCompletion:self.user[@"spotifyToken"] completion:^(NSDictionary *results, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", error.localizedDescription);
            } else {
                NSArray *songs = results[@"items"];
                self.user[@"song1"] = songs[0][@"id"];
                self.user[@"song2"] = songs[1][@"id"];
                self.user[@"song3"] = songs[2][@"id"];
                [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        [self updateTopSongs];
                    } else {
                        NSLog(@"%@", error.localizedDescription);
                    }
                }];
            }
        }];
    } else {
        [self updateTopSongs];
    }
    
    
    [self.profileView updateUIBasedOnUser:self.user];
}

- (void)updateTopArtists {
    NSString *allIds = [NSString stringWithFormat:@"%@,%@,%@", self.user[@"artist1"], self.user[@"artist2"], self.user[@"artist3"]];
    [[APIManager shared] getMultipleTopicsWithCompletion:allIds type:@"artist" authorization:self.user[@"spotifyToken"] completion:^(NSDictionary *results, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSArray *artists = [Topic topicsWithArray:results[@"artists"]];
            [self.profileView updateAllArtistsWithTopics:artists];
        }
    }];
}

- (void)updateTopSongs {
    NSString *allIds = [NSString stringWithFormat:@"%@,%@,%@", self.user[@"song1"], self.user[@"song2"], self.user[@"song3"]];
    [[APIManager shared] getMultipleTopicsWithCompletion:allIds type:@"track" authorization:self.user[@"spotifyToken"] completion:^(NSDictionary *results, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSArray *songs = [Topic topicsWithArray:results[@"tracks"]];
            [self.profileView updateAllSongsWithTopics:songs];
        }
    }];
}

- (void)didTapProfilePicture {
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

- (void)didTapArtist1 {
    self.itemToBeChanged = @"artist1";
    [self performSegueWithIdentifier:@"spotifySegue" sender:@"artist"];
}

- (void)didTapArtist2 {
    self.itemToBeChanged = @"artist2";
    [self performSegueWithIdentifier:@"spotifySegue" sender:@"artist"];
}

- (void)didTapArtist3 {
    self.itemToBeChanged = @"artist3";
    [self performSegueWithIdentifier:@"spotifySegue" sender:@"artist"];
}

- (void)didTapSong1 {
    self.itemToBeChanged = @"song1";
    [self performSegueWithIdentifier:@"spotifySegue" sender:@"song"];
}

- (void)didTapSong2 {
    self.itemToBeChanged = @"song2";
    [self performSegueWithIdentifier:@"spotifySegue" sender:@"song"];
}

- (void)didTapSong3 {
    self.itemToBeChanged = @"song3";
    [self performSegueWithIdentifier:@"spotifySegue" sender:@"song"];
}

- (void)didChooseTopic:(Topic *)topic {
    if ([self.itemToBeChanged isEqual:@"artist1"]) {
        self.user[@"artist1"] = topic.spotifyId;
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self.profileView updateArtist1WithTopic:topic];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    } else if ([self.itemToBeChanged isEqual:@"artist2"]) {
        self.user[@"artist2"] = topic.spotifyId;
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self.profileView updateArtist2WithTopic:topic];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    } else if ([self.itemToBeChanged isEqual:@"artist3"]) {
        self.user[@"artist3"] = topic.spotifyId;
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self.profileView updateArtist3WithTopic:topic];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    } else if ([self.itemToBeChanged isEqual:@"song1"]) {
        self.user[@"song1"] = topic.spotifyId;
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self.profileView updateSong1WithTopic:topic];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    } else if ([self.itemToBeChanged isEqual:@"song2"]) {
        self.user[@"song2"] = topic.spotifyId;
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self.profileView updateSong2WithTopic:topic];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    } else if ([self.itemToBeChanged isEqual:@"song3"]) {
        self.user[@"song3"] = topic.spotifyId;
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self.profileView updateSong3WithTopic:topic];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(100.0, 100.0)];
    
    [self.profileView updateProfilePicture:resizedImage];
    
    self.user[@"profilePicture"] = [self getPFFileFromImage:resizedImage];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Profile picture saved successfully");
        } else {
            NSLog(@"Problem saving profile picture: %@", error.localizedDescription);
        }
    }];
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:@"spotifySegue"]) {
        SpotifySearchViewController *spotifySearchViewController = [segue destinationViewController];
        spotifySearchViewController.delegate = self;
        if ([sender isEqual:@"artist"]) {
            spotifySearchViewController.searchArtistsOnly = true;
            spotifySearchViewController.searchSongsOnly = false;
        } else if ([sender isEqual:@"song"]) {
            spotifySearchViewController.searchSongsOnly = true;
            spotifySearchViewController.searchArtistsOnly = false;
        } else {
            spotifySearchViewController.searchSongsOnly = false;
            spotifySearchViewController.searchArtistsOnly = false;
        }
    }
    
}


@end
