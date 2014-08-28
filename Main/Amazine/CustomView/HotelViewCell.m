//
//  RectangleView.m
//  Amazine
//
//  Created by Amgine on 13/06/14.
//  Copyright (c) 2014 Amgine. All rights reserved.
//

#import "HotelViewCell.h"
#import "Data.h"
#import "Constants.h"
#import "SwipeView.h"
#import "ScreenInfo.h"
#import "LiveData.h"
#import "AlternativeScrollHotelClass.h"


@implementation HotelViewCell
{
    CGPoint startingPoint;
    CGRect rect;
    UIView *parentView;
    CGPoint viewCenter;
    BOOL userInteractionEnable;
    int hotelIndex;
    
    UILabel *hotelName;
    UILabel *costLabel;
    UILabel *dateLabel;
    
  
    SwipeView *swipeView;
    NSString *IsAnimation;
    CGRect screenRect;
    
    float screenWidth;
    float screenHeight;
    float factor;
    HotelDetailView *hotelDetailView;
    
    BOOL leftSwipe;
    BOOL rightSwipe;
    
    BOOL IsEnterOnDetailViewController;
    BOOL isOutSideCell;
    int arrayIndex;
    
    //BOOL isInsideLoop;
    
    NSMutableArray *alternativeHotels;
    int reviewCellIndex;
    
 
    CAShapeLayer *rectangle;
    
    UIColor *rectangleStrokeColor;
    
    int nextHotelIndex;
    int previousHotelIndex;
     Hotel *nextHotel;
    BOOL isInLoop;
    
    BOOL isTouchDown;
  
      UIActivityIndicatorView *activity;
     BOOL isServerRequest;
     BOOL isFailure;
    
    BOOL isDisplayData;
    
}
@synthesize objectId,rectangleRect,hotels;
@synthesize hotelArray,delegate,rootViewController;
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
         viewCenter=CGPointMake(parentView.center.x, parentView.center.y);
         userInteractionEnable=YES;
        hotelIndex=arrayIndex=nextHotelIndex=1;
         IsAnimation=@"";
       [self addSubview:parentView];
        
        
      
        UITapGestureRecognizer *tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestures:)];
        tapGesture.numberOfTapsRequired=1;
        [self addGestureRecognizer:tapGesture];
       
        
        
    }
    return self;
}

- (void)handleTapGestures:(UITapGestureRecognizer *)sender
{
     NSLog(@"Tap Gesture");
    if(isServerRequest)
    {
        return;
    }

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
       // [rootViewController cleanArray];
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
        NSString *date1=[hotels.checkin substringToIndex:10];
        hotelArray=[[[LiveData getInstance]hotelDictionary]objectForKey:date1];
        alternativeHotels=nil;
        
    }
    if(!alternativeHotels)
    {
        alternativeHotels=[[NSMutableArray alloc]init];
        for(Hotel *hotel in hotelArray)
        {
            if([hotel.isalternative isEqualToString:@"1"]&&[hotel.paxguid isEqualToString:passengerId])
            {
                [alternativeHotels addObject:hotel];
            }
        }
    }
    [rootViewController cleanArray];
    [self scrollDeatilView:alternativeHotels];
}

-(void)drawImage
{
    UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotel.png"]];
    image.frame=CGRectMake(rectangleRect.origin.x-13, rectangleRect.origin.y+13, 20, 20);
    [parentView addSubview:image];
}

