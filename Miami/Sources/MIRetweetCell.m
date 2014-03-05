//
//  MIRetweetCell.m
//  Miami
//
//  Created by Igor Bogatchuk on 3/2/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import "MIRetweetCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MIRetweetCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpWithUserName:(NSString*)userName
        retweetedUserName:(NSString*)retweetedUserName
  retweetedUserScreenName:(NSString*)retweetedUserScreenName
                     date:(NSDate*)date
                     text:(NSString*)text
                 photoURL:(NSString*)url
{
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    [self.profileImageView.layer setCornerRadius:5];
    [self.profileImageView.layer setMasksToBounds:YES];
    NSMutableAttributedString *retweetedTitle = [NSMutableAttributedString new];
    [retweetedTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@"Retweeted by "
                                                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10],
                                                                                        NSForegroundColorAttributeName: [UIColor grayColor]}]];
    [retweetedTitle appendAttributedString:[[NSAttributedString alloc] initWithString:userName
                                                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10],
                                                                                        NSForegroundColorAttributeName: [UIColor grayColor]}]];
    [self.retweetTitleLabel setAttributedText:retweetedTitle];
    
    NSMutableAttributedString* title = [[NSMutableAttributedString alloc] init];
    
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:retweetedUserName
                                                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}]];
    
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  @%@",retweetedUserScreenName]
                                                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                               NSForegroundColorAttributeName: [UIColor grayColor]}]];
    
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:[self stringFromTimeInterval:-[date timeIntervalSinceNow]]
                                                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                               NSForegroundColorAttributeName: [UIColor grayColor]}]];
    [self.titleLabel setAttributedText:title];
    
    [self.textView setText:text];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval
{
    NSInteger integerTimeInterval = (NSInteger)timeInterval;
    NSInteger minutes = (integerTimeInterval / 60) % 60;
    NSInteger hours = (integerTimeInterval / 3600);
    
    NSMutableString *string = [NSMutableString new];
    
    if (hours != 0)
    {
        [string appendString:[NSString stringWithFormat:@" %02ih",hours]];
    }
    if (minutes != 0)
    {
        [string appendString:[NSString stringWithFormat:@" %02im",minutes]];
    }
    
    return [NSString stringWithString:string];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [self.imageView setFrame:CGRectMake(4, 20, 50, 50)];
}

@end
