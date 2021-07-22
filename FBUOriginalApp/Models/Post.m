//
//  Post.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/14/21.
//

#import "Post.h"

@implementation Post

@dynamic objectId;
@dynamic author;

@dynamic text;
@dynamic spotifyId;
@dynamic type;
@dynamic likedBy;
@dynamic likeCount;

+ (void) createPostWithText: (NSString *)text withId: (NSString *)spotifyId withType: (NSString *)type withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    // create the Post object and fill in the information
    Post *newPost = [[Post alloc] initWithClassName:@"Post"];
    newPost.author = [PFUser currentUser];
    newPost.text = text;
    newPost.spotifyId = spotifyId;
    newPost.type = type;
    newPost.likeCount = @(0);
    
    // save this new Post to Parse
    [newPost saveInBackgroundWithBlock: completion];
}

+ (void) likePostWithId:(NSString *)postId withUserId: (NSString *)userId withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    // look up post in backend in order to update
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query getObjectInBackgroundWithId:postId block:^(PFObject *post, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSArray *likedUsers = post[@"likedBy"];
            // if this user has already liked the post we have to unlike it, otherwise like it
            if (likedUsers != nil && [likedUsers containsObject:userId]) {
                [post incrementKey:@"likeCount" byAmount:[NSNumber numberWithInt:-1]];
                [post removeObject:userId forKey:@"likedBy"];
            } else {
                [post incrementKey:@"likeCount"];
                [post addObject:userId forKey:@"likedBy"];
            }
            [post saveInBackgroundWithBlock:completion];
        }
    }];
}

@end
