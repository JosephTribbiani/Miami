//
//  MITweetCell+Tweet.m
//  Miami
//
//  Created by Igor Bogatchuk on 3/4/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import "MITweetCell+Tweet.h"
#import "UIImageView+AFNetworking.h"

@implementation MITweetCell (Tweet)

- (void)setUpWithTweet:(MITweet*)tweet
{
    [self.profileImageView.layer setCornerRadius:5];
    [self.profileImageView.layer setMasksToBounds:YES];
    
    [self.profileImageView setImageWithURL:[tweet.isRetweeted boolValue] == YES ? [NSURL URLWithString:tweet.retweetUserPhotoURL] : [NSURL URLWithString:tweet.userPhotoURL]
                          placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    
    NSMutableAttributedString* title = [NSMutableAttributedString new];
    
    
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:tweet.userName
                                                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}]];
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  @%@",tweet.userScreenName]
                                                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                               NSForegroundColorAttributeName: [UIColor grayColor]}]];

    [title appendAttributedString:[[NSAttributedString alloc] initWithString:[self stringFromTimeInterval:-[tweet.date timeIntervalSinceNow]]
                                                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                               NSForegroundColorAttributeName: [UIColor grayColor]}]];
    [self.titleLabel setAttributedText:title];
    
    [self setupTextViewWithText:tweet.text links:[tweet.links count] != 0 ? tweet.links : nil];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark -

- (void)setupTextViewWithText:(NSString*)text links:(NSSet*)links
{
    if (links == nil)
    {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text
                                                                                             attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                                                          NSForegroundColorAttributeName: [UIColor blackColor]}];
        [self.textView setAttributedText:attributedString];
        [self changeTextViewConstraintsToFitAttributedText:attributedString];
    }
    else
    {
        id link;
        NSEnumerator *enumerator = [links objectEnumerator];
        while (link = [enumerator nextObject])
        {
            text = [text stringByReplacingOccurrencesOfString:[link valueForKey:@"placeholderURL"] withString:[link valueForKey:@"displayURL"]];
        }
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text
                                                                                             attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                                                          NSForegroundColorAttributeName: [UIColor blackColor]}];
        enumerator = [links objectEnumerator];
        while (link = [enumerator nextObject])
        {
            NSDictionary *linksAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                              NSForegroundColorAttributeName: [UIColor blueColor],
                                              NSLinkAttributeName : [NSURL URLWithString:[link valueForKey:@"actualURL"]]};
            [attributedString setAttributes:linksAttributes range:[text rangeOfString:[link valueForKey:@"displayURL"]]];
        }
        
        [self.textView setAttributedText:attributedString];
        [self changeTextViewConstraintsToFitAttributedText:attributedString];
    }
}

- (void)changeTextViewConstraintsToFitAttributedText:(NSAttributedString *)attributedText
{
    NSArray *textViewConstraints = self.textView.constraints;
    for (NSLayoutConstraint* constraint in textViewConstraints)
    {
        if (constraint.firstAttribute == NSLayoutAttributeHeight)
        {
            constraint.constant = [self textViewHeightForAttributedText:attributedText];
        }
    }
}

- (CGFloat)textViewHeightForAttributedText:(NSAttributedString*)attributedText
{
    CGRect boundingRect = [attributedText boundingRectWithSize:CGSizeMake(self.textView.frame.size.width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil];
    return boundingRect.size.height + 10;
}

- (NSString*)stringFromTimeInterval:(NSTimeInterval)timeInterval
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

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return YES;
}

@end
