//
//  MIActivityView.m
//  Miami
//
//  Created by Igor Bogatchuk on 3/9/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import "MIActivityView.h"

#define INDICATOR_SIDE 30
#define ANIMATION_DURATION 0.2

@interface MIActivityView()

@property (nonatomic, strong) UIActivityIndicatorView* activityIndicator;
@property (nonatomic, strong) UIImageView* arrowImageView;

@end

@implementation MIActivityView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    	_activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(frame.size.width/2 - INDICATOR_SIDE/2, frame.size.height/2 - INDICATOR_SIDE/2, INDICATOR_SIDE, INDICATOR_SIDE)];
		[_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityIndicator];
        
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2 - INDICATOR_SIDE/2, frame.size.height/2 - INDICATOR_SIDE/2, INDICATOR_SIDE, INDICATOR_SIDE)];
        [_arrowImageView setImage:[UIImage imageNamed:@"arrow.gif"]];
        [_arrowImageView setHidden:NO];
    	[self addSubview:_arrowImageView];
    }
    return self;
}

- (void)flipArrow
{
	[UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
    } completion:^(BOOL finished) {
        NSLog(@"flipped");
    }];
}

- (void)flipDirect
{
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI * 0 / 180.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)flipReverse
{
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)startAnimating
{
    [self.arrowImageView setHidden:YES];
    [self.activityIndicator startAnimating];
}

- (void)stopAnimating
{
	[self.arrowImageView setHidden:NO];
    [self.activityIndicator stopAnimating];
}

@end
