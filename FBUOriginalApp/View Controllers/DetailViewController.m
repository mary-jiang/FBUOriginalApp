//
//  DetailViewController.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/29/21.
//

#import "DetailViewController.h"
#import "DetailView.h"
#import "APIManager.h"
#import "ProfileViewController.h"

@interface DetailViewController () <DetailViewDelegate>

@property (strong, nonatomic) IBOutlet DetailView *detailView;
@property (strong, nonatomic) PFUser *author;
@property (strong, nonatomic) NSArray *comments;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailView.delegate = self;
    
    [self.detailView createTapGestureRecognizers];
    
    [self.detailView displayPlaceholders];
    
    [self.detailView updateUIBasedOnPost:self.post];
    
    PFUser *author = self.post[@"author"];
    [author fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.author = (PFUser *)object;
        [self.detailView updateUIBasedOnAuthor:self.author];
    }];
    
    [[APIManager shared] getTopicWithCompletion:self.post[@"spotifyId"] type:self.post[@"type"]
                                  authorization:[PFUser currentUser][@"spotifyToken"] completion:^(NSDictionary * topicDictionary, NSError * error) {
        if (error != nil) {
            NSLog(@"get topic for detail view error: %@", error.localizedDescription);
        } else {
            Topic *topic = [[Topic alloc] initWithDictionary:topicDictionary];
            [self.detailView updateUIBasedOnTopic:topic];
        }
    }];
    
    // TODO: finish displaying comments
    PFQuery *commentQuery = [PFQuery queryWithClassName:@"Comment"];
    [commentQuery orderByDescending:@"createdAt"];
    [commentQuery whereKey:@"post" equalTo:self.post];
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error != nil) {
            NSLog(@"error getting comments: %@", error.localizedDescription);
        } else {
            self.comments = objects;
        }
    }];
}

- (void)didTapLike {
    PFUser *user = [PFUser currentUser];
    [Post likePostWithId:self.post.objectId withUserId:user.objectId withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            // fetch the new updated post and give it to the cell to update UI
            PFQuery *query = [PFQuery queryWithClassName:@"Post"];
            [query getObjectInBackgroundWithId:self.post.objectId block:^(PFObject *object, NSError *error) {
                if (error != nil) {
                    NSLog(@"get updated like post error: %@", error.localizedDescription);
                } else {
                    self.post = (Post *) object;
                    [self.detailView updateUIBasedOnPost:self.post];
                }
            }];
        } else {
            NSLog(@"error liking post: %@", error.localizedDescription);
        }
    }];
}

- (void)didTapProfile {
    [self performSegueWithIdentifier:@"profileSegue" sender:nil];
}

- (void)didTapPostCommentWithText:(NSString *)text {
    [self.detailView endEditing:true];
    PFObject *comment = [PFObject objectWithClassName:@"Comment"];
    comment[@"text"] = text;
    comment[@"post"] = self.post;
    comment[@"author"] = [PFUser currentUser];
    [comment saveInBackground];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:@"profileSegue"]) {
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = self.author;
    }
}


@end
