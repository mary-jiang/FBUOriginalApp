//
//  SpotifySearchResult.h
//  FBUOriginalApp
//
//  Created by Mary Jiang on 7/14/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Topic : NSObject

// properties
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *spotifyId;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *image; // associated image URL as a string

// initalizer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

// returns array of Topic objects created from the passed in array of dictionaries
+ (NSMutableArray *)topicsWithArray:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