-(void)drawRectangle:(CGRect)rectanglRect1 Color:(UIColor *)color
{
    rectangleStrokeColor=color;
    rectangle = [CAShapeLayer layer];
    rectanglRect1.origin.y=0;
    rectangleRect.origin.y=0;
    
    swipeView =[[SwipeView alloc]initWithFrame:CGRectMake(rectanglRect1.origin.x+rectanglRect1.size.width,0,rectanglRect1.size.width+60, rectanglRect1.size.height)];
    [swipeView setBackgroundColor:[colorPelette objectAtIndex:0]];
    [swipeView labelText:@"NEXT"];

//    swipeView.swipePoint=self.center;
    
   // [self swipeNext];
    
    NSLog(@"center y=%f",self.center.y);
    [swipeView setAlpha:0.0f];
   [parentView addSubview:swipeView];
    
     rectangle.path = [UIBezierPath bezierPathWithRoundedRect:rectanglRect1 cornerRadius:0].CGPath;
     rectangle.position  = CGPointMake(0,0);
    rectangle.fillColor=color.CGColor;
    rectangle.strokeColor =color.CGColor;
    [parentView.layer addSublayer:rectangle];
  //  [self addBorder];
 

}
-(void)drawHotelName:(NSString *)value
{
    hotelName=[[UILabel alloc]initWithFrame:CGRectMake(rectangleRect.origin.x+20,3, 120,20)];
    hotelName.text=value;
    hotelName.textColor=[UIColor whiteColor];
    hotelName.font=[UIFont fontWithName:AmgineFont size:12.0];
    hotelName.adjustsFontSizeToFitWidth=NO;
    hotelName.lineBreakMode=NSLineBreakByWordWrapping;
    hotelName.numberOfLines=0;
    [hotelName setBackgroundColor:[UIColor clearColor]];
    [hotelName sizeToFit];
    [parentView addSubview:hotelName];
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


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(isServerRequest)
    {
        return;
    }
     startingPoint=[[touches anyObject]locationInView:parentView];
     isOutSideCell=NO;
     isTouchDown=YES;
   // [self addBorder];
    if(delegate)
    {
        [delegate touchStart];
    }
    
    if(!isFailure)
    {
         nextHotel=nil;
    }
   
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"IN HOTEL");
    CGPoint point=[[touches anyObject]locationInView:parentView];
    if(!userInteractionEnable || isOutSideCell || IsEnterOnDetailViewController || !isTouchDown)
    {
        return;
    }
  
    float distance=rect.origin.x-parentView.frame.origin.x;
    float xx=startingPoint.x-point.x;
    CGRect frame = parentView.frame;
    parentView.frame=CGRectMake(frame.origin.x-xx, frame.origin.y, frame.size.width, frame.size.height);
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
        
