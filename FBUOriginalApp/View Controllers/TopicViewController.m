//
//  TopicViewController.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 8/4/21.
//

#import "TopicViewController.h"
#import "TopicView.h"
#import "TopicPostCell.h"
#import <Parse/Parse.h>
#import "ProfileViewController.h"

@interface TopicViewController () <UITableViewDelegate, UITableViewDataSource, TopicPostCellDelegate>

@property (strong, nonatomic) IBOutlet TopicView *topicView;
@property (strong, nonatomic) NSMutableArray *posts;

@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.topicView updateUIBasedOnTopic:self.topic];
    
    self.topicView.tableView.delegate = self;
    self.topicView.tableView.dataSource = self;
    
    [self fetchPosts];
}

- (void)fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"spotifyId" equalTo:self.topic.spotifyId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error != nil) {
            
        } else {
            self.posts = (NSMutableArray *)objects;
            [self.topicView.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicPostCell *cell = [self.topicView.tableView dequeueReusableCellWithIdentifier:@"TopicPostCell"];
    cell.delegate = self;
    Post *post = self.posts[indexPath.row];
    cell.post = post;
    [post[@"author"] fetchIfNeededInBackgroundWithBlock:^(PFObject *author, NSError *error) {
        if (error != nil) {
            NSLog(@"get author for cell error: %@", error.localizedDescription);
        } else {
            cell.author = (PFUser *)author;
        }
    }];
    return cell;
}

- (void)tappedUser:(PFUser *)user {
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

- (void)likedTopicPostCell:(TopicPostCell *)cell withPost:(Post *)post {
    PFUser *user = [PFUser currentUser];
    [Post likePostWithId:post.objectId withUserId:user.objectId withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            // fetch the new updated post and give it to the cell to update UI
            PFQuery *query = [PFQuery queryWithClassName:@"Post"];
            [query getObjectInBackgroundWithId:post.objectId block:^(PFObject *object, NSError *error) {
                if (error != nil) {
                    NSLog(@"get updated like post error: %@", error.localizedDescription);
                } else {
                    cell.post = (Post *)object;
                    
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:@"profileSegue"]) {
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = sender;
    }
}


@end
