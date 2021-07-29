//
//  DetailViewController.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/29/21.
//

#import "DetailViewController.h"
#import "DetailView.h"
#import "APIManager.h"

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet DetailView *detailView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.detailView displayPlaceholders];
    
    PFUser *author = self.post[@"author"];
    [author fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self.detailView updateUIBasedOnAuthor:(PFUser *)object];
    }];
    
//    [[APIManager shared] getTopicWithCompletion:self.post[@"spotifyId"] type:self.post[@"type"]
//                                  authorization:[PFUser currentUser][@"spotifyToken"] completion:^(NSDictionary * topic, NSError * error) {
//        if (error != nil) {
//            NSLog(@"get topic for detail view error: %@", error.localizedDescription);
//        } else {
//
//        }
//    }];
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
