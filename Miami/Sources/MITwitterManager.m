//
//  MITwitterManager.m
//  Miami
//
//  Created by Igor Bogatchuk on 2/28/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import "MITwitterManager.h"
#import "AFNetworking.h"

NSString* const kMIBlogerScreenName = @"euromaidan";

// application credentials
#define kMIConsumerKey @"zjsEZUs1aDBvNGHPuPmuQQ"
#define KMISecretKey @"H3OIKOWHjtO9p4ra6hXAj7bnkmEJ5jZ1GTXGUqTE"

//REST API
#define KMITimeLineRequestURL @"https://api.twitter.com/1.1/statuses/user_timeline.json"
#define kMITokenRequestURL @"https://api.twitter.com/oauth2/token"
#define kMIPOST @"POST"
#define kMIGET @"GET"
#define KMIHeaderContentType @"Content-Type"
#define kMIHeaderAuthorization @"Authorization"
#define KMIAuthorizationTypeBasic @"Basic"
#define KMIAuthorizationTypeBearer @"Bearer"

#define KMITokenRequestContentType @"application/x-www-form-urlencoded;charset=UTF-8"
#define KMITokenRequestBody @"grant_type=client_credentials"

#define KMIScreenNameKey @"screen_name"
#define kMISinceIdKey @"since_id"
#define kMIMaxIdKey @"max_id"
#define kMICountKey @"count"

//Response object parsing key pathes
#define kMITextKeyPath @"text"
#define kMIIDKeyPath @"id"
#define kMICreatedAtKeyPath @"created_at"

#define kMIUserScreenNameKeyPath @"user.screen_name"
#define kMIUserProfileImageURLKeyPath @"user.profile_image_url"
#define kMIUserNameKeyPath @"user.name"
#define kMIMediaURLNameKeyPath @"entities.media.media_url"

#define kMIRTUserNameKeyPath @"retweeted_status.user.name"
#define kMIRTUserScreenNameKeyPath @"retweeted_status.user.screen_name"
#define kMIRTUserProfileImageURLKeyPath @"retweeted_status.user.profile_image_url"
#define kMIRTCreatedAtKeyPath @"retweeted_status.created_at"
#define kMIRTTextKeyPath @"retweeted_status.text"
#define kMIRTMediaURLNameKeyPath @"retweeted_status.entities.media.media_url"
#define kMIRTTextKeyPath @"retweeted_status.text"

#define kMIURLsKey @"entities.urls"
#define kMIDisplayURLKey @"display_url"
#define kMIActualURLKey @"expanded_url"
#define kMIPlaceholderURLKey @"url"

@interface MITwitterManager()
{
    NSString* _accessToken;
    AFJSONResponseSerializer* _responseSerializer;
}

@property (nonatomic, copy) NSString* accesToken;
@property (nonatomic, strong, readonly) AFJSONResponseSerializer* responseSerializer;

@end

@implementation MITwitterManager

- (AFJSONResponseSerializer*)responseSerializer
{
    if (nil == _responseSerializer)
    {
        _responseSerializer = [AFJSONResponseSerializer new];
    }
    return _responseSerializer;
}

- (NSString*)accesToken
{
    if (nil == _accessToken)
    {
        __block BOOL isTokenRequestOperationCompleted = NO;
        NSString *tokenCredentials = [NSString stringWithFormat:@"%@:%@",kMIConsumerKey,KMISecretKey];
        
        NSData *stringData = [tokenCredentials dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64TokenCredentials = [stringData base64EncodedStringWithOptions:0];
        
        NSMutableURLRequest *tokenRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kMITokenRequestURL]];
        [tokenRequest setHTTPMethod:kMIPOST];
        [tokenRequest setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:KMIHeaderContentType];
        [tokenRequest setValue:[NSString stringWithFormat:@"%@ %@",KMIAuthorizationTypeBasic,base64TokenCredentials] forHTTPHeaderField:kMIHeaderAuthorization];
        [tokenRequest setHTTPBody:[NSData dataWithBytes:[KMITokenRequestBody UTF8String] length:strlen([KMITokenRequestBody UTF8String])]];
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:tokenRequest];
        requestOperation.responseSerializer = self.responseSerializer;
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            if ([responseObject[@"token_type"] isEqualToString:@"bearer"])
            {
                _accessToken = responseObject[@"access_token"];
                isTokenRequestOperationCompleted = YES;
            }
        }
        failure:^(AFHTTPRequestOperation* operation, NSError *error)
        {
            NSLog(@"failed to get access token");
            isTokenRequestOperationCompleted = YES;
        }];
        [requestOperation start];
        
        while (isTokenRequestOperationCompleted == NO)
        {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        }
    }
    return _accessToken;
}

