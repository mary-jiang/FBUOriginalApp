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
#import "ProfileViewController.h"
#import "MatchingHelper.h"
#import "MBProgressHUD.h"

@interface UserSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UserSearchView *userSearchView;
@property (strong, nonatomic) NSArray *users;
@property (nonatomic) BOOL showingRecommendation;

@end

@implementation UserSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userSearchView.searchBar.delegate = self;
    
    self.userSearchView.tableView.delegate = self;
    self.userSearchView.tableView.dataSource = self;
    
    [self showRecommendedUser];
}

- (void)showRecommendedUser {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.userSearchView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Loading Recommended User";
    
    PFUser *currentUser = [PFUser currentUser];
    PFUser *recommendedUser = currentUser[@"recommendedUser"];
    
    if (recommendedUser) {
        NSMutableArray *recommendedUsers = [NSMutableArray array];
        [recommendedUsers addObject:recommendedUser];
        self.users = (NSArray *) recommendedUsers;
        self.showingRecommendation = true;
        [self.userSearchView.tableView reloadData];
        [hud hideAnimated:YES];
    } else {
        [MatchingHelper getUserMatchWithCompletion:[PFUser currentUser] completion:^(PFUser *user, NSError *error) {
            if (error != nil) {
                NSLog(@"Error recommending user: %@", error.localizedDescription);
            } else {
                currentUser[@"recommendedUser"] = user;
                [currentUser saveInBackground];
                
                NSMutableArray *recommendedUsers = [NSMutableArray array];
                [recommendedUsers addObject:user];
                self.users = (NSArray *) recommendedUsers;
                self.showingRecommendation = true;
                [self.userSearchView.tableView reloadData];
                [hud hideAnimated:YES];
            }
        }];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self getUsersBasedOnQuery:self.userSearchView.searchBar.text];
}

- (void)getUsersBasedOnQuery:(NSString *)search {
    NSString *formattedSearch = [NSString stringWithFormat:@"username BEGINSWITH '%@'", search];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:formattedSearch];
    PFQuery *query = [PFUser queryWithPredicate:predicate];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            self.users = results;
            self.showingRecommendation = false;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.showingRecommendation) {
        return @"Recommended User";
    }
    return @"";
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:@"profileSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.userSearchView.tableView indexPathForCell:tappedCell];
        PFUser *user = self.users[indexPath.row];
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = user;
    }
}


@end
