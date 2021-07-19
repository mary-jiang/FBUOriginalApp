//
//  UserSearchViewController.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "UserSearchViewController.h"
#import "UserSearchView.h"
#import <Parse/Parse.h>
#import "UserCell.h"

@interface UserSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UserSearchView *userSearchView;
@property (strong, nonatomic) NSArray *users;

@end

@implementation UserSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userSearchView.searchBar.delegate = self;
    
    self.userSearchView.tableView.delegate = self;
    self.userSearchView.tableView.dataSource = self;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self getUsersBasedOnQuery:self.userSearchView.searchBar.text];
}

- (void)getUsersBasedOnQuery:(NSString *)search {
    NSString *formattedQuery = [NSString stringWithFormat:@"username BEGINSWITH '%@'", search];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:formattedQuery];
//    PFQuery *query = [PFQuery queryWithClassName:@"User" predicate:predicate];
    PFQuery *query = [PFUser queryWithPredicate:predicate];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            self.users = results;
            [self.userSearchView.tableView reloadData];
        }
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = [self.userSearchView.tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    PFUser *user = self.users[indexPath.row];
    [user fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        cell.user = (PFUser *)object;
    }];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
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
