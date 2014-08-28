//
//  AlternativeView.m
//  Amgine
//
//  Created by Amgine on 17/07/14.
//   
//

#import "AlternativeView.h"
#import "Constants.h"
#import "Hotel.h"
#import "Flight.h"
#import "HotelDetailView.h"
#import "FlightDetailView.h"
#import "ScreenInfo.h"
#import "FlightViewCell.h"
#import "HotelViewCell.h"
#import "LiveData.h"
#import "Data.h"

@implementation AlternativeView
{
    CGPoint startingPoint;
    CGPoint viewCenter;
    BOOL isAnimation;
    float distance;
    CGRect screenRect;
    BOOL isUserInteraction;
    UILabel *labelDisplay;
    UILabel *costLabel;
    UILabel *carrierLabel;
    UIButton *alternativeIcon;
    UIActivityIndicatorView *activity;
    
}

@synthesize view;
@synthesize delegate;
@synthesize rootViewCtrl;
@synthesize indexValue;
@synthesize rootCell;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:0.8]];
        viewCenter=CGPointMake(self.center.x, self.center.y);
        screenRect=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        isUserInteraction=YES;
        UITapGestureRecognizer *tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestures:)];
        tapGesture.numberOfTapsRequired=1;
        tapGesture.numberOfTouchesRequired=1;
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}
#pragma mark HandleGesture
- (void)handleTapGestures:(UITapGestureRecognizer *)sender
{
    if(!isUserInteraction)
    {
        return;
    }
    isUserInteraction=NO;
    [self showDetailView:view];
}
-(void)touchOnAlternativeItem:(UITapGestureRecognizer *)sender
{
   
    NSLog(@"Touch on alternative Item");
    alternativeIcon.userInteractionEnabled=NO;
    [self showActivityIndicator];
    if ([view isKindOfClass:[Flight class]])
    {
        Flight *flight=(Flight *)view;
        NSString *solutionId=[LiveData getInstance].solution_ID;
        NSDictionary *dictionary=@{@"solutionid":solutionId,
                                   @"alternativeid":flight.guid
                                   };
        [self sendResponseToServer:dictionary];
        NSLog(@"vlue of Count:%lu",(unsigned long)[[LiveData getInstance]flightArray].count);
    }
    
    else if([view isKindOfClass:[Hotel class]])
    {
        Hotel *hotel=(Hotel *)view;
        NSString *solutionId=[LiveData getInstance].solution_ID;
        NSDictionary *dictionary=@{@"solutionid":solutionId,
                                   @"alternativeid":hotel.guid
                                   };
        [self sendResponseToServer:dictionary];
        NSLog(@"vlue of Count:%lu",(unsigned long)[[LiveData getInstance]flightArray].count);
    }
    
}
-(void)showActivityIndicator
{
    if(!activity)
    {
        NSLog(@"POINT:%f:%f",self.center.x,self.center.y);
        activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.center=CGPointMake(self.center.x, 20);
        [self addSubview:activity];
    }
    [activity startAnimating];
}

-(void)removeActivityIndicator
{
      [activity stopAnimating];
     [activity removeFromSuperview];
     activity=nil;
}
-(void)sendResponseToServer:(NSDictionary *)dictionary
{
     UrlConnection *urlConnection=[[UrlConnection alloc]init];
     urlConnection.delegate=self;
    [urlConnection postData:dictionary searchType:@"Change"];
}

#pragma mark urlConnectionDelegate
-(void)connectionDidFinishLoadingData:(NSData *)data withService:(UrlConnection *)connection
{
    
    NSDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"Success:dictionary:%@",dictionary);
    alternativeIcon.userInteractionEnabled=YES;
    if ([view isKindOfClass:[Flight class]])
    {
        [self updateFlightCell];
    }
    else if([view isKindOfClass:[Hotel class]])
    {
        [self updateHotelCell];
    }
    [self  removeActivityIndicator];
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
      NSLog(@"Error:");
     [self  removeActivityIndicator];
     alternativeIcon.userInteractionEnabled=YES;
     [self addAlertView:errorMessage];
}


-(void)addAlertView:(NSString *)message
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error!" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)updateFlightCell
{
    FlightViewCell *flightCell=(FlightViewCell*)rootCell;
    [self updateAlternativeFlightView:flightCell.flights];
    Flight *flight=(Flight *)view;
    NSLog(@"value of flight=%@",flight.carrier);
    [[LiveData getInstance]updateFlightArray:flight updateValue:@"0"];
    [[LiveData getInstance]updateFlightArray:flightCell.flights updateValue:@"1"];
     view=(UIView *)flightCell.flights;
    [flightCell updateView:flight animationNeed:NO];
    //view=(UIView *)flightCell.flights;
}
-(void)updateHotelCell
{
    HotelViewCell *hotelCell=(HotelViewCell*)rootCell;
    [self updateAlternativeHotelView:hotelCell.hotels];
     Hotel *hotel=(Hotel *)view;
    [[LiveData getInstance]updateHotelArray:hotel updateValue:@"0"];
    [[LiveData getInstance]updateHotelArray:hotelCell.hotels updateValue:@"1"];
    [hotelCell updateView:hotel animationNeed:NO];
}

