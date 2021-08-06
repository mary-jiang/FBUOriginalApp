//
//  FeedViewController.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "FeedViewController.h"
#import "FeedView.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "SceneDelegate.h"
#import "APIManager.h"
#import "PostCell.h"
#import "Topic.h"
#import "MBProgressHUD.h"
#import "DetailViewController.h"
#import "CreatePostViewController.h"
#import "TopicViewController.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, PostCellDelegate, FeedViewDelegate, CreatePostViewControllerDelegate, DetailViewControllerDelegate>

@property (strong, nonatomic) IBOutlet FeedView *feedView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) PFUser *user;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // TODO: figure out when to refresh user's authorization token, for now just refresh when this feed is seen to ensure a working code (add in error checks here)
    self.user = [PFUser currentUser];
    [[APIManager shared] refreshTokenWithCompletion:self.user[@"refreshToken"] completion:^(NSDictionary *tokens, NSError *error) {
        self.user[@"spotifyToken"] = tokens[@"access_token"];
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self fetchPosts];
        }];
    }];
    
    self.feedView.delegate = self;
    
    [self.feedView createTapGestureRecognizers];
    
    self.feedView.tableView.delegate = self;
    self.feedView.tableView.dataSource = self;
    
    //setup refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor lightGrayColor]];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.feedView.tableView insertSubview:self.refreshControl atIndex:0];
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
    
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;
}

- (IBAction)didTapCreatePost:(id)sender {
    
}

- (void)fetchPosts {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.feedView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Loading Posts";
    
    PFUser *currentUser = [PFUser currentUser];
    NSMutableArray *following = currentUser[@"following"];
    // possibility following is nil, if it is we need to initialize it before adding things
    if (following == nil) {
        following = [NSMutableArray array];
    }
    [following addObject:currentUser.objectId];
    
    NSArray *followingTopics = currentUser[@"followingTopics"];
    
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"author IN %@", following];
    NSPredicate *topicPredicate = [NSPredicate predicateWithFormat:@"spotifyId IN %@", followingTopics];
    
    NSPredicate *combinedPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[userPredicate, topicPredicate]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post" predicate:combinedPredicate];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (error != nil) {
            NSLog(@"Fetch posts error: %@", error.localizedDescription);
        } else {
            self.posts = (NSMutableArray *) posts;
            [following removeObject:currentUser.objectId]; // no longer need to have the current user in their own following
            [self.feedView.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
        [hud hideAnimated:YES];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.posts[indexPath.row];
    [cell displayPlaceholder];
    cell.delegate = self;
    cell.post = post;
    [[APIManager shared] getTopicWithCompletion:post[@"spotifyId"] type:post[@"type"] authorization:self.user[@"spotifyToken"] completion:^(NSDictionary *data, NSError *error) {
        if (error != nil) {
            NSLog(@"get topic for cell error: %@", error.localizedDescription);
        } else {
            Topic *topic = [[Topic alloc] initWithDictionary:data];
            cell.topic = topic;
        }
    }];
    [post[@"author"] fetchIfNeededInBackgroundWithBlock:^(PFObject *author, NSError *error) {
        if (error != nil) {
            NSLog(@"get author for cell error: %@", error.localizedDescription);
        } else {
            cell.author = (PFUser *)author;
        }
    }];
    return cell;
}

// delegate method for post cell that tells us that the username/profile pic in postCell was tapped
- (void)postCellUserTapped:(PostCell *)postCell user:(PFUser *)user {
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

- (void)likedPostCell:(PostCell *)postCell withPost:(Post *)post {
    PFUser *user = [PFUser currentUser];
    [Post likePostWithId:post.objectId withUserId:user.objectId withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            // fetch the new updated post and give it to the cell to update UI
            PFQuery *query = [PFQuery queryWithClassName:@"Post"];
            [query getObjectInBackgroundWithId:post.objectId block:^(PFObject *object, NSError *error) {
                if (error != nil) {
                    NSLog(@"get updated like post error: %@", error.localizedDescription);
                } else {
                    postCell.post = (Post *)object;
                    
                    // update the corrosponding post in the array as well so when this cell goes offscreen and has to be reloaded things update properly
                    for (int i = 0; i < [self.posts count]; i++) {
                        Post *postInArray = [self.posts objectAtIndex:i];
                        if ([postInArray.objectId isEqualToString:object.objectId]) {
                            self.posts[i] = (Post *)object;
                            break;
                        }
                    }
                }
            }];
        } else {
            NSLog(@"error liking post: %@", error.localizedDescription);
        }
    }];
}

- (void)doubleTappedCell:(UITableViewCell *)cell {
    PostCell *postCell = (PostCell *)cell;
    [self likedPostCell:postCell withPost:postCell.post];
}

- (void)singleTappedCell:(UITableViewCell *)cell {
    PostCell *postCell = (PostCell *)cell;
    [self performSegueWithIdentifier:@"detailSegue" sender:postCell.post];
}

- (void)createdPost {
    [self fetchPosts];
}

- (void)likedPostWithId:(NSString *)objectId {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query getObjectInBackgroundWithId:objectId block:^(PFObject *object, NSError *error) {
        if (error != nil) {
            NSLog(@"get updated like post error: %@", error.localizedDescription);
        } else {
            for (int i = 0; i < [self.posts count]; i++) {
                Post *postInArray = [self.posts objectAtIndex:i];
                if ([postInArray.objectId isEqualToString:object.objectId]) {
                    self.posts[i] = (Post *)object;
                    [self.feedView.tableView reloadData];
                    break;
                }
            }
        }
    }];
}

- (void)tappedTopic:(Topic *)topic {
    [self performSegueWithIdentifier:@"topicSegue" sender:topic];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:@"profileSegue"]) {
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = sender;
    } else if ([segue.identifier isEqual:@"detailSegue"]) {
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.delegate = self;
        detailViewController.post = sender;
    } else if ([segue.identifier isEqual:@"createSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        CreatePostViewController *createPostViewController = (CreatePostViewController *)navigationController.topViewController;
        createPostViewController.delegate = self;
    } else if ([segue.identifier isEqual:@"topicSegue"]) {
        TopicViewController *topicViewController = [segue destinationViewController];
        topicViewController.topic = sender;
    }
}


@end
