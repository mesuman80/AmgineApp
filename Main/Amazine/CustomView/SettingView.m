//
//  SettingView.m
//  Amgine
//
//  Created by Amgine on 18/07/14.
//   
//

#import "SettingView.h"
#import "Constants.h"

@implementation SettingView
{
    UILabel *labelDisplay;
   // UIImageView *imageView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        labelDisplay=[[UILabel alloc]init];
        labelDisplay.font=[UIFont fontWithName:AmgineFont size:14.0];
        labelDisplay.frame=CGRectMake(14,10,320,30);
        [self.contentView addSubview:labelDisplay];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

-(void)configureCell:(NSString *)labelValue
{
    [self addLabel:labelValue];
}

-(void)addLabel:(NSString *)displayValue
{
    labelDisplay.text=displayValue;
}



@end
