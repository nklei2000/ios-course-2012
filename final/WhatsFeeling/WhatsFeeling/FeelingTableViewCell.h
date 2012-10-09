//
//  FeelingTableViewCell.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/9/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Feeling;

@interface FeelingTableViewCell : UITableViewCell
{
    UIImageView *balloonView;
    UILabel *label;
    UILabel *dateLabel;
}

@property (nonatomic,strong) Feeling *feeling;

+ (CGFloat)heightForCellWithFeeling:(Feeling *)feeling;

@end
