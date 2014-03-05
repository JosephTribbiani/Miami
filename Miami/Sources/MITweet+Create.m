//
//  MITweet+Create.m
//  Miami
//
//  Created by Igor Bogatchuk on 2/28/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import "MITweet+Create.h"
#import "MILink.h"
#import "MIMedia.h"

@implementation MITweet (Create)

+ (MITweet *)tweetWithTweetManagerInfo:(NSDictionary*)tweetInfo inManagedObjectContext:(NSManagedObjectContext*)context
{
    MITweet* tweet = nil;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"MITweet"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@",[tweetInfo objectForKey:@"id"]];
    NSSortDescriptor* sortDescriptior = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    request.sortDescriptors = @[sortDescriptior];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1))
    {
        // handle error
    }
    else if ([matches count] == 0)
    {
        tweet = [NSEntityDescription insertNewObjectForEntityForName:@"MITweet" inManagedObjectContext:context];
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss ZZZZ yyyy"];
        tweet.date = [dateFormatter dateFromString:tweetInfo[@"date"]];
        tweet.unique = [tweetInfo[@"unique"] stringValue];
        tweet.userName = tweetInfo[@"userName"];
        tweet.userPhotoURL = tweetInfo[@"userPhotoURL"];
        tweet.userScreenName = tweetInfo[@"userScreenName"];
        tweet.text = tweetInfo[@"text"];
        tweet.retweetUserName = tweetInfo[@"retweetUserName"];
        tweet.retweetScreenName = tweetInfo[@"retweetUserScreenName"];
        tweet.retweetUserPhotoURL = tweetInfo[@"retweetUserPhotoURL"];
        tweet.isRetweeted = tweetInfo[@"isRetweeted"];
        
        NSMutableSet* tweetLinks = [tweet mutableSetValueForKey:@"links"];
        
        for (id linkDictionary in tweetInfo[@"links"])
        {
            MILink* link = [NSEntityDescription insertNewObjectForEntityForName:@"MILink" inManagedObjectContext:context];
            link.actualURL = linkDictionary[@"actualURL"];
            link.displayURL = linkDictionary[@"displayURL"];
            link.placeholderURL = linkDictionary[@"placeholderURL"];
            [tweetLinks addObject:link];
        }
        
        NSMutableSet* media = [tweet mutableSetValueForKey:@"media"];
        
        for (id mediaDictionary in tweetInfo[@"media"])
        {
            MIMedia* mediaItem = [NSEntityDescription insertNewObjectForEntityForName:@"MIMedia" inManagedObjectContext:context];
            mediaItem.url = mediaDictionary[@"mediaURL"];
            mediaItem.type = mediaDictionary[@"mediaType"];
            [media addObject:mediaItem];
        }
    }
    else
    {
        tweet = [matches lastObject];
    }
    return tweet;
}

@end
