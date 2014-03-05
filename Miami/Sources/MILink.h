//
//  MILink.h
//  Miami
//
//  Created by Igor Bogatchuk on 3/5/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MILink : NSManagedObject

@property (nonatomic, retain) NSString * actualURL;
@property (nonatomic, retain) NSString * displayURL;
@property (nonatomic, retain) NSString * placeholderURL;

@end
