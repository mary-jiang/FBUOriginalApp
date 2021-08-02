//
//  SpotifySearchViewController.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/12/21.
//

#import "SpotifySearchViewController.h"
#import "SpotifySearchView.h"
#import "APIManager.h"
#import <Parse/Parse.h>
#import "Topic.h"
#import "SpotifyCell.h"

@interface SpotifySearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet SpotifySearchView *spotifySearchView;
@property (strong, nonatomic) NSArray *results;

@end

@implementation SpotifySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.spotifySearchView.searchBar.delegate = self;
    self.spotifySearchView.tableView.delegate = self;
    self.spotifySearchView.tableView.dataSource = self;
    
    if (self.searchSongsOnly) {
        [self.spotifySearchView songsOnly];
    } else if (self.searchArtistsOnly) {
        [self.spotifySearchView artistsOnly];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *query = self.spotifySearchView.searchBar.text;
    NSString *type = [self.spotifySearchView getType];
    
    PFUser *user = [PFUser currentUser];
    NSString *accessCode = user[@"spotifyToken"];
    
    [[APIManager shared] searchSpotifyWithCompletion:query type:type authorization:accessCode completion:^(NSDictionary *results, NSError *error) {
        if (error != nil) {
            NSLog(@"Error making search: %@", error.localizedDescription);
        } else {
            NSString *dictKey = [NSString stringWithFormat:@"%@s", type]; // dictionary has the data we want in "albums/artists/tracks" (depends on type)
            self.results = [Topic topicsWithArray:results[dictKey][@"items"]];
            [self.spotifySearchView.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpotifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpotifyCell"];
    Topic *topic = self.results[indexPath.row];
    cell.topic = topic;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Topic *topic = self.results[indexPath.row];
    [self.delegate didChooseTopic:topic];
    [self.navigationController popViewControllerAnimated:true];
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
