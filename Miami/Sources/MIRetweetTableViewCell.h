//
//  MIRetweetTableViewCell.h
//  Miami
//
//  Created by Igor Bogatchuk on 3/4/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import "MITableViewCell.h"
#import "MITweet.h"

@interface MIRetweetTableViewCell : MITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *retweetTitleLabel;

- (void)setUpWithTweet:(MITweet*)tweet;

@end
