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
        self.image = dictionary[@"images"][0][@"url"]; // get the url from the 1st item in the images array
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
