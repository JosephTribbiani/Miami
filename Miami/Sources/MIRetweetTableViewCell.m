//
//  MIRetweetTableViewCell.m
//  Miami
//
//  Created by Igor Bogatchuk on 3/4/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import "MIRetweetTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MIMedia.h"

#define kTextViewWidth 252

@implementation MIRetweetTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
      [self.retweetTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}
- (void)setUpWithTweet:(MITweet*)tweet
{
    [self.profileImageView.layer setCornerRadius:5];
    [self.profileImageView.layer setMasksToBounds:YES];
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:tweet.retweetUserPhotoURL]
                          placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    
    NSMutableAttributedString *retweetedTitle = [NSMutableAttributedString new];
    [retweetedTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@"Retweeted by "
                                                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                                        NSForegroundColorAttributeName: [UIColor grayColor]}]];
    [retweetedTitle appendAttributedString:[[NSAttributedString alloc] initWithString:tweet.userName
                                                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                                        NSForegroundColorAttributeName: [UIColor grayColor]}]];
    [self.retweetTitleLabel setAttributedText:retweetedTitle];
    
    NSMutableAttributedString* title = [NSMutableAttributedString new];
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:tweet.retweetUserName
                                                                  attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:12]}]];
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  @%@",tweet.userScreenName]
                                                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                               NSForegroundColorAttributeName: [UIColor grayColor]}]];
    
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:[self stringFromTimeInterval:-[tweet.date timeIntervalSinceNow]]
                                                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                               NSForegroundColorAttributeName: [UIColor grayColor]}]];
    [self.titleLabel setAttributedText:title];
    
    [self setupTextViewWithText:tweet.text links:[tweet.links count] != 0 ? tweet.links : nil];
    
    [self ajustMediaImageViewConstraintsWithTweet:tweet];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (CGFloat)cellHeightForTwit:(MITweet*)tweet
{
    NSAttributedString* attributedText = [[self class] attributedStringForText:tweet.text links:tweet.links];
    CGFloat height = [MITableViewCell textViewHeightForAttributedText:attributedText];
    height = height + 40 + (((MIMedia*)[tweet.media anyObject]).url != nil ? 150 : 0);
    return height > 70 ? height : 70;
}

@end
