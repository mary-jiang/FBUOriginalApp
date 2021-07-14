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

@interface SpotifySearchViewController () <UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet SpotifySearchView *spotifySearchView;
@property (strong, nonatomic) NSArray *results;

@end

@implementation SpotifySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.spotifySearchView.searchBar.delegate = self;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // get the search query and the type of music they want to searchh
    NSString *query = self.spotifySearchView.searchBar.text;
    NSString *type = [self.spotifySearchView getType];
    
    // get the user's authorization information
    PFUser *user = [PFUser currentUser];
    NSString *accessCode = user[@"spotifyToken"];
    
    // make the API call to spotify search API
    [[APIManager shared] searchSpotifyWithCompletion:query type:type authorization:accessCode completion:^(NSDictionary *results, NSError *error) {
        if (error != nil) {
            NSLog(@"Error making search: %@", error.localizedDescription);
        } else {
            NSString *dictKey = [NSString stringWithFormat:@"%@s", type]; // dictionary has the data we want in "albums/artists/tracks" (depends on type)
            self.results = [Topic topicsWithArray:results[dictKey][@"items"]];
        }
    }];
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
