//
//  FeelingTableViewCell.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/9/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "FeelingTableViewCell.h"
#import "Feeling.h"

@implementation FeelingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        // Initialization code
        return nil;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    // Create ballon view
    balloonView = [[UIImageView alloc] initWithFrame:CGRectZero];
    balloonView.tag = 1002;
    
    // Create label
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.tag = 1001;
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.font = [UIFont systemFontOfSize:13.0];

    // Create date label
    dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.tag = 1003;
    dateLabel.opaque = YES;
    dateLabel.clearsContextBeforeDrawing = NO;
    dateLabel.contentMode = UIViewContentModeRedraw;
    dateLabel.autoresizingMask = 0;
    dateLabel.font = [UIFont systemFontOfSize:11];
    dateLabel.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0];
    
    UIView *feeling = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
    
    feeling.tag = 1000;

    [feeling addSubview:balloonView];
    [feeling addSubview:label];
    [feeling addSubview:dateLabel];
    
    [self.contentView addSubview:feeling];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setFeeling:(Feeling *)feeling
{
	CGSize size = [feeling.text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:UILineBreakModeWordWrap];
	
	UIImage *balloon;
	
    feeling.balloonSize = size;
    
    NSLog(@"size width: %.2f", size.width);
	if(feeling.isSentByUser)
	{                
		balloonView.frame = CGRectMake(320.0f - (size.width + 28.0f), 2.0f, size.width + 28.0f, size.height + 15.0f);
		balloon = [[UIImage imageNamed:@"green.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
		label.frame = CGRectMake(307.0f - (size.width + 5.0f), 8.0f, size.width + 5.0f, size.height);
        
        dateLabel.textAlignment = UITextAlignmentRight;
	}
	else
	{        
		balloonView.frame = CGRectMake(0.0, 2.0, size.width + 28, size.height + 15);
		balloon = [[UIImage imageNamed:@"grey.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
		label.frame = CGRectMake(16, 8, size.width + 5, size.height);
        
        dateLabel.textAlignment = UITextAlignmentLeft;
	}
	
	balloonView.image = balloon;
	label.text = feeling.text;
    
	// Format the message date
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	[formatter setDoesRelativeDateFormatting:YES];
    //	NSString* dateString = [formatter stringFromDate:feeling.date];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    
	// Set the sender's name and date on the label
	dateLabel.text = [NSString stringWithFormat:@"%@", dateString];
	[dateLabel sizeToFit];
	dateLabel.frame = CGRectMake(8, size.height + 12.0f, self.contentView.bounds.size.width - 16, 16);

}

+ (CGFloat)heightForCellWithFeeling:(Feeling *)feeling
{
	CGSize size = [feeling.text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0, 480.0) lineBreakMode:UILineBreakModeWordWrap];
    
	return size.height + 15 + 18;
}

@end
