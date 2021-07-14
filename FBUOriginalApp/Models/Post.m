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

@end
