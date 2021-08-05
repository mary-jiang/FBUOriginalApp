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

@interface TopicViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet TopicView *topicView;
@property (strong, nonatomic) NSArray *posts;

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
            self.posts = objects;
            [self.topicView.tableView reloadData];
        }
    }];
}

- (IBAction)didTapLike:(id)sender {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicPostCell *cell = [self.topicView.tableView dequeueReusableCellWithIdentifier:@"TopicPostCell"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
