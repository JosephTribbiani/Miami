//
//  MITweetCell.m
//  Miami
//
//  Created by Igor Bogatchuk on 3/2/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import "MITweetCell.h"
#import "UIImageView+AFNetworking.h"

#define kTextViewWidth 252

@interface MITweetCell()<UITextViewDelegate>

@end

@implementation MITweetCell

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
    self.textView.textContainer.lineFragmentPadding = 0;
}

#pragma mark - Public

+ (CGFloat)cellHeightForCellWithText:(NSString *)text
{
    NSAttributedString* attributedText = [[NSAttributedString alloc]initWithString:text
                                                                        attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                                     NSForegroundColorAttributeName: [UIColor blackColor]}];
    
    CGRect boundingRect = [attributedText boundingRectWithSize:CGSizeMake(kTextViewWidth, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil];
    CGFloat result = boundingRect.size.height + 10 + 30 ; //+ 150;
    
    return result > 80 ? result : 80;
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
