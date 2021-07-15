//
//  SpotifySearchResult.m
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/14/21.
//

#import "Topic.h"

@implementation Topic

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.type = dictionary[@"type"];
        self.spotifyId = dictionary[@"id"];
        
        NSArray *images = [NSArray array]; // initialize an images array so we can look for this topic's associated image
        // the image array is stored in different places for tracks compared to albums or artists
        if ([self.type isEqualToString:@"track"]) {
            images = dictionary[@"album"][@"images"];
        } else {
            images = dictionary[@"images"];
        }
        
        // now check if there is anything in images, if so get the image URL from the first item in the array otherwise put in placeholder
        if ([images count] > 0) {
            self.image = images[0][@"url"];
        } else {
            self.image = @"https://www.firstbenefits.org/wp-content/uploads/2017/10/placeholder.png"; // some random placeholder i found on the internet
        }
    }
    return self;
}

+ (NSMutableArray *)topicsWithArray:(NSArray *)dictionaries {
    NSMutableArray *topics = [NSMutableArray array];
    // iterate through each dictionary and create a Topic for each
    for(NSDictionary *dictionary in dictionaries){
        Topic *topic = [[Topic alloc] initWithDictionary:dictionary];
        [topics addObject:topic];
    }
    return topics;
}

@end
