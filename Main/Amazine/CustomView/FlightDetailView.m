//
//  FlightDetailView.m
//  Amgine
//
//  Created by Amgine on 23/06/14.
//   
//

#import "FlightDetailView.h"
#import "Flight.h"
#import "ScreenInfo.h"
#import "Constants.h"

@implementation FlightDetailView
{
    Flight *flight;
    NSMutableArray *labelDisplayArray;
    
    float screenHeight;
    float screenWidth;
}

//@synthesize rootViewController;
@synthesize delegate;

-(id)initWithFrame:(CGRect)frame WithFlightView:(Flight *)flightView
{
    self = [super initWithFrame:frame];
    if (self)
    {
         screenHeight=[ScreenInfo getScreenHeight];
         screenWidth=[ScreenInfo getScreenWidth];
         flight=(Flight *)flightView;
        UISwipeGestureRecognizer *oneFingerSwipeLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(oneFingerSwipeLeft:)];
        [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:oneFingerSwipeLeft];
    }
    return self;
}

- (void)oneFingerSwipeLeft:(UITapGestureRecognizer *)recognizer
{
     [self.rootViewController.parentView setAlpha:1.0f];
    [UIView animateWithDuration:AmgineCellSwipeAnimationTime animations:^{
        self.center=CGPointMake(-screenWidth/2, self.center.y);
        self.rootViewController.parentView .center=CGPointMake(screenWidth/2,self.rootViewController.parentView.center.y);
    } completion:^(BOOL finished) {
        [self viewDisappear];
        [self removeFromSuperview];
    }];
}


-(void)drawUI:(Flight *)flightView
{
    
    labelDisplayArray=[[NSMutableArray alloc]init];
    
    NSString *destinationStr=[NSString stringWithFormat:@"%@-%@",flightView.origin,flightView.destination];
    NSString *costString=[NSString stringWithFormat:@"$ %0.02f",[[flightView cost]floatValue]];
    
    NSMutableDictionary *flightCost=[[NSMutableDictionary alloc]init];
    [flightCost setObject:destinationStr forKey:@"labelDisplay"];
    [flightCost setObject:costString forKey:@"labelValue"];
    [labelDisplayArray addObject:flightCost];
    
     NSMutableDictionary *flightCarrier=[[NSMutableDictionary alloc]init];
    [flightCarrier setObject:@"Carrier" forKey:@"labelDisplay"];
    [flightCarrier setObject:flightView.carrier forKey:@"labelValue"];
    [labelDisplayArray addObject:flightCarrier];

    
    NSMutableDictionary *flightNumber=[[NSMutableDictionary alloc]init];
    [flightNumber setObject:@"FlightNumber" forKey:@"labelDisplay"];
    [flightNumber setObject:flightView.flightnumber forKey:@"labelValue"];
    [labelDisplayArray addObject:flightNumber];
    
    NSLog(@"flight time=%@",flightView.flighttime);
    NSMutableDictionary *flightTime=[[NSMutableDictionary alloc]init];
    [flightTime setObject:@"FlightTime" forKey:@"labelDisplay"];
    [flightTime setObject:flightView.flighttime forKey:@"labelValue"];
    [labelDisplayArray addObject:flightTime];
    
    
    
    NSMutableDictionary *departure=[[NSMutableDictionary alloc]init];
    [departure setObject:@"Departure" forKey:@"labelDisplay"];
    [departure setObject:flightView.departure forKey:@"labelValue"];
    [labelDisplayArray addObject:departure];
    
    NSMutableDictionary *arrival=[[NSMutableDictionary alloc]init];
    [arrival setObject:@"Arrival" forKey:@"labelDisplay"];
    [arrival setObject:flightView.arrival forKey:@"labelValue"];
    [labelDisplayArray addObject:arrival];
    
    NSMutableDictionary *origin=[[NSMutableDictionary alloc]init];
    [origin setObject:@"Origin" forKey:@"labelDisplay"];
    [origin setObject:flightView.origin forKey:@"labelValue"];
    [labelDisplayArray addObject:origin];
    
    NSMutableDictionary *destination=[[NSMutableDictionary alloc]init];
    [destination setObject:@"Destination" forKey:@"labelDisplay"];
    [destination setObject:flightView.destination forKey:@"labelValue"];
    [labelDisplayArray addObject:destination];
     [self drawFlightDetail:labelDisplayArray];
}

-(void)drawFlightData
{
//    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10,factor*48,215,30)];
//    NSString *destination=[NSString stringWithFormat:@"%@-%@",flight.origin,flight.destination];
//    [label setText:destination];
//     label.font=[UIFont fontWithName:AmgineFont size:14.0*factor];
//    [self addSubview:label];
//    
//    UILabel *costLabel=[[UILabel alloc]init];
//    NSString *costString=[NSString stringWithFormat:@"$ %@",flight.cost];
//    costLabel.font=[UIFont fontWithName:AmgineFont size:14.0*factor];
//    CGSize labelValueSize = [costString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:14.0*factor]}];
//    costLabel.frame=CGRectMake(320-labelValueSize.width-10,factor*48, labelValueSize.width, 30);
//    costLabel.text=costString;
//    [self addSubview:costLabel];
}
#pragma mark DrawMethods
-(void)drawFlightDetail:(NSMutableArray*)flightData
{
    float yy=94.0f*factor;
    
    for(NSDictionary * dictionary in flightData)
    {
        UILabel *labelName=[[UILabel alloc]init];
        NSString *labelText=[dictionary objectForKey:@"labelDisplay"];
        labelName.text=labelText;
        labelName.font=[UIFont fontWithName:AmgineFont size:16.0*factor];
        [labelName setBackgroundColor:[UIColor clearColor]];
        CGSize labelValueSize = [labelText sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:16.0*factor]}];
        labelName.frame=CGRectMake(10,yy,labelValueSize.width,labelValueSize.height);
        [self addSubview:labelName];
        
        UILabel *label=[[UILabel alloc]init];
        label.font=[UIFont fontWithName:AmgineFont size:14.0*factor];
        [label setBackgroundColor:[UIColor clearColor]];
        NSString *flightNumber=[dictionary objectForKey:@"labelValue"];
        CGSize labelValueSize1 = [flightNumber sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:14.0*factor]}];
        label.text=flightNumber;
        label.frame=CGRectMake(125, yy, labelValueSize1.width, labelValueSize1.height);
        [self addSubview:label];
        yy+=37.0f*factor;
        
    }
}

-(void)viewDisappear
{
    [self.delegate flightDetailViewDisappear];
}
@end
