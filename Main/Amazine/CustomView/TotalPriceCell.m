//
//  TotalPrice.m
//  Amgine
//
//  Created by Amgine on 20/06/14.
//   
//

#import "TotalPriceCell.h"
#import "Constants.h"
@implementation TotalPriceCell
{
    UILabel *costLabel;
}
@synthesize rectangleRect;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
      [self setFrame:frame];
    }
    return self;
}
-(void)drawDate:(NSString *)date is_Single:(BOOL)is_Single
{
    UILabel *label=nil;
    if(is_Single)
    {
      label =[[UILabel alloc]initWithFrame:CGRectMake(10,self.center.y-20, 60, 40)];
    }
    else
    {
       label =[[UILabel alloc]initWithFrame:CGRectMake(5,self.center.y-20, 60, 40)];
    }
   
    label.text=date;
    label.textColor=[UIColor blackColor];
    label.font=[UIFont fontWithName:AmgineFont size:12.0];
    label.adjustsFontSizeToFitWidth=NO;
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=0;
   [label setBackgroundColor:[UIColor clearColor]];
    [self addSubview:label];
}
-(void)drawRectangle:(CGRect)rectanglRect Color:(UIColor *)color
{
    CAShapeLayer *rectangle = [CAShapeLayer layer];
    rectanglRect.origin.y=0;
    rectangleRect.origin.y=0;
    NSLog(@"Rectangle Rect---->[%f,%f,%f,%f]",rectanglRect.origin.x,rectanglRect.origin.y,rectanglRect.size.width,rectanglRect.size.height);
    rectangle.path = [UIBezierPath bezierPathWithRoundedRect:rectanglRect cornerRadius:0].CGPath;
    rectangle.position  = CGPointMake(0,0);
    rectangle.fillColor=color.CGColor;//[UIColor colorWithRed:102.0f/255.0f green:178.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
    rectangle.strokeColor = color.CGColor;//[UIColor colorWithRed:102.0f/255.0f green:178.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor;
    [self.layer addSublayer:rectangle];
    
}
-(void)drawImage
{
    UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Total.png"]];
    image.frame=CGRectMake(0, 0, 16, 16);
    image.center=CGPointMake(rectangleRect.origin.x-2,self.center.y-4);
    [self addSubview:image];
}


-(void)drawTotalPrice:(NSString *)price
{
    costLabel =[[UILabel alloc]init];
    costLabel.text=price;
    costLabel.textColor=[UIColor whiteColor];
    costLabel.font=[UIFont fontWithName:AmgineFont size:12.0];
    [costLabel setBackgroundColor:[UIColor clearColor]];
     CGSize labelValueSize = [price sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:12.0]}];
      costLabel.frame=CGRectMake(rectangleRect.size.width+rectangleRect.origin.x-labelValueSize.width-5,self.frame.origin.y+5,labelValueSize.width,labelValueSize.height);

    [costLabel sizeToFit];
    [self addSubview:costLabel];
}
-(void)drawPlaceName:(NSString *)value
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(rectangleRect.origin.x+20,self.frame.origin.y+2, 120,20)];
    label.text=value;
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont fontWithName:AmgineFont size:12.0];
    [label setBackgroundColor:[UIColor clearColor]];
    [self addSubview:label];
}

-(void)updateTotalCost:(NSString *)cost
{
    costLabel.text=cost;
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
