//
//  MITweetTableView.h
//  Miami
//
//  Created by Igor Bogatchuk on 3/4/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import "MITableViewCell.h"
#import "MITweet.h"

@interface MITweetTableViewCell : MITableViewCell

- (void)setUpWithTweet:(MITweet*)tweet;

@end
