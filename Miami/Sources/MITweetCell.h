//
//  MITweetCell.h
//  Miami
//
//  Created by Igor Bogatchuk on 3/2/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MITweetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView* profileImageView;
@property (weak, nonatomic) IBOutlet UITextView* textView;
@property (weak, nonatomic) IBOutlet UIImageView *mediaImageView;

+ (CGFloat)cellHeightForCellWithText:(NSString *)text;

@end
