//
//  SwipeView.m
//  Amgine
//
//  Created by Amgine on 11/07/14.
//   
//

#import "SwipeView.h"
#import "Constants.h"

@implementation SwipeView
{
    CGRect screenRect;
    UILabel *label;
    
    //**********************************for Flights****************************//
    UILabel *flightOrigin_destinationLabel;
    UILabel *flightNumberLabel;
    UILabel *flightCostLabel;
    //**********************************for Hotels****************************//
    UILabel *hotelName;
    UILabel *hotelCost;
}
@synthesize imageView;
@synthesize labelTextstr;
@synthesize swipePoint;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
       // [self setBackgroundColor:[UIColor redColor]];
         NSLog(@"***************value of center=%f,%f***************",self.center.x,self.center.y);
    }
    return self;
}

-(void)labelText:(NSString *)text
{
     label=[[UILabel alloc]init];
     label.font=[UIFont fontWithName:AmgineFont size:8.0];
     CGSize labelValueSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:8.0]}];
     label.frame=CGRectMake(0,0, labelValueSize.width, labelValueSize.height);
    label.text=text;
    labelTextstr=text;
    imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"next1.png"]];
    
    imageView.frame=CGRectMake(0,0,20,20);
     NSLog(@"***************value of center=%f,%f***************",swipePoint.x,swipePoint.y);
      imageView.center=CGPointMake(30, self.center.y-4);
    label.center=CGPointMake(28, self.center.y+10);
     [self addSubview:imageView];
    [self addSubview:label];
  
    
}
-(void)updateLabelText:(NSString *)text
{
    UIImage *image=nil;
    CGSize labelValueSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:8.0]}];
    label.frame=CGRectMake(0, 0, labelValueSize.width, labelValueSize.height);
    label.text=text;
    labelTextstr=text;
    
    if([text isEqualToString:@"DELETE"])
    {
         NSLog(@"DELETE Swipe");
         image=[UIImage imageNamed:@"delete.png"];
         imageView.center=CGPointMake(243, self.center.y-4);
         label.center=CGPointMake(245, self.center.y+10);
    }
    else
    {
         NSLog(@"next Swipe");
         image=[UIImage imageNamed:@"next1.png"];
         imageView.center=CGPointMake(30, self.center.y-4);
         label.center=CGPointMake(28, self.center.y+10);
        
    }
    [imageView setImage:image];
}

-(void)displayFlightData:(NSDictionary *)dictionary
{
   if(!flightOrigin_destinationLabel)
   {
       flightOrigin_destinationLabel=[[UILabel alloc]initWithFrame:CGRectMake(45,6, 120, 16)];
       flightOrigin_destinationLabel.textColor=[UIColor whiteColor];
       flightOrigin_destinationLabel.font=[UIFont fontWithName:AmgineFont size:12.0];
       [self addSubview:flightOrigin_destinationLabel];
   }
   if(flightNumberLabel==nil)
   {
       flightNumberLabel=[[UILabel alloc]initWithFrame:CGRectZero];
       flightNumberLabel.textColor=[UIColor whiteColor];
       flightNumberLabel.font=[UIFont fontWithName:AmgineFont size:10.0];
      [self addSubview:flightNumberLabel];
   }
   if(flightCostLabel==nil)
   {
       flightCostLabel=[[UILabel alloc]initWithFrame:CGRectMake(185,4, 50, 20)];
       flightCostLabel.textColor=[UIColor whiteColor];
       flightCostLabel.font=[UIFont fontWithName:AmgineFont size:12.0];

       [self addSubview:flightCostLabel];
   }
   
   
    flightOrigin_destinationLabel.text=[dictionary valueForKey:@"FlightPlace"];
    flightNumberLabel.text=[dictionary valueForKey:@"FlightNumber"];
    CGSize size = [flightNumberLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:10.0f]}];
    flightNumberLabel.frame=CGRectMake(48,22, size.width, size.height);
    flightCostLabel.text=[dictionary valueForKey:@"FlightCost"];
}
-(void)resetFlightData
{
    flightOrigin_destinationLabel.text=nil;
    flightNumberLabel.text=nil;
    flightCostLabel.text=nil;
}
 /***********************************HotelData*****************************/
-(void)displayHotelData:(NSDictionary *)hotelData
{
    if(!hotelName)
    {
        hotelName=[[UILabel alloc]initWithFrame:CGRectMake(45,12, 120, 20)];
        hotelName.textColor=[UIColor whiteColor];
        hotelName.font=[UIFont fontWithName:AmgineFont size:10.0];
        hotelName.adjustsFontSizeToFitWidth=NO;
        hotelName.lineBreakMode=NSLineBreakByWordWrapping;
        hotelName.numberOfLines=0;
        [hotelName setBackgroundColor:[UIColor clearColor]];
        [self addSubview:hotelName];
    }
    if(hotelCost==nil)
    {
        hotelCost=[[UILabel alloc]initWithFrame:CGRectMake(185,10, 50, 20)];
        hotelCost.textColor=[UIColor whiteColor];
        hotelCost.font=[UIFont fontWithName:AmgineFont size:10.0];
        [self addSubview:hotelCost];
    }

    hotelName.text=[hotelData valueForKey:@"HotelName"];
    hotelCost.text=[hotelData valueForKey:@"HotelCost"];
}
-(void)resetHotelData
{
    hotelName.text=nil;
    hotelCost.text=nil;
}
-(void)detectTouches:(CGPoint)point
{
    
    
}

@end
