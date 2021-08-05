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
#import "CommentCell.h"

@interface DetailViewController () <DetailViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet DetailView *detailView;
@property (strong, nonatomic) PFUser *author;
@property (strong, nonatomic) NSArray *comments;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

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
    
    self.detailView.tableView.delegate = self;
    self.detailView.tableView.dataSource = self;
    
    [self fetchComments];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor lightGrayColor]];
    [self.refreshControl addTarget:self action:@selector(fetchComments) forControlEvents:UIControlEventValueChanged];
    [self.detailView.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchComments {
    PFQuery *commentQuery = [PFQuery queryWithClassName:@"Comment"];
    [commentQuery orderByAscending:@"createdAt"];
    [commentQuery whereKey:@"post" equalTo:self.post];
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error != nil) {
            NSLog(@"error getting comments: %@", error.localizedDescription);
        } else {
            self.comments = objects;
            [self.detailView.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [self.detailView.tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    PFObject *comment = self.comments[indexPath.row];
    cell.comment = comment;
    [comment[@"author"] fetchIfNeededInBackgroundWithBlock:^(PFObject *author, NSError *error) {
        if (error != nil) {
            NSLog(@"get author for cell error: %@", error.localizedDescription);
        } else {
            cell.author = (PFUser *)author;
        }
    }];
    return cell;
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
                    [self.delegate likedPostWithId:self.post.objectId];
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
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self fetchComments];
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
        profileViewController.user = self.author;
    }
}


@end
