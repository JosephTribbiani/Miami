//
//  MITweet+Create.h
//  Miami
//
//  Created by Igor Bogatchuk on 2/28/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import "MITweet.h"

@interface MITweet (Create)

+ (MITweet *)tweetWithTweetManagerInfo:(NSDictionary*)tweetInfo inManagedObjectContext:(NSManagedObjectContext*)context;

@end