#pragma mark Detail view Specific Function
-(void)showDetailView:(UIView *)cell
{
    UIView *viewtoAnimate=nil;
   
    if([cell isKindOfClass:[Hotel class]])
    {
        Hotel *hotel=(Hotel *)cell;
        HotelDetailView *hotelDetailView=[[HotelDetailView alloc]initWithFrame:CGRectMake(0,0,320,[ScreenInfo getScreenHeight]) withHotelView:hotel];
        hotelDetailView.delegate=self;
        
        [hotelDetailView setBackgroundColor:[UIColor whiteColor]];
        hotelDetailView.center=CGPointMake([ScreenInfo getScreenWidth]/2, 3*[ScreenInfo getScreenHeight]/2);
        hotelDetailView.rootViewController=(IteratorViewController *)rootViewCtrl;
        [rootViewCtrl.view addSubview:hotelDetailView];
        viewtoAnimate=hotelDetailView;
        
    }
    else if([cell isKindOfClass:[Flight class]])
    {
        Flight *flight=(Flight *)cell;
        FlightDetailView *flightDetailView=[[FlightDetailView alloc]initWithFrame:CGRectMake(0,0,320,[ScreenInfo getScreenHeight]) WithFlightView:flight];
        [flightDetailView drawUI:flight];
        flightDetailView.delegate=self;
        [flightDetailView setBackgroundColor:[UIColor whiteColor]];
        flightDetailView.center=CGPointMake([ScreenInfo getScreenWidth]/2,3*[ScreenInfo getScreenHeight]/2);
        flightDetailView.rootViewController=(IteratorViewController *)rootViewCtrl;
        [rootViewCtrl.view addSubview:flightDetailView];
         viewtoAnimate=flightDetailView;
    }
    
    
    [UIView animateWithDuration:0.5 animations:^{
        viewtoAnimate.center=CGPointMake([ScreenInfo getScreenWidth]/2,[ScreenInfo getScreenHeight]/2);
    } completion:^(BOOL finished)
     {
       
         if([viewtoAnimate isKindOfClass:[HotelDetailView class]])
         {
             [(HotelDetailView *)viewtoAnimate downLoadImage];
         }
          isUserInteraction=YES;
    }];
}

#pragma mark Drawing Functions
-(void)labelDisplay:(NSString *)displayString
{
  if([view isKindOfClass:[Flight class]])
  {
      Flight *flights=(Flight *)view;
      labelDisplay=[[UILabel alloc]initWithFrame:CGRectMake(6,2,120,20)];
      labelDisplay.textColor=[UIColor blackColor];
      labelDisplay.font=[UIFont fontWithName:AmgineFont size:14.0];
      labelDisplay.text=displayString;
      [self addSubview:labelDisplay];
      
      
      carrierLabel=[[UILabel alloc]initWithFrame:CGRectZero];
      carrierLabel.text=[NSString stringWithFormat:@"%@ %@",flights.carrier,flights.flightnumber];
      carrierLabel.textColor=[UIColor blackColor];
      carrierLabel.font=[UIFont fontWithName:AmgineFont size:12.0];
      [carrierLabel setBackgroundColor:[UIColor clearColor]];
      CGSize size = [carrierLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:12.0f]}];
      carrierLabel.frame=CGRectMake(6,24, size.width, size.height);
      [self addSubview:carrierLabel];

  }
  else if ([view isKindOfClass:[Hotel class]])
  {
      Hotel *hotel=(Hotel *)view;
      labelDisplay=[[UILabel alloc]initWithFrame:CGRectMake(6,2, 120,20)];
      labelDisplay.text=hotel.hotelname;//@"Yogesh Gupta From Palwal Faridabad palwal palwal palwal palwal palwal";//
      labelDisplay.textColor=[UIColor blackColor];
      labelDisplay.font=[UIFont fontWithName:AmgineFont size:14.0];
      labelDisplay.adjustsFontSizeToFitWidth=NO;
      labelDisplay.lineBreakMode=NSLineBreakByWordWrapping;
      labelDisplay.numberOfLines=0;
      [labelDisplay setBackgroundColor:[UIColor clearColor]];
      [labelDisplay sizeToFit];
      CGSize  textSize = {120, 10000.0};
      CGRect frame = [labelDisplay.text boundingRectWithSize:textSize options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                attributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:14.0f]}
                                      context:nil];
      
      if(frame.size.height>20)
      {
           self.frame=CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,frame.size.height+10);
      }
      else
      {
          
      }
     
      [self addSubview:labelDisplay];

  }
}


