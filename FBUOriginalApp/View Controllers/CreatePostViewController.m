//
//  CreatePostViewController.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "CreatePostViewController.h"
#import "CreatePostView.h"
#import "SpotifySearchViewController.h"
#import "Post.h"

@interface CreatePostViewController () <CreatePostViewDelegate, SpotifySearchViewControllerDelegate>

@property (strong, nonatomic) IBOutlet CreatePostView *createPostView;
@property (strong, nonatomic) Topic *chosenTopic;

@end

@implementation CreatePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.createPostView.delegate = self;
    [self.createPostView createTopicTapGestureRecognizer];
}

- (IBAction)didTapPost:(id)sender {
    if (self.chosenTopic != nil) {
        [Post createPostWithText:self.createPostView.postTextView.text withId:self.chosenTopic.spotifyId withType:self.chosenTopic.type withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self dismissViewControllerAnimated:true completion:nil];
            } else {
                NSLog(@"error creating post: %@", error.localizedDescription);
            }
        }];
    }
}

- (IBAction)didTapCancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (void)didTapTopic {
    [self performSegueWithIdentifier:@"spotifySearchSegue" sender:nil];
}

- (void)didChooseTopic:(Topic *)topic {
    self.chosenTopic = topic;
    [self.createPostView updateTopic:topic];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"spotifySearchSegue"]) {
        SpotifySearchViewController *spotifySearchViewController = [segue destinationViewController];
        spotifySearchViewController.delegate = self;
    }
}


@end
