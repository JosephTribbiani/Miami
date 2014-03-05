//
//  MITwitterManager.h
//  Miami
//
//  Created by Igor Bogatchuk on 2/28/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MITwitterManager : NSObject

- (void)requestTweetsSinceId:(NSString *)sinceId withCompletionHandler:(void(^)(NSArray *tweets))completionHandler;

@end
