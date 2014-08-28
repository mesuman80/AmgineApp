    //
//  FlightViewCell.m
//  Amazine
//
//  Created by Amgine on 14/06/14.
//  Copyright (c) 2014 Amgine. All rights reserved.
//

#import "FlightViewCell.h"
#import "Constants.h"
#import "Data.h"
#import "SwipeView.h"
#import "ScreenInfo.h"
#import "AlterNativeFlightScrollClass.h"
#import "LiveData.h"


@implementation FlightViewCell
{
    CGPoint startingPoint;
    CGRect rect;
    UIView *parentView;
    CGPoint viewCenter;
    BOOL userInteractionEnable;
    int flightIndex;
    
    UILabel *origin_Destination_Name_Label;
    UILabel *costLabel;
    UILabel *dateLabel;
    UILabel *flightNumberLabel;
    
    SwipeView *swipeView;
    NSString *IsAnimation;
   
    CGRect screenRect;
    
    float screenWidth;
    float screenHeight;
    float factor;
    FlightDetailView *flightDetailView;
    
    BOOL leftSwipe;
    BOOL rightSwipe;
    
    BOOL IsEnterOnDetailViewController;
    BOOL isOutSideCell;
    
    int arrayIndex;
     NSMutableArray *alternativeFlight;
    int reviewCellIndex;
    
    UIColor *rectangleStrokeColor;
    CAShapeLayer *rectangle;
    
    int nextFlightIndex;
    int previousFlightIndex;
    Flight *nextFlight;
    BOOL isInLoop;
    
    
    BOOL isTouchDown;
    BOOL isServerRequest;
    UIActivityIndicatorView *activity;
    
    BOOL isFailure;
    
    BOOL isDisplayData;
    
  
}
@synthesize objectId,rectangleRect,flights;
@synthesize flightArray;
@synthesize delegate;
@synthesize rootViewController;
@synthesize passengerId;
@synthesize colorPelette;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        screenRect=frame;
        screenWidth=[ScreenInfo getScreenWidth];
        screenHeight=[ScreenInfo getScreenHeight];
        factor=screenHeight/568;
        
        parentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        rect=CGRectMake(parentView.frame.origin.x, parentView.frame.origin.y, parentView.frame.size.width, parentView.frame.size.height);
        viewCenter=parentView.center;
        userInteractionEnable=YES;
        flightIndex=arrayIndex=nextFlightIndex=1;
        IsAnimation=@"";
        [self addSubview:parentView];
         UITapGestureRecognizer *tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestures:)];
               tapGesture.numberOfTapsRequired=1;
            tapGesture.numberOfTouchesRequired=1;
               [self addGestureRecognizer:tapGesture];
       
      
    }
    return self;
}
- (void)handleTapGestures:(UITapGestureRecognizer *)sender
{
  if(isServerRequest)
  {
      return;
  }
    NSLog(@"value of X1  : %f",parentView.frame.origin.x);
   if(parentView.frame.origin.x!=0)
   {
       
       if(leftSwipe)
       {
           leftSwipe=NO;
           rightSwipe=NO;
           [self animationStart:NO is_Update:NO];
       }
       else if(rightSwipe)
       {
           leftSwipe=NO;
           rightSwipe=NO;
           [self animationStart:YES is_Update:NO];
       }
        return;
 
   }
  NSLog(@"Tag Value=(%i,%li)",[Data sharedData].selectedCellIndex,(long)self.tag);
 if([Data sharedData].selectedCellIndex!=self.tag)
 {
    if([Data sharedData].borderViewArray.count>0)
    {
        NSLog(@"valueof rectangleStrokeColor=%@",rectangleStrokeColor);
        [[[[Data sharedData]borderViewArray]lastObject]setStrokeColor:[UIColor clearColor].CGColor];
        [[[Data sharedData]borderViewArray]removeAllObjects];
    }
    [Data sharedData].selectedCellIndex=self.tag;
    [self addBorder];
    [self drawalternativeDetail:NO];
 }
  else
  {
      
  }
}

