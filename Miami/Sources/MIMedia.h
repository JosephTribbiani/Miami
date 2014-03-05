//
//  MIMedia.h
//  Miami
//
//  Created by Igor Bogatchuk on 3/5/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MIMedia : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * type;

@end
