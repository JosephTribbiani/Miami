//
//  AJRefreshingTableView.h
//  Miami
//
//  Created by Igor Bogatchuk on 2/26/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIRefreshingTableView : UITableView

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIView *activityView;


- (void)startRefreshing:(void(^)(void))refreshingBlock
			withCompletionHanler:(void(^)(void))completionHandler;
@end