-(void)drawalternativeDetail:(BOOL)isUpdate
{
    if(isUpdate)
    {
        NSString *date1=[flights.departure substringToIndex:10];
        flightArray=[[[LiveData getInstance]flightDictionary]objectForKey:date1];
        alternativeFlight=nil;
        
    }

    [rootViewController cleanArray];
    if(!alternativeFlight)
    {
        alternativeFlight=[[NSMutableArray alloc]init];
        NSString *origin_Destination=[NSString stringWithFormat:@"%@%@",flights.origin,flights.destination];
        for(Flight *flight in flightArray)
        {
            NSLog(@"PassengerId:%@ flightPaxGuid=%@ isAlternative=%@",passengerId,flight.paxguid,flight.isalternative);
            if([flight.isalternative isEqualToString:@"1"] && [flight.paxguid isEqualToString:passengerId])
            {
                
                if([origin_Destination isEqualToString:[NSString stringWithFormat:@"%@%@",flight.origin,flight.destination]])
                {
                    [alternativeFlight addObject:flight];
                }
                
            }
        }
    }
    if(alternativeFlight.count>0)
    {
        [self scrollDeatilView:alternativeFlight];
    }
    

}

-(void)drawImage
{
      UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Flight.png"]];
     image.frame=CGRectMake(rectangleRect.origin.x-13, rectangleRect.origin.y+10, 20, 20);
     [parentView addSubview:image];
}

-(void)drawRectangle:(CGRect)rectanglRect Color:(UIColor *)color
{
    rectangleStrokeColor=color;
    rectangle = [CAShapeLayer layer];
    rectanglRect.origin.y=0;
    rectangleRect.origin.y=0;
    
     swipeView =[[SwipeView alloc]initWithFrame:CGRectMake(rectanglRect.origin.x+rectanglRect.size.width,0,rectanglRect.size.width+60, rectanglRect.size.height)];
    [swipeView setBackgroundColor:[colorPelette objectAtIndex:0]];
    [swipeView labelText:@"NEXT"];
     NSLog(@"center y=%f",self.center.y);
    [swipeView setAlpha:0.0f];
    [parentView addSubview:swipeView];
    
    rectangle.path = [UIBezierPath bezierPathWithRoundedRect:rectanglRect cornerRadius:0].CGPath;
    rectangle.fillColor=color.CGColor;
   // rectangle.strokeColor = color.CGColor;
    [parentView.layer addSublayer:rectangle];
}
-(void)drawOrigin_DestinationPlace:(NSString *)value
{
    origin_Destination_Name_Label=[[UILabel alloc]initWithFrame:CGRectMake(rectangleRect.origin.x+20,3, 120,20)];
    origin_Destination_Name_Label.text=value;
    origin_Destination_Name_Label.textColor=[UIColor whiteColor];
    origin_Destination_Name_Label.font=[UIFont fontWithName:AmgineFont size:12.0];
    [origin_Destination_Name_Label setBackgroundColor:[UIColor clearColor]];
    [parentView addSubview:origin_Destination_Name_Label];
}

-(void)drawCost:(NSString *)cost
{
    costLabel=[[UILabel alloc]initWithFrame:CGRectMake(rectangleRect.size.width+rectangleRect.origin.x-52,4,50,20)];
    costLabel.text=cost;
    costLabel.textColor=[UIColor whiteColor];
    costLabel.font=[UIFont fontWithName:AmgineFont size:12.0];
    [costLabel setBackgroundColor:[UIColor clearColor]];
    [parentView addSubview:costLabel];
}
-(void)drawDate:(NSString *)date
{
    dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,-4, 40, 40)];
    dateLabel.text=date;
    dateLabel.textColor=[UIColor blackColor];
    dateLabel.font=[UIFont fontWithName:AmgineFont size:12.0];
    
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [parentView addSubview:dateLabel];
   
}
-(void)drawFlightNumber:(NSString *)flightNumber
{
    flightNumberLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    flightNumberLabel.text=[NSString stringWithFormat:@"%@ %@",flights.carrier,flightNumber];
    flightNumberLabel.textColor=[UIColor whiteColor];
    flightNumberLabel.font=[UIFont fontWithName:AmgineFont size:12.0];
    [flightNumberLabel setBackgroundColor:[UIColor clearColor]];
    [parentView addSubview:flightNumberLabel];
    CGSize size = [flightNumberLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:12.0f]}];
    flightNumberLabel.frame=CGRectMake(rectangleRect.origin.x+20,21, size.width, size.height);

    

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(isServerRequest)
    {
        return;
    }
    startingPoint=[[touches anyObject]locationInView:parentView];
    isOutSideCell=NO;
    isTouchDown=YES;
    if(delegate)
    {
        [delegate touchStart];
    }
    if(!isFailure)
    {
        nextFlight=nil;
    }
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // NSLog(@"IN FLIGHT");
    CGPoint point=[[touches anyObject]locationInView:parentView];
    if(!userInteractionEnable || isOutSideCell || IsEnterOnDetailViewController || !isTouchDown)
    {
        return;
    }
    
   // NSLog(@"TouchMove:");
   
    
    float distance=rect.origin.x-parentView.frame.origin.x;
    float xx=startingPoint.x-point.x;
    CGRect frame = parentView.frame;
    parentView.frame=CGRectMake(frame.origin.x-xx, frame.origin.y, frame.size.width, frame.size.height);
    // NSLog(@"distance ********* =%f",distance);
    /**********************RightSwipe****************************/
    if(startingPoint.x<point.x && !leftSwipe)
    {
        [self gotoNextScreen:point];
        leftSwipe=NO;
         rightSwipe=YES;
        return;
    }
    
    /******Right With Left*******/
    else if(startingPoint.x>point.x && rightSwipe)
    {
        [self gotoNextScreen:point];
        return;
    }
    
    else if(point.y>rect.origin.y+self.frame.size.height && rightSwipe)
    {
       
//      if(IsAnimation)
//      {
//          isOutSideCell=YES;
//          [self animationStart:YES];
//      }
      return;
    }

