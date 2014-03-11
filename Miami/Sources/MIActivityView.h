//
//  MIActivityView.h
//  Miami
//
//  Created by Igor Bogatchuk on 3/9/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIActivityView : UIView

- (void)flipArrow;

- (void)flipDirect;
- (void)flipReverse;

- (void)startAnimating;
- (void)stopAnimating;

@end
