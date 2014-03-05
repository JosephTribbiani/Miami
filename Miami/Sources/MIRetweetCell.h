//
//  MIRetweetCell.h
//  Miami
//
//  Created by Igor Bogatchuk on 3/2/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIRetweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *retweetTitleLabel;

- (void)setUpWithUserName:(NSString*)userName
        retweetedUserName:(NSString*)retweetedUserName
  retweetedUserScreenName:(NSString*)retweetedUserScreenName
                     date:(NSDate*)date
                     text:(NSString*)text
                 photoURL:(NSString*)url;
@end