//********************************Left Swipe*************************/
    
  else if (startingPoint.x>point.x)
  {
      if(!nextFlight)
      {
           nextFlight=[self getNextFLight];
          
      }
      else if (!isDisplayData)
      {
          
          [self displayFlightData:nextFlight];
      }

       leftSwipe=YES;
       rightSwipe=NO;
       if(swipeView.alpha<1)
       {
          [swipeView setAlpha:1.0];
       }
      
      if(distance>240 && [swipeView.labelTextstr isEqualToString:@"NEXT"])
      {
           [swipeView resetFlightData];
          
           [self swipeViewDelete];
      }
      
      else if (distance>310)
      {
        isFailure=YES;
        if(IsAnimation)
        {
            isTouchDown=NO;
           [self animationStart:NO is_Update:NO];
        }
      }
   }
    //******************Left With Right******************//
  else if (startingPoint.x<point.x && leftSwipe)
  {
      if (distance<=240 && [swipeView.labelTextstr isEqualToString:@"DELETE"])
      {
          [self displayFlightData:nextFlight];
          [self swipeNext];
      }
      
  }

   else if(point.y>rect.origin.y+self.frame.size.height && leftSwipe)
   {
    
      
      if(IsAnimation)
      {
//          NSLog(@"**************** outSide Frame ****************");
//          isOutSideCell=YES;
//          [self animationStart:NO];
      }
      return;
   }

   
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    float distance=(rect.origin.x-parentView.frame.origin.x);
   // NSLog(@"touchesEnded:");
   // NSLog(@"value of Distance************=%f",distance);
    isTouchDown=NO;
     //*************************Right Swipe*****************//
    isDisplayData=NO;
     if(rightSwipe)
    {
        rightSwipe=NO;
        leftSwipe=NO;
        if(distance!=0 && !IsEnterOnDetailViewController)
        {
          [self animationStart:YES is_Update:NO];
        }
        else
        {
            [self performSelector:@selector(changeCenter) withObject:self afterDelay:AmgineCellSwipeAnimationTime];
        }
       
        return;
    }

    
    //*************************Left Swipe*****************//
    else if(leftSwipe)
    {
        rightSwipe=NO;
        leftSwipe=NO;
        /************NO ACTION********/
        if(distance<67 && distance>0)
        {
            isFailure=YES;
            if(distance!=0 && IsAnimation)
            {
                
                [self animationStart:NO is_Update:NO];
            }
        }
        else
        {
            if(userInteractionEnable && swipeView.alpha==1)
            {
                if(distance<239 && distance>67)
                {
                    [self animationStart:NO is_Update:YES];
                   
                }
                else if(distance>=241 && distance<310)
                {
                   
                    [self deleteCell];
                }
                else
                {
                    nextFlightIndex=previousFlightIndex;
                    isFailure=YES;
                    
                    if(distance!=0 && IsAnimation)
                    {
                        
                        [self animationStart:NO is_Update:NO];
                    }
                }
            }
            else
            {
                
            }
            
        }


    }
    
}

