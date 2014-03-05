//
//  MITweet.h
//  Miami
//
//  Created by Igor Bogatchuk on 3/5/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MILink, MIMedia;

@interface MITweet : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * isRetweeted;
@property (nonatomic, retain) NSString * retweetScreenName;
@property (nonatomic, retain) NSString * retweetUserName;
@property (nonatomic, retain) NSString * retweetUserPhotoURL;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userPhotoURL;
@property (nonatomic, retain) NSString * userScreenName;
@property (nonatomic, retain) NSSet *links;
@property (nonatomic, retain) NSSet *media;
@end

@interface MITweet (CoreDataGeneratedAccessors)

- (void)addLinksObject:(MILink *)value;
- (void)removeLinksObject:(MILink *)value;
- (void)addLinks:(NSSet *)values;
- (void)removeLinks:(NSSet *)values;

- (void)addMediaObject:(MIMedia *)value;
- (void)removeMediaObject:(MIMedia *)value;
- (void)addMedia:(NSSet *)values;
- (void)removeMedia:(NSSet *)values;

@end
