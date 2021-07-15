//
//  CreatePostViewController.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "CreatePostViewController.h"
#import "CreatePostView.h"
#import "SpotifySearchViewController.h"

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
    
}

- (IBAction)didTapCancel:(id)sender {
    
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