-(void)displayFlightData:(Flight *)flight
{
    isDisplayData=YES;
     NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:[NSString stringWithFormat:@"%@-%@",flight.origin,flight.destination] forKey:@"FlightPlace"];
    [dictionary setValue:[NSString stringWithFormat:@"%@ %@",flight.carrier,flight.flightnumber] forKey:@"FlightNumber"];
    [dictionary setValue:[NSString stringWithFormat:@"$%@",flight.cost] forKey:@"FlightCost"];
    [swipeView displayFlightData:dictionary];
}
-(void)changeCenter
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeCenter) object:self];
     parentView.center=viewCenter;
}
-(void)animationStart:(BOOL)isLeft is_Update:(BOOL)is_Update
{
    IsAnimation=nil;
    userInteractionEnable=NO;
    float offset=10;
    if(isLeft)
    {
        offset=-offset;
    }
    [UIView animateWithDuration:0.25 animations:
     ^{
         
         parentView.center=CGPointMake(viewCenter.x+offset, viewCenter.y);
           if(isLeft)
           {
               if(!IsEnterOnDetailViewController)
               {
                  flightDetailView.center=CGPointMake(-screenWidth/2, screenHeight/2); 
               }
               
           }
     }
      completion:^(BOOL finished)
     {
         if(swipeView.alpha==1.0 && !isLeft)
         {
             [self swipeNext];
             [swipeView setAlpha:0.0f];
         }
         
         [UIView animateWithDuration:0.15 animations:
          ^{
              CGPoint point;
              point=parentView.center;
              parentView.center=CGPointMake(point.x-offset, viewCenter.y);
          }
          completion:^(BOOL finished)
          {
             // isMoveable=NO;
              IsAnimation=@"";
            if(is_Update)
            {
                userInteractionEnable=NO;
               // Flight *flight=(Flight *)view;
                NSString *solutionId=[LiveData getInstance].solution_ID;
                NSDictionary *dictionary=@{@"solutionid":solutionId,
                                           @"alternativeid":nextFlight.guid
                                           };
                [self sendResponseToServer:dictionary];

            }
            else
            {
                userInteractionEnable=YES;
            }
              
          }
          ];
         
     }
     ];
    
}


-(void)animateText
{
    origin_Destination_Name_Label.alpha=0.0;
    costLabel.alpha=0.0;
    
    [UIView animateWithDuration:0.7 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        origin_Destination_Name_Label.alpha=1.0;
        costLabel.alpha=1.0;
        flightNumberLabel.alpha=1.0;
    } completion:^(BOOL finished) {
        
        
    }];

}
-(void)updateView:(Flight *)updateFlight animationNeed:(BOOL)isNeed
{
    if(!updateFlight)
    {
        updateFlight=[self getNextFLight];
    }
     NSLog(@"value of Flight (cost:%@ carrier:%@ name:%@",updateFlight.cost,updateFlight.carrier,updateFlight.destination);
        float cost=[[flights cost]floatValue];
        reviewCellIndex=[[Data sharedData]getIndexReviewArray:flights];
        [[[Data sharedData]reviewTipDisplayArray]removeObject:flights];
       [[[Data sharedData]reviewTipDisplayArray]insertObject:updateFlight atIndex:reviewCellIndex];
        flights=updateFlight;
         origin_Destination_Name_Label.text=[NSString stringWithFormat:@"%@ - %@",flights.origin,flights.destination];
        costLabel.text=[NSString stringWithFormat:@"$%@",flights.cost];
        flightNumberLabel.text=[NSString stringWithFormat:@"%@ %@",flights.carrier,flights.flightnumber];
    
        CGSize size = [flightNumberLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:12.0f]}];
       flightNumberLabel.frame=CGRectMake(rectangleRect.origin.x+20,21, size.width, size.height);

        NSString *date=[[Data sharedData]getDateFormat:AmgineDateFormat withDateString:flights.departure dateFormat:@"dd MMM"];
        dateLabel.text=date;
        if(IsAnimation && isNeed)
        {
            NSLog(@"Animation start:");
            [self animationStart:NO is_Update:NO];
        }

        if(delegate)
        {
            [delegate returnDelegate:[NSString stringWithFormat:@"%.02f",cost-[[flights cost]floatValue]]];
        }

    
    
}
-(Flight *)getNextFLight
{
    isInLoop=NO;
    if(flightArray.count>1)
    {
        previousFlightIndex=nextFlightIndex;
        Flight *flightCell=nil;
        for(int i=nextFlightIndex;i<flightArray.count;i++)
        {
            flightCell=[flightArray objectAtIndex:i];
            if([flightCell.isalternative isEqualToString:@"1"] && [passengerId isEqualToString:flightCell.paxguid])
            {
                 NSString *origin_destination_Name=[NSString stringWithFormat:@"%@%@",flights.origin,flights.destination];
                  NSString *origin_Destination=[NSString stringWithFormat:@"%@%@",flightCell.origin,flightCell.destination];
                 if([origin_destination_Name isEqualToString:origin_Destination])
                 {
                     isInLoop=YES;
                     arrayIndex++;
                     break;
                 }
                
            }
            arrayIndex++;
         }
         nextFlightIndex=arrayIndex;
         if(!isInLoop)
         {
              nextFlightIndex=arrayIndex=0;
             return [flightArray objectAtIndex:0];
          }
        else
        {
            isInLoop=NO;
            if(flightIndex>=flightArray.count)
            {
                
                flightIndex=arrayIndex=0;
               return [flightArray objectAtIndex:0];
                
            }

            return [flightArray objectAtIndex:arrayIndex-1];
        }
    }
    return nil;
}
-(void)deleteCell
{
     isFailure=YES;
     [Data sharedData].lastDeleteCell=self;
     parentView.center=viewCenter;
     self.center=viewCenter;
     swipeView.alpha=0.0f;
    [self swipeNext];
    [Data sharedData].lastDeleteCell.frame=screenRect;
     [delegate deleteDelegate:flights.cost view:self];
}
-(void)swipefadeOut
{
    [UIView animateWithDuration:0.4 animations:^{
        [swipeView setAlpha:1.0];
    } completion:^(BOOL finished)
     {
         
     }];
}
-(void)swipefadeIn
{
    [UIView animateWithDuration:0.4 animations:^{
        [swipeView setAlpha:0.0];
    } completion:^(BOOL finished)
     {
         
     }];
}
-(CGFloat)calculateDistanceStartPoint:(CGPoint)startPoint EndingPoint:(CGPoint)endPoint
{
    CGFloat xDist =(endPoint.x - startPoint.x);
    CGFloat yDist = (endPoint.y - startPoint.y);
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}


