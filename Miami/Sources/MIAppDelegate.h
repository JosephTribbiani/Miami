//
//  MIAppDelegate.h
//  Miami
//
//  Created by Igor Bogatchuk on 2/26/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  MIModel;

@interface MIAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow* window;
@property (strong, nonatomic) MIModel* dataModel;


@end
