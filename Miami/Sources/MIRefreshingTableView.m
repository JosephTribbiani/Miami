//
//  AJRefreshingTableView.m
//  Miami
//
//  Created by Igor Bogatchuk on 2/26/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import "MIRefreshingTableView.h"

////////////////////////////////////////////////////////////////////////////////////////////////
#define ANIMATION_DURATION 0.25
#define ACTIVITY_VIEW_HEIGHT 60

@interface MIRefreshingTableView()

@property (nonatomic, assign) BOOL isRefreshing;

@end

@implementation MIRefreshingTableView

- (UIView *)activityView
{
	if (nil == _activityView)
	{
		_activityView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x,
					self.frame.origin.y + 60, self.frame.size.width, ACTIVITY_VIEW_HEIGHT)];
		[_activityView setBackgroundColor:[UIColor clearColor]];
		
	}
	return _activityView;
}

- (UIActivityIndicatorView *)activityIndicatorView
{
	if (nil == _activityIndicatorView)
	{
		_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
					UIActivityIndicatorViewStyleGray];
		[_activityIndicatorView setFrame:CGRectMake(145, 20, 30, 30)];
	}
	return _activityIndicatorView;
}

#pragma mark - private

- (void)removeActivitySpinner
{
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[UIView animateWithDuration:ANIMATION_DURATION animations:^
		{
			[self.activityIndicatorView stopAnimating];
			[self.activityView removeFromSuperview];
			[self reloadData];

			CGRect currentTableRect = [self frame];
			[self setFrame:CGRectMake(currentTableRect.origin.x, currentTableRect.origin.y -
						ACTIVITY_VIEW_HEIGHT, currentTableRect.size.width, currentTableRect.size.height)];
		}];
	});
	self.isRefreshing = NO;
}

- (void)addActivityView
{
	[self.activityView addSubview:self.activityIndicatorView];
	[self.activityIndicatorView startAnimating];
	
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	[window addSubview:self.activityView];
}

#pragma mark - public

- (void)startRefreshing:(void(^)(void))refreshingBlock
				withCompletionHanler:(void(^)(void))completionHandler
{
	if (self.isRefreshing)
	{
		return;
	}
	self.isRefreshing = YES;

	[self addActivityView];
	
	[UIView animateWithDuration:ANIMATION_DURATION animations:^
	{
		 [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + ACTIVITY_VIEW_HEIGHT,
					self.frame.size.width, self.frame.size.height)];
	}
	completion:^(BOOL isFinished)
	{
		if (isFinished)
		{
			dispatch_queue_t theQueue = dispatch_queue_create("MIRefreshingQueue", 0);
			dispatch_async(theQueue, ^
			{
				refreshingBlock();
			});
			dispatch_async(theQueue, ^
			{
				completionHandler();
				[self removeActivitySpinner];
			});
		}
	}];
}

@end
