//
//  Post.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/14/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) PFUser *author;

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *spotifyId;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSArray *likedBy;
@property (strong, nonatomic) NSNumber *likeCount;


@end

NS_ASSUME_NONNULL_END
