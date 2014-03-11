//
//  MIModel.m
//  Miami
//
//  Created by Igor Bogatchuk on 2/27/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import "MIModel.h"
#import "MITweet+Create.h"

@interface MIModel()
{
    MITwitterManager* _twitterManager;
}

@property (nonatomic, strong) MITwitterManager* twitterManager;

@end

@implementation MIModel
{
    NSManagedObjectModel* _managedObjectModel;
    NSPersistentStoreCoordinator* _persistentStoreCoordinator;
    NSManagedObjectContext *_managedObjectContext;
}

- (MITwitterManager*)twitterManager
{
    if (_twitterManager == nil)
    {
        _twitterManager = [MITwitterManager new];
    }
    return _twitterManager;
}

- (NSURL*)dataStoreURL
{
    NSString* docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [NSURL fileURLWithPath:[docDirectory stringByAppendingPathComponent:@"DataStrore.sql"]];
}

- (NSManagedObjectModel*)managedObjectModel
{
    if (_managedObjectModel == nil)
    {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator == nil)
    {
        NSError* error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:[self dataStoreURL]
                                                             options:nil
                                                               error:&error])
        {
            NSLog(@"Unresolved Core Data Error with persistantStoreCoordinator: %@ %@", error, [error userInfo]);
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return _managedObjectContext;
}

#pragma mark -

- (void)loadTweetsSinceId:(NSString *)uniqeId
{
    [self.twitterManager requestTweetsSinceId:uniqeId withCompletionHandler:^(NSArray *tweets)
    {
        for (id tweet in tweets)
        {
            [MITweet tweetWithTweetManagerInfo:tweet inManagedObjectContext:self.managedObjectContext];
        }
        if ([self.managedObjectContext hasChanges])
        {
            [self.managedObjectContext save:NULL];
        }
        [self.delegate modelDidUpdate];
    }];
    
}

@end