//        if(IsAnimation)
//        {
//            isOutSideCell=YES;
//            [self animationStart:YES];
//        }
        return;
    }
    

    //********************************Left Swipe*************************/
    
    else if (startingPoint.x>point.x)
    {
        NSLog(@"distance ********* =%f",distance);
        if(!nextHotel)
        {
            nextHotel=[self getNextHotel];
          
        }
         else if (!isDisplayData)
        {
              [self displayHotelData:nextHotel];
        }
        leftSwipe=YES;
        rightSwipe=NO;
        if(swipeView.alpha==0)
        {
            [swipeView setAlpha:1.0];
        }
        
        if(distance>240 && [swipeView.labelTextstr isEqualToString:@"NEXT"])
        {
            [swipeView resetHotelData];
            [self swipeViewDelete];
        }
//        else if (distance<=150 && [swipeView.labelTextstr isEqualToString:@"DELETE"])
//        {
//            [self swipeNext];
//        }
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
             [self displayHotelData:nextHotel];
             [self swipeNext];
        }

    }
    else if(point.y>rect.origin.y+self.frame.size.height && leftSwipe)
    {
        
        if(IsAnimation)
        {
//            NSLog(@"**************** outSide Frame ****************");
//            isOutSideCell=YES;
//            [self animationStart:NO];
        }
        return;
    }
    
    
 }
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    float distance=(rect.origin.x-parentView.frame.origin.x);
    isTouchDown=NO;
   // [self removeBorder];
    
    isDisplayData=NO;
    //*************************Right Swipe*****************//
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
             /************Update View********/
            if(userInteractionEnable && swipeView.alpha==1)
            {
                if(distance<239 && distance>67)
                {
                     [self animationStart:NO is_Update:YES];
                   // [self updateView:nextHotel animationNeed:YES];
                }
                else if(distance>=241 && distance<310)
                {
                    [self deleteCell];
                }
                else
                {
                    nextHotelIndex=previousHotelIndex;
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
-(void)displayHotelData:(Hotel *)hotel
{
    isDisplayData=YES;
     NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:[NSString stringWithFormat:@"%@",hotel.hotelname] forKey:@"HotelName"];
     [dictionary setValue:[NSString stringWithFormat:@"$%@",hotel.cost] forKey:@"HotelCost"];
     [swipeView displayHotelData:dictionary];
}
-(void)changeCenter
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeCenter) object:self];
    parentView.center=viewCenter;
    NSLog(@"Change Center");
}
-(void)animationStart:(BOOL)isLeft is_Update:(BOOL)is_Update
{
    NSLog(@"Animation Start");
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
                 hotelDetailView.center=CGPointMake(-screenWidth/2, screenHeight/2);
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
                                             @"alternativeid":nextHotel.guid
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
    hotelName.alpha=0.0;
    costLabel.alpha=0.0;
    [UIView animateWithDuration:0.7 animations:^{
        hotelName.alpha=1.0;
        costLabel.alpha=1.0;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)updateView:(Hotel *)updateHotel animationNeed:(BOOL)isNeed
{
    NSLog(@"I am in updating");
    if(!updateHotel)
    {
        updateHotel=[self getNextHotel];
    }
   // NSLog(@"")
    float cost=[[nextHotel cost]floatValue];
    reviewCellIndex=[[Data sharedData]getIndexReviewArray:hotels];
   [[[Data sharedData]reviewTipDisplayArray]removeObject:hotels];
    [[[Data sharedData]reviewTipDisplayArray]insertObject:updateHotel atIndex:reviewCellIndex];
    
    hotels=updateHotel;
    // isInsideLoop=YES;
    hotelName.text=hotels.hotelname;
    costLabel.text=[NSString stringWithFormat:@"$%@",hotels.cost];
     NSString *date=[[Data sharedData]getDateFormat:AmgineDateFormat withDateString:hotels.checkin dateFormat:@"dd MMM"];
    dateLabel.text=date;
    if(IsAnimation && isNeed)
    {
        NSLog(@"Animation start:");
        [self animationStart:NO is_Update:NO];
    }
    
    if(delegate)
    {
        [delegate returnDelegate:[NSString stringWithFormat:@"%.02f",cost-[[hotels cost]floatValue]]];
    }
    
//    NSLog(@"in Update View");
//
//    if(hotelArray.count>1)
//    {
//         Hotel *hotelCell=nil;
//        
//         for(int i=hotelIndex;i<hotelArray.count;i++)
//         {
//             hotelCell=[hotelArray objectAtIndex:i];
//            if([hotelCell.isalternative isEqualToString:@"1"]&&[passengerId isEqualToString:hotelCell.paxguid])
//            {
//                 isInsideLoop=YES;
//                NSLog(@"hotes.name=%@",hotelCell.hotelname);
//                reviewCellIndex=[[Data sharedData]getIndexReviewArray:hotels];
//                
//                [[[Data sharedData]reviewTipDisplayArray]removeObject:hotels];
//                
//                [[[Data sharedData]reviewTipDisplayArray]insertObject:hotelCell atIndex:reviewCellIndex];
//                
//                float cost=[[hotels cost]floatValue];
//                hotels=hotelCell;
//                 NSLog(@"hotes.name=%@",hotelCell.hotelname);
//                hotelName.text=hotels.hotelname;
//                costLabel.text=[NSString stringWithFormat:@"$%@",hotels.cost];
//                NSString *date=[[Data sharedData]getDateFormat:AmgineDateFormat withDateString:hotels.checkin dateFormat:@"dd MMM"];
//                dateLabel.text=date;
//                [self animateText];
//                if(IsAnimation)
//                {
//                    [self animationStart:NO];
//                }
//                if(delegate)
//                {
//                    [delegate returnDelegate:[NSString stringWithFormat:@"%.02f",cost-[[hotels cost]floatValue]]];
//                }
//                
//                arrayIndex++;
//                break;
//            }
//             arrayIndex++;
//        }
//        hotelIndex=arrayIndex;
//        if(hotelIndex>=hotelArray.count)
//        {
//           
//            hotelIndex=arrayIndex=0;
//        }
//        if(!isInsideLoop)
//        {
//            hotelIndex=arrayIndex=0;
//            if(IsAnimation)
//            {
//                NSLog(@"Animation start:");
//                [self animationStart:NO];
//            }
//        }
//
//    }
//    else
//    {
//        NSLog(@"no alternative Hotel");
//        
//        
//    }
//    isInsideLoop=NO;
}

-(Hotel *)getNextHotel
{
    isInLoop=NO;
    if(hotelArray.count>1)
    {
        previousHotelIndex=nextHotelIndex;
        Hotel *hotelCell=nil;
        
        for(int i=hotelIndex;i<hotelArray.count;i++)
        {
            hotelCell=[hotelArray objectAtIndex:i];
            if([hotelCell.isalternative isEqualToString:@"1"]&&[passengerId isEqualToString:hotelCell.paxguid])
            {
                isInLoop=YES;
                NSLog(@"hotes.name=%@",hotelCell.hotelname);
                 arrayIndex++;
                break;
            }
            arrayIndex++;
        }
        hotelIndex=arrayIndex;
        if(!isInLoop)
        {
            nextHotelIndex=arrayIndex=0;
            return [hotelArray objectAtIndex:0];
        }
        else
        {
            isInLoop=NO;
            if(hotelIndex>=hotelArray.count)
            {
                
                hotelIndex=arrayIndex=0;
                return [hotelArray objectAtIndex:arrayIndex];
            }
            
            return [hotelArray objectAtIndex:arrayIndex-1];
        }
    }
    return nil;
   
}
-(void)deleteCell
{
    //isMoveable=NO;
    [Data sharedData].lastDeleteCell=self;
    parentView.center=viewCenter;
    swipeView.alpha=0.0f;
    [self swipeNext];
    [Data sharedData].lastDeleteCell.frame=screenRect;
    [delegate deleteDelegate:hotels.cost view:self];
    NSLog(@"[hotels.checkout substringToIndex:10]=%@",[hotels.checkin substringToIndex:10]);
}

-(void)swipefadeOut
{
    [UIView animateWithDuration:0.2 animations:^{
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

#pragma mark gotoNextScreen
-(void)gotoNextScreen:(CGPoint)animatePoint
{
    if(!hotelDetailView)
    {
        hotelDetailView=[[HotelDetailView alloc]initWithFrame:CGRectMake(0,0,320,568*factor) withHotelView:hotels];
        hotelDetailView.delegate=self;
        [hotelDetailView setBackgroundColor:[UIColor whiteColor]];
        hotelDetailView.center=CGPointMake(-screenWidth/2, hotelDetailView.center.y);
        hotelDetailView.rootViewController=rootViewController;
        [rootViewController.view addSubview:hotelDetailView];
    }
    [hotelDetailView setAlpha:1.0];
    float xx=startingPoint.x-animatePoint.x;
    CGPoint center= hotelDetailView.center;
    float distance=rect.origin.x-parentView.frame.origin.x;
    NSLog(@"distance =%f",distance);
    if(distance<-100)
    {
        IsAnimation=nil;
        IsEnterOnDetailViewController=YES;
        [UIView animateWithDuration:AmgineCellSwipeAnimationTime animations:^{
            
            
            hotelDetailView.center=CGPointMake(screenWidth/2, screenHeight/2);
            rootViewController.parentView .center=CGPointMake(3*screenWidth/2, rootViewController.view.center.y);
            [rootViewController.parentView setAlpha:0.0f];
        }
         completion:^(BOOL finished)
         {
             [rootViewController.parentView setAlpha:0.0f];
             [hotelDetailView downLoadImage];
             IsAnimation=@"";
         }
         ];
    }
    else
    {
        if(rootViewController.parentView.alpha>0.0)
        {
            hotelDetailView.center=CGPointMake(center.x-xx, hotelDetailView.center.y);
        }
    }
}
-(void)hotelDetailViewDisappear
{
    [NSObject cancelPreviousPerformRequestsWithTarget:hotelDetailView selector:@selector(downLoadImage) object:nil];
    hotelDetailView=nil;
    IsEnterOnDetailViewController=NO;
}
#pragma mark scrollDetailFunction
-(void)scrollDeatilView:(NSArray *)array
{
    AlternativeScrollHotelClass *hotelClass=[[AlternativeScrollHotelClass alloc]initWithFrame:CGRectMake(0,screenHeight*.70f, screenWidth, 200)];
    hotelClass.rootViewController=rootViewController;
    hotelClass.cell=self;
    [hotelClass drawUI:array];
    [rootViewController.view addSubview:hotelClass];
    [[Data sharedData].dropDownObjContainer addObject:hotelClass];
    [hotelClass setAlpha:0.0f];
    [UIView animateWithDuration:0.4f animations:^{
        //hotelClass.frame=CGRectMake(0,screenHeight*.70f, screenWidth, 200);
        [hotelClass setAlpha:1.0f];
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
    NSDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"Success:dictionary:%@",dictionary);
    [self  removeActivityIndicator];
    [[LiveData getInstance]updateHotelArray:nextHotel updateValue:@"0"];
    [[LiveData getInstance]updateHotelArray:self.hotels updateValue:@"1"];
    [self updateView:nextHotel animationNeed:NO];
    [self drawalternativeDetail:YES];
     userInteractionEnable=YES;
    isFailure=NO;
    // nextHotelIndex=previousHotelIndex;
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
     isServerRequest=NO;
    NSLog(@"Error:");
    [self  removeActivityIndicator];
    [self addAlertView:errorMessage];
    [self undoCell];
    userInteractionEnable=YES;
    nextHotelIndex=previousHotelIndex;
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


@end
