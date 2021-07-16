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

@interface ProfileViewController () <ProfileViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet ProfileView *profileView;
@property (strong, nonatomic) UIImagePickerController *imagePickerVC;

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
    
    [self.profileView updateUIBasedOnUser:self.user];
}

- (void)updateTopArtists {
    [[APIManager shared] getTopicWithCompletion:self.user[@"artist1"] type:@"artist" authorization:self.user[@"spotifyToken"]  completion:^(NSDictionary *result, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            Topic *topic = [[Topic alloc] initWithDictionary:result];
            [self.profileView updateArtist1WithTopic:topic];
        }
    }];
    [[APIManager shared] getTopicWithCompletion:self.user[@"artist2"] type:@"artist" authorization:self.user[@"spotifyToken"]  completion:^(NSDictionary *result, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            Topic *topic = [[Topic alloc] initWithDictionary:result];
            [self.profileView updateArtist2WithTopic:topic];
        }
    }];
    [[APIManager shared] getTopicWithCompletion:self.user[@"artist3"] type:@"artist" authorization:self.user[@"spotifyToken"]  completion:^(NSDictionary *result, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            Topic *topic = [[Topic alloc] initWithDictionary:result];
            [self.profileView updateArtist3WithTopic:topic];
        }
    }];
}

- (void)didTapProfilePicture {
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
