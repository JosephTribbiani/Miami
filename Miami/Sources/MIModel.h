//
//  MIModel.h
//  Miami
//
//  Created by Igor Bogatchuk on 2/27/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MITwitterManager.h"
#import "MITweet.h"

@protocol MIModelDelegate <NSObject>

- (void)modelDidUpdate;

@end

@interface MIModel : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) id<MIModelDelegate> delegate;

- (NSURL*)dataStoreURL;

- (void)loadTweetsSinceId:(NSString *)uniqeId;

@end