- (void)requestTweetsSinceId:(NSString *)sinceId withCompletionHandler:(void(^)(NSArray *tweets))completionHandler
{
    NSString *url = nil;
    
    if (sinceId != nil)
    {
        url = [NSString stringWithFormat:@"%@?%@=%@&%@=%@",KMITimeLineRequestURL,KMIScreenNameKey,kMIBlogerScreenName, kMISinceIdKey,sinceId];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@?%@=%@",KMITimeLineRequestURL,KMIScreenNameKey,kMIBlogerScreenName];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:kMIGET];
    [request setValue:[NSString stringWithFormat:@"%@ %@",KMIAuthorizationTypeBearer,self.accesToken] forHTTPHeaderField:kMIHeaderAuthorization];
    AFHTTPRequestOperation* requestOperation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    requestOperation.responseSerializer = self.responseSerializer;
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSMutableArray* result = [NSMutableArray new];
        for (id tweet in responseObject)
        {
            NSMutableArray *links = [NSMutableArray new];
            
            // links from media
            NSArray *mediaArray = [tweet valueForKeyPath:@"entities.media"];
            for (NSDictionary* mediaItem in mediaArray)
            {
                NSDictionary* link = @{@"displayURL" : mediaItem[@"display_url"],
                                       @"actualURL" : mediaItem[@"expanded_url"],
                                       @"placeholderURL" : mediaItem[@"url"]};
                [links addObject:link];
            }
            
            //links from urls
            NSArray* linksArray = [tweet valueForKeyPath:@"entities.urls"];
            for (NSDictionary* linkItem in linksArray)
            {
                NSDictionary* link = @{@"displayURL" : linkItem[@"display_url"],
                                       @"actualURL" : linkItem[@"expanded_url"],
                                       @"placeholderURL" : linkItem[@"url"]};
                [links addObject:link];
            }
            
            //media urls
            NSMutableArray *media = [NSMutableArray new];
            for (NSDictionary* mediaItem in mediaArray)
            {
                NSDictionary* mediaURL = @{@"mediaURL" : mediaItem[@"media_url"],
                                           @"mediaType" : mediaItem[@"type"]};
                [media addObject:mediaURL];
            }
            
            NSString* text = [tweet valueForKeyPath:@"retweeted_status"] ? [tweet valueForKeyPath:kMIRTTextKeyPath] : [tweet valueForKeyPath:kMITextKeyPath];
            
            NSDictionary* tweetInfo = @{@"date" : [tweet valueForKeyPath:kMICreatedAtKeyPath] ? : @"",
                                        @"isRetweeted" : [tweet valueForKeyPath:@"retweeted_status"] == nil ? @(NO) : @(YES),
                                        @"unique" : [tweet valueForKeyPath:kMIIDKeyPath] ? : @"",
                                        @"userName" : [tweet valueForKeyPath:kMIUserNameKeyPath] ? : @"",
                                        @"userPhotoURL" : [tweet valueForKeyPath:kMIUserProfileImageURLKeyPath] ? : @"",
                                        @"userScreenName" : [tweet valueForKeyPath:kMIUserScreenNameKeyPath] ? : @"",
                                        @"text" : text ? : @"",
                                        @"retweetUserName" : [tweet valueForKeyPath:kMIRTUserNameKeyPath] ? : @"",
                                        @"retweetUserScreenName" : [tweet valueForKeyPath:kMIRTUserScreenNameKeyPath] ? : @"",
                                        @"retweetUserPhotoURL" : [tweet valueForKeyPath:kMIRTUserProfileImageURLKeyPath] ? : @"",
                                        @"media" : media,
                                        @"links" : links};
            
            [result addObject:tweetInfo];
        }
        
        completionHandler([NSArray arrayWithArray:result]);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"failed to get tweets");
    }];
    [requestOperation start];
}

@end
