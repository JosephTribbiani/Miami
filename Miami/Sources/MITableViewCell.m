//
//  MITableViewCell.m
//  Miami
//
//  Created by Igor Bogatchuk on 3/4/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import "MITableViewCell.h"
#import "MITweet.h"
#import "MIMedia.h"
#import "UIImageView+AFNetworking.h"

#define kTextViewWidth 258

@interface MITableViewCell()<UITextViewDelegate>

@end

@implementation MITableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.textView.delegate = self;
    self.textView.contentInset = UIEdgeInsetsZero;
    self.textView.scrollEnabled = NO;
    self.textView.editable = NO;
    self.textView.selectable = YES;
    
    [self.mediaImageView setClipsToBounds:YES];
    self.mediaImageView.layer.cornerRadius = 5;
    self.mediaImageView.layer.masksToBounds = YES;
    
    self.mediaImageView.contentMode = UIViewContentModeScaleAspectFill;
}

#pragma mark -

+ (CGFloat)cellHeightForTwit:(MITweet*)tweet
{
    return 0;
}

#pragma mark -

- (void)setupTextViewWithText:(NSString*)text links:(NSSet*)links
{
    NSAttributedString* attributedString = [[self class] attributedStringForText:text links:links];
    [self.textView setAttributedText:attributedString];
    [self changeTextViewConstraintsToFitAttributedText:attributedString];
}

+ (NSAttributedString*)attributedStringForText:(NSString*)text links:(NSSet*)links
{
    NSMutableAttributedString* attributedString = nil;
    if (links == nil)
    {
        attributedString = [[NSMutableAttributedString alloc] initWithString:text
                                                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                              NSForegroundColorAttributeName: [UIColor blackColor]}];
    }
    else
    {
        id link;
        NSEnumerator *enumerator = [links objectEnumerator];
        while (link = [enumerator nextObject])
        {
            text = [text stringByReplacingOccurrencesOfString:[link valueForKey:@"placeholderURL"] withString:[link valueForKey:@"displayURL"]];
        }
        
        attributedString = [[NSMutableAttributedString alloc] initWithString:text
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
    }
    return [[NSAttributedString alloc] initWithAttributedString:attributedString];
}

- (void)ajustMediaImageViewConstraintsWithTweet:(MITweet*)tweet
{
    MIMedia* media = [tweet.media anyObject];
    NSArray* constraints = self.mediaImageView.constraints;
    for (NSLayoutConstraint* constraint in constraints)
    {
        if (constraint.firstAttribute == NSLayoutAttributeHeight)
        {
            if ([media.type isEqualToString:@"photo"] && media.url != nil)
            {
                constraint.constant = 150;
                [self.mediaImageView setImageWithURL:[NSURL URLWithString:media.url] placeholderImage:[UIImage imageNamed:@"placeholder2.jpg"]];
            }
            else
            {
                [self.mediaImageView setImage:nil];
                constraint.constant = 0;
            }
        }
    }
}

- (void)changeTextViewConstraintsToFitAttributedText:(NSAttributedString *)attributedText
{
    NSArray *textViewConstraints = self.textView.constraints;
    for (NSLayoutConstraint* constraint in textViewConstraints)
    {
        if (constraint.firstAttribute == NSLayoutAttributeHeight)
        {
            constraint.constant = [[self class] textViewHeightForAttributedText:attributedText];
        }
    }
}

+ (CGFloat)textViewHeightForAttributedText:(NSAttributedString*)attributedText
{
    CGRect boundingRect = [attributedText boundingRectWithSize:CGSizeMake(kTextViewWidth - 10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return boundingRect.size.height + 20;
}

- (NSString*)stringFromTimeInterval:(NSTimeInterval)timeInterval
{
    NSInteger integerTimeInterval = (NSInteger)timeInterval;
    NSInteger minutes = (integerTimeInterval / 60) % 60;
    NSInteger hours = (integerTimeInterval / 3600);
    
    if (hours != 0)
    {
        return [NSString stringWithFormat:@" %02ih",hours];
        
    }
    if (minutes != 0)
    {
        return [NSString stringWithFormat:@" %02im",minutes];
    }
    
    return @"01m";
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return YES;
}

@end
