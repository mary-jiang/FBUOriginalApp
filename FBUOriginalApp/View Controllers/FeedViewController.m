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
#import "SceneDelegate.h"
#import "APIManager.h"
#import "PostCell.h"
#import "Topic.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet FeedView *feedView;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) PFUser *user;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // TODO: figure out when to refresh user's authorization token, for now just refresh when this feed is seen to ensure a working code
    PFUser *user = [PFUser currentUser];
    self.user = user;
    [[APIManager shared] refreshTokenWithCompletion:user[@"refreshToken"] completion:^(NSDictionary *tokens, NSError *error) {
        self.user[@"spotifyToken"] = tokens[@"access_token"];
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self fetchPosts];
        }];
    }];
    
    self.feedView.tableView.delegate = self;
    self.feedView.tableView.dataSource = self;
    
    //setup refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
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
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError * error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            self.posts = posts;
            [self.feedView.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.posts[indexPath.row];
    cell.post = post;
    [[APIManager shared] getTopicWithCompletion:post[@"spotifyId"] type:post[@"type"] authorization:self.user[@"spotifyToken"] completion:^(NSDictionary *data, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            Topic *topic = [[Topic alloc] initWithDictionary:data];
            cell.topic = topic;
        }
    }];
    [post[@"author"] fetchIfNeededInBackgroundWithBlock:^(PFObject *author, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            cell.author = (PFUser *)author;
        }
    }];
    return cell;
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