-(void)gotoNextScreen:(CGPoint)animatePoint
{
    if(!flightDetailView)
    {
         flightDetailView=[[FlightDetailView alloc]initWithFrame:CGRectMake(0,0,320,screenHeight) WithFlightView:flights];
         [flightDetailView drawUI:flights];
        flightDetailView.delegate=self;
         [flightDetailView setBackgroundColor:[UIColor whiteColor]];
        flightDetailView.center=CGPointMake(-screenWidth/2, flightDetailView.center.y);
         flightDetailView.rootViewController=rootViewController;
        [rootViewController.view addSubview:flightDetailView];
    }
     [flightDetailView setAlpha:1.0];
     float xx=startingPoint.x-animatePoint.x;
     CGPoint center= flightDetailView.center;
     float distance=rect.origin.x-parentView.frame.origin.x;
    NSLog(@"distance in deatil =%f",distance);
    if(distance<-100)
    {
         IsAnimation=nil;
         IsEnterOnDetailViewController=YES;
         [UIView animateWithDuration:AmgineCellSwipeAnimationTime animations:^{
            flightDetailView.center=CGPointMake(screenWidth/2, screenHeight/2);
                rootViewController.parentView .center=CGPointMake(3*screenWidth/2, rootViewController.view.center.y);
                [rootViewController.parentView setAlpha:0.0f];
            }
            completion:^(BOOL finished)
            {
                [rootViewController.parentView setAlpha:0.0f];
                IsAnimation=@"";
            }
         ];
    }
    else
    {
          if(rootViewController.parentView.alpha>0.0)
          {
              flightDetailView.center=CGPointMake(center.x-xx, flightDetailView.center.y);
          }
    }
    
    

   
}

-(void)animationStartWhenPushDetail:(BOOL)isLeft
{
    IsAnimation=nil;
    userInteractionEnable=NO;
    float offset=10;
    if(isLeft)
    {
        offset=-offset;
    }
    [UIView animateWithDuration:0.25 animations:
     ^{
         
         parentView.center=CGPointMake(viewCenter.x+offset, viewCenter.y);
         if(isLeft)
         {
             if(!IsEnterOnDetailViewController)
             {
                 flightDetailView.center=CGPointMake(-screenWidth/2, screenHeight/2);
             }
             
         }
     }
                     completion:^(BOOL finished)
     {
         if(swipeView.alpha==1.0 && !isLeft)
         {
             [self swipeNext];
             [swipeView setAlpha:0.0f];
         }
         
         [UIView animateWithDuration:0.15 animations:
          ^{
              CGPoint point;
              point=parentView.center;
              parentView.center=CGPointMake(point.x-offset, viewCenter.y);
          }
                          completion:^(BOOL finished)
          {
        
              IsAnimation=@"";
              
              userInteractionEnable=YES;
          }
          ];
         
     }
     ];
    
}
-(void)flightDetailViewDisappear
{
    flightDetailView=nil;
    IsEnterOnDetailViewController=NO;
}


