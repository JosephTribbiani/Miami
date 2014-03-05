//
//  MITableViewCell.h
//  Miami
//
//  Created by Igor Bogatchuk on 3/4/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MITweet;

@interface MITableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView* profileImageView;
@property (weak, nonatomic) IBOutlet UITextView* textView;
@property (weak, nonatomic) IBOutlet UIImageView* mediaImageView;

+ (CGFloat)cellHeightForTwit:(MITweet*)tweet;

- (void)setupTextViewWithText:(NSString*)text links:(NSSet*)links;
- (NSString*)stringFromTimeInterval:(NSTimeInterval)timeInterval;

+ (NSAttributedString*)attributedStringForText:(NSString*)text links:(NSSet*)links;

+ (CGFloat)textViewHeightForAttributedText:(NSAttributedString*)attributedText;

- (void)ajustMediaImageViewConstraintsWithTweet:(MITweet*)tweet;

@end
