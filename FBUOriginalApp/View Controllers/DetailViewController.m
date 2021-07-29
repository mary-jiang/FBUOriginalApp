//
//  DetailViewController.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/29/21.
//

#import "DetailViewController.h"
#import "DetailView.h"
#import "APIManager.h"

@interface DetailViewController () <DetailViewDelegate>

@property (strong, nonatomic) IBOutlet DetailView *detailView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailView.delegate = self;
    
    [self.detailView displayPlaceholders];
    
    [self.detailView updateUIBasedOnPost:self.post];
    
    PFUser *author = self.post[@"author"];
    [author fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self.detailView updateUIBasedOnAuthor:(PFUser *)object];
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
                }
            }];
        } else {
            NSLog(@"error liking post: %@", error.localizedDescription);
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