#pragma mark scrollDetailFunction
-(void)scrollDeatilView:(NSArray *)array
{
     AlterNativeFlightScrollClass *flightClass=[[AlterNativeFlightScrollClass alloc]initWithFrame:CGRectMake(0,screenHeight*.70f, screenWidth, 200)];
     flightClass.cell=self;
     flightClass.rootViewController=rootViewController;
     [flightClass drawUI:array];
     [rootViewController.view addSubview:flightClass];
     [[Data sharedData].dropDownObjContainer addObject:flightClass];
    [flightClass setAlpha:0.0f];
    [UIView animateWithDuration:0.2 animations:^{
        //flightClass.frame=CGRectMake(0,screenHeight*.70f, screenWidth, 200);
        [flightClass setAlpha:1.0f];
    } completion:^(BOOL finished) {
        
    }];
    
}
-(void)addBorder
{
     rectangle.strokeColor =[UIColor colorWithRed:144.0f/255.0f green:43.0f/255.0f blue:43.0f/255.0f alpha:1.0f].CGColor;
     rectangle.lineWidth=2.5f;
    [[[Data sharedData]borderViewArray]addObject:rectangle];
}
-(void)removeBorder
{
    if([Data sharedData].borderViewArray.count>0)
    {
          [[[Data sharedData]borderViewArray]removeObject:rectangle];
    }
     rectangle.strokeColor =rectangleStrokeColor.CGColor;
}

-(void)swipeViewDelete
{
    //[swipeView setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:99.0f/255.0f blue:71.0f/255.0f alpha:1.0f]];
    [swipeView setBackgroundColor:[colorPelette objectAtIndex:1]];
    [swipeView updateLabelText:@"DELETE"];

}
-(void)swipeNext
{
  //  [swipeView setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:150.0f/255.0f blue:122.0f/255.0f alpha:1.0f]];
    [swipeView setBackgroundColor:[colorPelette objectAtIndex:0]];
    [swipeView updateLabelText:@"NEXT"];
   // [swipeView setAlpha:0.0f];
}

#pragma mark activity Indicator Function
-(void)showActivityIndicator
{
    if(!activity)
    {
        NSLog(@"POINT:%f:%f",self.center.x,self.center.y);
        activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.center=CGPointMake(self.center.x+20, 22);
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
#pragma mark send response to server
-(void)sendResponseToServer:(NSDictionary *)dictionary
{
    isServerRequest=YES;
    UrlConnection *urlConnection=[[UrlConnection alloc]init];
    urlConnection.delegate=self;
    [urlConnection postData:dictionary searchType:@"Change"];
    [self showActivityIndicator];
}
#pragma mark urlConnectionDelegate
-(void)connectionDidFinishLoadingData:(NSData *)data withService:(UrlConnection *)connection
{
    isServerRequest=NO;
    NSLog(@"next flight Description=(%@-%@)",nextFlight.carrier,nextFlight.flightnumber);
    NSDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"Success:dictionary:%@",dictionary);
    [self  removeActivityIndicator];
     [[LiveData getInstance]updateFlightArray:nextFlight updateValue:@"0"];
     [[LiveData getInstance]updateFlightArray:self.flights updateValue:@"1"];
    [self updateView:nextFlight animationNeed:NO];
    [self drawalternativeDetail:YES];
     userInteractionEnable=YES;
    isFailure=NO;
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    isServerRequest=NO;
    NSLog(@"Error:");
    [self  removeActivityIndicator];
    [self addAlertView:errorMessage];
    [self undoCell];
     userInteractionEnable=YES;
     isFailure=YES;
}


-(void)addAlertView:(NSString *)message
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error!" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}
-(void)undoCell
{
    NSLog(@"undo cell");
    
}

-(void)dealloc
{
   // [imageView setAlpha:0.0];
   // [delegate deleteFromView:self];
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
