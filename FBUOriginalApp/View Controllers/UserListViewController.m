//
//  UserListViewController.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 8/4/21.
//

#import "UserListViewController.h"
#import "UserListView.h"
#import "UserListCell.h"

@interface UserListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UserListView *userListView;

@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userListView.tableView.delegate = self;
    self.userListView.tableView.dataSource = self;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserListCell *cell = [self.userListView.tableView dequeueReusableCellWithIdentifier:@"UserListCell"];
    NSString *userId = self.users[indexPath.row];
    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:userId block:^(PFObject *object, NSError *error) {
        if (error != nil) {
            NSLog(@"error getting user: %@", error.localizedDescription);
        } else {
            cell.user = (PFUser *)object;
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