-(void)costDisplay:(NSString *)displayString
{
    displayString=[NSString stringWithFormat:@"$%.02f",displayString.floatValue];
    costLabel=[[UILabel alloc]init];
    costLabel.text=displayString;
    costLabel.textColor=[UIColor blackColor];
    costLabel.font=[UIFont fontWithName:AmgineFont size:14.0];
    CGSize labelValueSize = [displayString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:14.0]}];
    costLabel.frame=CGRectMake(255,8,labelValueSize.width,labelValueSize.height);
    [costLabel sizeToFit];
    [self addSubview:costLabel];
}

-(void)drawIcon
{
      NSString *buttonTitle=@"Select";
      alternativeIcon=[UIButton buttonWithType:UIButtonTypeCustom];
     [alternativeIcon setFrame:CGRectMake(0, 0,60,30)];
     [alternativeIcon setTitle:buttonTitle forState:UIControlStateNormal];
     [alternativeIcon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if([view isKindOfClass:[Hotel class]])
    {
        alternativeIcon.center=CGPointMake(self.center.x,20);
    }
    else if([view isKindOfClass:[Flight class]])
    {
        alternativeIcon.center=CGPointMake(self.center.x,20);
    }
    alternativeIcon.userInteractionEnabled=YES;
    [self addSubview:alternativeIcon];
    
    UITapGestureRecognizer *tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOnAlternativeItem:)];
    tapGesture.numberOfTapsRequired=1;
    tapGesture.numberOfTouchesRequired=1;
    [alternativeIcon addGestureRecognizer:tapGesture];
}


-(void)resetCenter
{
    float offset=10;
    isAnimation=NO;
    [UIView animateWithDuration:0.25 animations:
     ^{
         self.center=CGPointMake(viewCenter.x+offset, viewCenter.y);
      }
      completion:^(BOOL finished)
      {
        [UIView animateWithDuration:0.15 animations:
         ^{
              CGPoint point;
              point=self.center;
              self.center=CGPointMake(point.x-offset, viewCenter.y);
          }
           completion:^(BOOL finished)
          {
              isAnimation=YES;
          }
        ];
     }
    ];
    
}

-(void)updateAlternativeFlightView:(Flight *)flight
{
    NSLog(@"value of Flight (cost:%@ carrier:%@ name:%@",flight.cost,flight.carrier,flight.destination);
    labelDisplay.text=[NSString stringWithFormat:@"%@-%@",flight.origin,flight.destination];
    costLabel.text=[NSString stringWithFormat:@"$%@",flight.cost];
    
    carrierLabel.text=[NSString stringWithFormat:@"%@ %@",flight.carrier,flight.flightnumber];
    carrierLabel.textColor=[UIColor blackColor];
    carrierLabel.font=[UIFont fontWithName:AmgineFont size:12.0];
    [carrierLabel setBackgroundColor:[UIColor clearColor]];
    CGSize size = [carrierLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:12.0f]}];
    carrierLabel.frame=CGRectMake(6,22, size.width, size.height);
}

-(void)updateAlternativeHotelView:(Hotel *)hotel
{
     labelDisplay.text=[NSString stringWithFormat:@"%@",hotel.hotelname];
     costLabel.text=[NSString stringWithFormat:@"$%@",hotel.cost];
}

#pragma mark touches Specific Function
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   // startingPoint=[[touches anyObject]locationInView:self];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    CGPoint movingPoint=[[touches anyObject]locationInView:self];
//    float xx=startingPoint.x-movingPoint.x;
//    CGRect frame=self.frame;
//    self.frame=CGRectMake(frame.origin.x-xx, frame.origin.y,frame.size.width, frame.size.height);
//     distance=screenRect.origin.x-self.frame.origin.x;
//    NSLog(@"distance************=%f",distance);
//    if([view isKindOfClass:])
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//     CGPoint endPoint=[[touches anyObject]locationInView:self];
//     distance=screenRect.origin.x-self.frame.origin.x;
//     NSLog(@"distance************=%f",distance);
//    if(distance)
//    {
//       // if()
//    }
}



#pragma mark detail View Disappear
-(void)flightDetailViewDisappear
{
    
}
-(void)hotelDetailViewDisappear
{
    
}
@end
