//
//  TipView.m
//  Amgine
//
//  Created by Amgine on 04/07/14.
//   
//

#import "TipView.h"
#import "Constants.h"
#import "Data.h"

@implementation TipView
@synthesize tipText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [[Data sharedData]addBorderToUiView:self];
    }
    return self;
}

-(void)addtips:(NSString *)string
{
    tipText=string;
    UILabel *label=[[UILabel alloc]init];
    [label setBackgroundColor:[UIColor clearColor]];
    label.text=string;
    label.font=[UIFont fontWithName:AmgineFont size:14.0];
   // CGSize labelValueSize = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:18.0]}];
    label.frame=CGRectMake(4, 4,self.frame.size.width-8,self.frame.size.height-8);
    label.adjustsFontSizeToFitWidth=NO;
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=0;
    [label setBackgroundColor:[UIColor clearColor]];
    [label sizeToFit];
    [self addSubview:label];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
