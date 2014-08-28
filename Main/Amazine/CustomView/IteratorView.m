//
//  IteratorView.m
//  Amazine
//
//  Created by Amgine on 14/06/14.
//  Copyright (c) 2014 Amgine. All rights reserved.
//

#import "IteratorView.h"
#import "Passenger.h"
#import "ScreenInfo.h"
#import "LineView.h"
#import "TotalPriceCell.h"


#import "Data.h"
#import "Constants.h"
#import "HotelDetailView.h"
#import "FlightDetailView.h"
#import  "IteratorViewController.h"
#import "LiveData.h"
#define timeGap 0.05;

@implementation IteratorView
{
    UIScrollView  *scrollView;
    float screenWidth;
    float screenHeight;
    BOOL pageControlBeingUsed;
    float height;
    float yy;
    NSMutableArray *ObjectStorage;
    TotalPriceCell *totalPriceCell;
    float totalCost;
    IteratorViewController *rootViewController;
    float animationTime;
    LineView *line;
    float lineOrigin;
    int numberOfObject;
    float cellFrameHeight;
    float factor;
    int reviewIndex;
    BOOL is_In_Flight_Loop;
}
@synthesize passengerIdArray,solution_id,iteratorIndex;//displaceMent;
@synthesize responseArray,colorCodeArray;

- (id)initWithFrame:(CGRect)frame WithRootViewController:(UIViewController *)rootController
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        rootViewController=(IteratorViewController *)rootController;
        screenWidth=[ScreenInfo getScreenWidth];
        screenHeight=[ScreenInfo getScreenHeight];
        ObjectStorage=[[NSMutableArray alloc]init];
        [self scrollViewSetup];
        height=0.0f;
        totalCost=0;
        totalPriceCell=nil;
        lineOrigin=0;
        factor=screenHeight/568.0f;
       
        line=nil;
        
        self.imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"undoImage2.png"]];
        self.imageView.frame=CGRectMake(270,10, 30, 30);
        [self.imageView setUserInteractionEnabled:YES];
        self.imageView.alpha=0.0f;
        [self addSubview:self.imageView];
        
      UITapGestureRecognizer *imageTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
      imageTap.numberOfTapsRequired=1;
       [self.imageView addGestureRecognizer:imageTap];
        
        if([Data sharedData].borderViewArray)
        {
            [[[Data sharedData]borderViewArray]removeAllObjects];
        }
        else
        {
            [Data sharedData].borderViewArray=[[NSMutableArray alloc]init];
        }

            
    }
    return self;
}
-(void)imageTap:(UITapGestureRecognizer *)recognizer
{
    
    if([Data sharedData].lastDeleteCell)
    {
        [self undoOption:[Data sharedData].lastDeleteCell withCost:@""];
    }
    
     // [self animationStart];
}
#pragma mark ScrollViewFunctions
-(void)scrollViewSetup
{
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,1, screenWidth, self.frame.size.height)];
    scrollView.pagingEnabled=NO;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    [self addSubview:scrollView];
}

-(void)setScrollViewContentSize:(CGSize)size
{
    scrollView.contentSize=size;
}

-(void)addLineScroll:(float)lineHeight
{
    line =[self addLineInView:CGRectMake(screenWidth*.24f,0, 3, lineHeight)WithColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
        /*[UIColor colorWithRed:1.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]*/
    line.frame=CGRectZero;
    [self addSubview:line];
    [self sendSubviewToBack:line];
    [self setScrollViewContentSize:CGSizeMake(screenWidth, lineHeight+4)];
    
  

}
#pragma mark Drawing Functions
-(LineView *)addLineInView:(CGRect)rect WithColor:(UIColor *)color
{
    LineView *lineView=[[LineView alloc]initWithFrame:rect];
    [lineView drawLineWithColor:color];
    return  lineView;
    
}
-(TotalPriceCell *)totalPriceCell:(CGRect)rect WithPassengerName:(NSString *)passengerName withIndex:(int)index
{
    totalPriceCell =[[TotalPriceCell alloc]initWithFrame:rect];
    UIColor *color=nil;
    if(index>=0)
    {
        color= [colorCodeArray objectAtIndex:index];
        
    }
    else
    {
       
        color=[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0];
    }

    rect.origin.x+=screenWidth*.25f;
    rect.size.width-=(screenWidth*.25f);
    totalPriceCell.rectangleRect=rect;
    [totalPriceCell drawRectangle:rect Color:color];
    [totalPriceCell drawImage];
    [totalPriceCell drawPlaceName:passengerName];
    
    
    NSString *date=[[Data sharedData]getDateFormat:@"yyyy-MM-dd" withDateString:[liveData.dateArray objectAtIndex:0] dateFormat:@"dd MMM"];
    if([[LiveData getInstance]dateArray].count>1)
    {
        NSString *finalDate=[[Data sharedData]getDateFormat:@"yyyy-MM-dd" withDateString:[liveData.dateArray lastObject] dateFormat:@"dd MMM"];
        [totalPriceCell drawDate:[NSString stringWithFormat:@"%@-%@",date,finalDate] is_Single:NO];
    }
    else
    {
        [totalPriceCell drawDate:date is_Single:YES];
    }
   
    [scrollView addSubview:totalPriceCell];
    [scrollView sendSubviewToBack:totalPriceCell];
     //[ObjectStorage addObject:totalPriceCell];
     [totalPriceCell setAlpha:0.0f];
     animationTime+=timeGap;
     [self performSelector:@selector(animationStart:) withObject:totalPriceCell afterDelay:animationTime];
    
    return totalPriceCell;
}
-(void)drawTotalCost:(NSString *)cost
{
    [totalPriceCell drawTotalPrice:cost];
}
-(HotelViewCell *)hotelView:(CGRect)rect withHotel:(Hotel *)hotel withIndex:(int)index withDate:(NSString *)date
{
    HotelViewCell *hotelView=[[HotelViewCell alloc]initWithFrame:rect];
    [[Data sharedData].reviewTipDisplayArray addObject:hotel];
    UIColor *color=nil;
    if(index>=0)
    {
          color= [colorCodeArray objectAtIndex:index];
          hotelView.passengerId=[[passengerIdArray objectAtIndex:index]paxguid];
          hotelView.colorPelette=[[[Data sharedData]colorpeletteCode]objectAtIndex:index];
      
    }
    else
    {
        // color=[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0];
        int arrayIndex=0;
        for(Passenger *passenger in passengerIdArray)
        {
            if([passenger.paxguid isEqualToString:hotel.paxguid])
            {
                color=[colorCodeArray objectAtIndex:arrayIndex];
                hotelView.passengerId=passenger.paxguid;
                hotelView.colorPelette=[[[Data sharedData]colorpeletteCode]objectAtIndex:arrayIndex];
                break;
            }
            arrayIndex++;
        }
    }
   
    rect.origin.x+=screenWidth*.25f;
    rect.size.width-=(screenWidth*.25f);
    hotelView.rectangleRect=rect;
    hotelView.hotels=hotel;
    hotelView.rootViewController=rootViewController;
    [hotelView drawRectangle:rect Color:color];
    [hotelView drawHotelName:hotel.hotelname];
    [hotelView drawCost:[NSString stringWithFormat:@"$%.02f",[[hotel cost]floatValue]]];
    [hotelView drawImage];
    hotelView.delegate=self;
    NSString *dateStr=nil;
    if(date)
    {
        dateStr=[[Data sharedData]getDateFormat:AmgineDateFormat withDateString:hotel.checkin dateFormat:@"dd MMM"];
    }
   // NSString *date=[[Data sharedData]getDateFormat:AmgineDateFormat withDateString:hotel.checkin dateFormat:@"dd MMM"];
    if(!is_In_Flight_Loop)
    {
      [hotelView drawDate:dateStr];
    }
   
    [scrollView addSubview:hotelView];
    [scrollView sendSubviewToBack:hotelView];
    [ObjectStorage addObject:hotelView];
    totalCost+=[[hotel cost]floatValue];
    [hotelView setAlpha:0.0f];
    
   [self performSelector:@selector(animationStart:) withObject:hotelView afterDelay:animationTime];
    
    return hotelView;
}
-(FlightViewCell *)flightView:(CGRect)rect withFlight:(Flight *)flight withIndex:(int)index withDate:(NSString *)date
{
    FlightViewCell *flightViewCell=[[FlightViewCell alloc]initWithFrame:rect];
    [[Data sharedData].reviewTipDisplayArray addObject:flight];
    UIColor *color=nil;
    if(index>=0)
    {
         color= [colorCodeArray objectAtIndex:index];
         flightViewCell.passengerId=[[passengerIdArray objectAtIndex:index]paxguid];
         flightViewCell.colorPelette=[[[Data sharedData]colorpeletteCode]objectAtIndex:index];
    }
    else
    {
        //color=[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0];
        int arrayIndex=0;
        for(Passenger *passenger in passengerIdArray)
        {
            NSLog(@"value of passengerIdArary=%@",passenger.paxguid);
            NSLog(@"value of flightId=%@",flight.paxguid);
            if([passenger.paxguid isEqualToString:flight.paxguid])
            {
                 color=[colorCodeArray objectAtIndex:arrayIndex];
                 flightViewCell.passengerId=passenger.paxguid;
                  flightViewCell.colorPelette=[[[Data sharedData]colorpeletteCode]objectAtIndex:arrayIndex];
                break;
            }
            arrayIndex++;
        }

    }

    rect.origin.x+=screenWidth*.25f;
    rect.size.width-=(screenWidth*.25f);
    flightViewCell.rectangleRect=rect;
    flightViewCell.rootViewController=rootViewController;
    flightViewCell.flights=flight;
    flightViewCell.delegate=self;
    [flightViewCell drawRectangle:rect Color:color];
    [flightViewCell drawImage];
    [flightViewCell drawOrigin_DestinationPlace:[NSString stringWithFormat:@"%@ - %@",flight.origin,flight.destination]];
    [flightViewCell drawFlightNumber:flight.flightnumber];
    
    NSString *dateStr=nil;
    if(date)
    {
        dateStr=[[Data sharedData]getDateFormat:AmgineDateFormat withDateString:flight.departure dateFormat:@"dd MMM"];
    }
   // dateStr=[[Data sharedData]getDateFormat:AmgineDateFormat withDateString:flight.departure dateFormat:@"dd MMM"];
    if(!is_In_Flight_Loop)
    {
        [flightViewCell drawDate:dateStr];
    }
    
    [flightViewCell drawCost:[NSString stringWithFormat:@"$%.02f",[[flight cost]floatValue]]];
    
    [scrollView addSubview:flightViewCell];
    [scrollView sendSubviewToBack:flightViewCell];
    [ObjectStorage addObject:flightViewCell];
    totalCost+=[[flight cost]floatValue];
    
    [flightViewCell setAlpha:0.0f];
    
   [self performSelector:@selector(animationStart:) withObject:flightViewCell afterDelay:animationTime];
    
    return flightViewCell;
}

#pragma mark FlightAndHotelDataSetup
-(void)flightHotelData:(int)index
{
    height=0;
    yy=0;
    Passenger *passenger  =[passengerIdArray objectAtIndex:index];
    [self totalPriceData:passenger.name withIndex:index];
    [self allDataSetUp:index];
}

-(void)drawAllPassengerData
{
    height=0;
    yy=0;
   [self totalPriceData:@"Total Cost" withIndex:-1];
   [self allDataSetUp:-1];
}
-(void)allDataSetUp:(int)indexValue
{
    NSDictionary *flightDictionary=nil;
    NSDictionary *hotelDictionary=nil;
    NSString *passengerId=nil;
    BOOL IsInsideLoop=NO;
    int tagValue=0;
    is_In_Flight_Loop=NO;
    for(NSString *date in [LiveData getInstance].dateArray)
    {
        NSString *date1=[date substringToIndex:10];
        NSMutableArray *flightAccDate=[[NSMutableArray alloc]init];
        NSMutableArray *hotelAccDate=[[NSMutableArray alloc]init];
        for(Flight *flight in [LiveData getInstance].flightArray)
        {
             NSLog(@"flight departure=%@",flight.guid);
            if([[Data sharedData]stringContain:flight.departure withDateString:date1])
            {
                
                [flightAccDate addObject:flight];
                
            }
        }
        for(Hotel *hotel in [LiveData getInstance].hotelArray)
        {
            
            if([[Data sharedData] stringContain:hotel.checkin withDateString:date1])
            {
                 [hotelAccDate addObject:hotel];
            }
            
        }
        if(hotelAccDate.count>0)
        {
                   [liveData.hotelDictionary setObject:hotelAccDate forKey:date];
        }

        if(flightAccDate.count>0)
        {
             [liveData.flightDictionary setObject:flightAccDate forKey:date];
        }
    }

    flightDictionary =[LiveData getInstance].flightDictionary;
    hotelDictionary =[LiveData getInstance].hotelDictionary;
      /*****change******/
    if(indexValue>=0)
    {
      passengerId=[[passengerIdArray objectAtIndex:indexValue]paxguid];
    }
    NSLog(@"live data=%i",liveData.dateArray.count);
    
     for(NSString *date in liveData.dateArray)
     {
          is_In_Flight_Loop=NO;
          NSArray *flightArray= [flightDictionary valueForKey:date];
         is_In_Flight_Loop=NO;
         for(Flight *flight in flightArray)
         {
           if([flight.isalternative isEqualToString:@"0"])
             {
                 
                 FlightViewCell *flightCell=nil;
                 if([[[Data sharedData]passengerScreen]isEqualToString:@"ALL"])
                 {
                     IsInsideLoop=YES;
                    
                     NSLog(@"In All");

                 }
                 else if([passengerId isEqualToString:flight.paxguid])
                 {
                      NSLog(@"In passenger");
                      IsInsideLoop=YES;
                 }
                 if(IsInsideLoop)
                 {
                      NSLog(@"Flight.paxGuid:passegerId:=(%@,%@)",flight.paxguid,passengerId);
                      animationTime+=timeGap;
                     flightCell=[self flightView:CGRectMake(0,height+3, screenWidth, CellHeight+10) withFlight:(Flight *)flight withIndex:indexValue withDate:flight.departure];
                      is_In_Flight_Loop=YES;
                     flightCell.flightArray=flightArray;
                     flightCell.tag=tagValue;
                     if(tagValue==0)
                     {
                         [Data sharedData].selectedCellIndex=tagValue;
                         [flightCell addBorder];
                         [flightCell drawalternativeDetail:YES];
                     }
                     yy=yy+CellDisplaceMent+10;
                     height+=CellDisplaceMent+10;
                     tagValue++;
                     IsInsideLoop=NO;
                    // break;
                }

                 
             }
         }
        
         IsInsideLoop=NO;
         NSArray *hotelArray=[hotelDictionary valueForKey:date];
         for(Hotel *hotel in hotelArray)
         {
            if([hotel.isalternative isEqualToString:@"0"])
            {
                if([[[Data sharedData]passengerScreen]isEqualToString:@"ALL"])
                {
                    NSLog(@"In All");
                    IsInsideLoop=YES;
                   
                    
                }
                else if([passengerId isEqualToString:hotel.paxguid])
                {
                    NSLog(@"In Passenger");
                    IsInsideLoop=YES;
                    
                    
                }
                if(IsInsideLoop)
                {
                    animationTime+=timeGap;
                    NSString *dateStr=hotel.checkin;
                    if(is_In_Flight_Loop)
                    {
                       // dateStr=nil;
                    }
                    else
                    {
                     //  dateStr=hotel.checkin;
                    }
                    HotelViewCell *hotelCell=[self hotelView:CGRectMake(0,height+3, screenWidth,CellHeight+10) withHotel:(Hotel *)hotel withIndex:indexValue withDate:dateStr];
                    hotelCell.hotelArray=hotelArray;
                    hotelCell.tag=tagValue;
                    if(tagValue==0)
                    {
                        [Data sharedData].selectedCellIndex=tagValue;
                        [hotelCell addBorder];
                        [hotelCell drawalternativeDetail:YES];
                    }
                    
                    yy=yy+CellDisplaceMent+10;
                    height+=CellDisplaceMent+10;
                    tagValue++;
                    IsInsideLoop=NO;
                   // break;
                }

                
            }
         }
         
     }
    [self drawTotalCost:[NSString stringWithFormat:@"$%.02f",totalCost]];
     height=yy;
    [self addLineScroll:height];
}


#pragma mark Draw FlightData and HotelData and PriceData
-(void)totalPriceData:(NSString *)passengerName withIndex:(int)index
{
    TotalPriceCell *priceCell=[self totalPriceCell:CGRectMake(0,height+3, screenWidth, CellHeight+10)WithPassengerName:passengerName withIndex:index];
    yy+=priceCell.frame.size.height;
    yy+=ABS(((CellHeight/2-CellDisplaceMent/2)));
    NSLog(@"value of %d",ABS(((CellHeight/2-CellDisplaceMent/2))));
    height+=CellDisplaceMent+10;
    
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
	if (!pageControlBeingUsed)
    {
        
		
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	pageControlBeingUsed = NO;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	pageControlBeingUsed = NO;
    
}

#pragma mark Gesture Recognization
- (void)singleTapGestureCaptured:(UIPanGestureRecognizer *)gesture
{
    CGPoint touchPoint=[(UIPanGestureRecognizer*)gesture locationInView:scrollView];
     UIView *cell=nil;
     if (gesture.state == UIGestureRecognizerStateBegan)
     {
         NSLog(@"touch Start:(%f,%f)",touchPoint.x,touchPoint.y);
         cell=[self updateView:touchPoint isSwipe:NO];
         if([cell isKindOfClass:[FlightViewCell class]])
         {
             cell=(FlightViewCell *)cell;
         }
         else if([cell isKindOfClass:[HotelViewCell class]])
         {
              cell=(HotelViewCell *)cell;
         }
     }
    else if(gesture.state == UIGestureRecognizerStateChanged)
    {
        if(cell)
        {
              NSLog(@"touch move:(%f,%f)",touchPoint.x,touchPoint.y);
            
        }
    }
    else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"touch End:(%f,%f)",touchPoint.x,touchPoint.y);
        
        
    }
  
}

- (void)tapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint=[(UITapGestureRecognizer*)gesture locationInView:scrollView];
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"Tap touch Start:(%f,%f)",touchPoint.x,touchPoint.y);
    }
    else if(gesture.state == UIGestureRecognizerStateChanged)
    {
        NSLog(@"Tap touch move:(%f,%f)",touchPoint.x,touchPoint.y);
    }
    else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"Tap touch End:(%f,%f)",touchPoint.x,touchPoint.y);
    }
    //  [self updateView:touchPoint isSwipe:NO];
}
-(UIView *)updateView:(CGPoint)touchPoint isSwipe:(BOOL)isSwipe
{
      int index=0;
       for(UIView *cell in ObjectStorage)
       {
           if(CGRectContainsPoint(cell.frame,touchPoint))
           {
               if([cell isKindOfClass:[FlightViewCell class]])
               {
                    return cell;
                  
               }
               else if ([cell isKindOfClass:[HotelViewCell class]])
               {
                   return cell;
               }
           }
           index++;
       }
    
    return nil;

}
-(void)handleSwipe:(UISwipeGestureRecognizer *)swipe
{
    CGPoint touchPoint = [swipe locationInView:scrollView];
    if (swipe.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"touch Start:(%f,%f)",touchPoint.x,touchPoint.y);
    }
    else if(swipe.state == UIGestureRecognizerStateChanged)
    {
        NSLog(@"touch move:(%f,%f)",touchPoint.x,touchPoint.y);
    }
    else if(swipe.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"touch End:(%f,%f)",touchPoint.x,touchPoint.y);
    }

    
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
       // [self updateView:point isSwipe:YES];
    }
}
#pragma mark DetailViewFunction
-(void)hotelDetailViewWithHotel:(Hotel *)hotel
{

    
    HotelDetailView *hotelDetailView=[[HotelDetailView alloc]initWithFrame:CGRectMake(0,0,320,568)withHotelView:hotel];
     hotelDetailView.center=CGPointMake(-screenWidth/2, hotelDetailView.center.y);
     hotelDetailView.rootViewController=rootViewController;
    [UIView animateWithDuration:AmgineCellSwipeAnimationTime animations:^{
        hotelDetailView.center=CGPointMake(screenWidth/2, hotelDetailView.center.y);
        rootViewController.parentView .center=CGPointMake(3*screenWidth/2, rootViewController.view.center.y);
    } completion:^(BOOL finished) {
        [rootViewController.parentView setAlpha:0.0f];
    }];
    [rootViewController.view addSubview:hotelDetailView];

    
    
}
-(void)flightDetailViewWithFlight:(Flight *)flight
{
    
    FlightDetailView *flightDetailView=[[FlightDetailView alloc]initWithFrame:CGRectMake(0,45*factor,320,factor*(568-45*factor)) WithFlightView:flight];
    flightDetailView.center=CGPointMake(-screenWidth/2, flightDetailView.center.y);
    flightDetailView.rootViewController=rootViewController;
   // [rootViewController.view addSubview:flightDetailView];
    [UIView animateWithDuration:AmgineCellSwipeAnimationTime animations:^{
        flightDetailView.center=CGPointMake(screenWidth/2, flightDetailView.center.y);
        rootViewController.parentView .center=CGPointMake(3*screenWidth/2, rootViewController.view.center.y);
    } completion:^(BOOL finished) {
        [rootViewController.parentView setAlpha:0.0f];
    }];
    [rootViewController.view addSubview:flightDetailView];
}

-(void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
#pragma mark AnimationFunction
-(void)animationStart:(id)cell
{
    UIView *view=(UIView *)cell;
    [view setAlpha:1.0f];
    lineOrigin+=(view.frame.size.height+8.0f);
    view.center=CGPointMake(view.center.x+screenWidth,view.center.y);
    [UIView animateWithDuration:0.25 animations:^
    {
       view.center=CGPointMake(view.center.x-screenWidth,view.center.y);
        line.frame=CGRectMake(screenWidth*.24f,-2,3,lineOrigin);
    }
    completion:^(BOOL finished)
    {
       
    }
   ];
   
}
-(void)deleteFadeOutAnimation:(UIView *)cell
{
    [UIView animateWithDuration:0.1 animations:^{
        [cell setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [cell removeFromSuperview];
    }];
}
-(void)animateCell:(UIView *)cell
{
   CGRect cellFrame=cell.frame;
   [UIView animateWithDuration:0.25 animations:^{
     cell.frame=CGRectMake(cellFrame.origin.x, cellFrame.origin.y-cellFrameHeight-8,cellFrame.size.width,cellFrame.size.height);
     //cell.center=CGPointMake(cell.center.x, cell.center.y-cellFrameHeight-8);
     
   } completion:^(BOOL finished) {
      
   }];
}

-(void)animateCellUndo:(UIView *)cell
{
   CGRect cellFrame=cell.frame;
    [UIView animateWithDuration:0.25 animations:^{
        
        cell.frame=CGRectMake(cellFrame.origin.x, cellFrame.origin.y+cellFrameHeight+8, cellFrame.size.width, cellFrame.size.height);
        
    } completion:^(BOOL finished) {
        
    }];

}

-(void)animateLastCellInListView:(UIView *)cell
{
    CGRect cellFrame=cell.frame;
    [UIView animateWithDuration:0.25 animations:^{
        
        cell.frame=CGRectMake(cellFrame.origin.x, cellFrame.origin.y-cellFrameHeight-8, cellFrame.size.width, cellFrame.size.height);
        
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark HotelViewDelegate

-(void)gotoNextScreen:(NSString *)string withRootView:(UIView *)cell withPoint:(CGPoint)point
{
    if([string isEqualToString:@"Hotel"])
    {
        HotelViewCell *hotelView=(HotelViewCell *)cell;
        [self hotelDetailViewWithHotel:hotelView.hotels];
    }
    else
    {
        FlightViewCell *flightCell=(FlightViewCell *)cell;
        [self flightDetailViewWithFlight:flightCell.flights];
    }
}
-(void)returnDelegate:(NSString *)cost
{
    totalCost=totalCost-cost.floatValue;
    if(totalPriceCell)
    {
        [totalPriceCell updateTotalCost:[NSString stringWithFormat:@"$%.02f",totalCost]];
    }
}


-(void)deleteDelegate:(NSString *)cost view:(UIView *)cell
{
     [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkUndoClick) object:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(enableUndoButton) object:nil];
    
    [self performSelector:@selector(checkUndoClick) withObject:self afterDelay:5.0];
     NSMutableArray *array=nil;
     animationTime=0;
    if([cell isKindOfClass:[HotelViewCell class]])
    {
         cell=(HotelViewCell *)cell;
         HotelViewCell *hotelViewCell=(HotelViewCell *)cell;
         Hotel *hotel=hotelViewCell.hotels;
         reviewIndex=[[Data sharedData]getIndexReviewArray:hotel];
         NSLog(@"value of Review Index=%i",reviewIndex);
        [[[Data sharedData]reviewTipDisplayArray]removeObjectAtIndex:reviewIndex];
        [[Data sharedData]deleteHotel:hotel];
        [hotelViewCell removeBorder];
        [rootViewController cleanArray];
    }
    else if([cell isKindOfClass:[FlightViewCell class]])
    {
         cell=(FlightViewCell *)cell;
         FlightViewCell *flightViewCell=(FlightViewCell *)cell;
         Flight *flight=flightViewCell.flights;
         reviewIndex=[[Data sharedData]getIndexReviewArray:flight];
         [[[Data sharedData]reviewTipDisplayArray]removeObjectAtIndex:reviewIndex];
         NSLog(@"*****Passenger id=%@",[Data sharedData].passengerScreen);
         [[Data sharedData]deleteFlight:flight];
         [flightViewCell removeBorder];
          [rootViewController cleanArray];
    }
    
    NSInteger indexValue=cell.tag;
    [ObjectStorage removeObject:cell];
    [self deleteFadeOutAnimation:cell];
    [self showAlternativeView:cell];
    totalCost=totalCost-cost.floatValue;
    cellFrameHeight=cell.frame.size.height;
    if(totalPriceCell)
    {
      [totalPriceCell updateTotalCost:[NSString stringWithFormat:@"$%.02f",totalCost]];
    }
    if(indexValue<ObjectStorage.count)
    {
         NSLog(@"Success");
    }
    else
    {
         NSLog(@"Array Max Limit");
         //Update Line Frame
         line.frame=CGRectMake(screenWidth*.24f,-2,3,line.frame.size.height-cellFrameHeight-8);
        return;
    }
    
    //Reshuffle Array
    array=[[NSMutableArray alloc]initWithArray:ObjectStorage];
    for(NSInteger i=indexValue;i<array.count;i++)
    {
        UIView *cell=[array objectAtIndex:i];
        cell.tag=i;
        [ObjectStorage removeObject:cell];
        [ObjectStorage addObject:cell];
    }
    
    //Arrange Cell Position
    for(NSInteger i=indexValue;i<ObjectStorage.count;i++)
    {
         UIView *item=[ObjectStorage objectAtIndex:i];
         animationTime+=timeGap;
         [self performSelector:@selector(animateCell:) withObject:item afterDelay:animationTime];
    }
    
    [self performSelector:@selector(enableUndoButton) withObject:nil afterDelay:1.0];
     line.frame=CGRectMake(screenWidth*.24f,-2,3,line.frame.size.height-cellFrameHeight-8);
}
-(void)enableUndoButton
{
    [self.imageView setAlpha:1.0];
}
-(void)showAlternativeView:(UIView *)view
{
    if(ObjectStorage.count==0)
    {
        return;
    }
    NSInteger index=view.tag;
    if(index==0)
    {
        index=0;
    }
    else
    {
        index--;
    }
    
    UIView *cell=[ObjectStorage objectAtIndex:index];
    if([cell isKindOfClass:[HotelViewCell class]])
    {
        [((HotelViewCell *)cell) drawalternativeDetail:YES];
        [((HotelViewCell *)cell) addBorder];

    }
    else if ([cell isKindOfClass:[FlightViewCell class]])
    {
        [((FlightViewCell *)cell) drawalternativeDetail:YES];
        [((FlightViewCell *)cell) addBorder];
    }
}

-(void)undoOption:(UIView *)cell withCost:(NSString *)cost
{
    BOOL isInsideLoop=NO;
     [self.imageView setAlpha:0.0];
     NSMutableArray *array=nil;
     NSString *cost1;
    cellFrameHeight=cell.frame.size.height;
    if([cell isKindOfClass:[HotelViewCell class]])
    {
         HotelViewCell *hotelViewCell=(HotelViewCell *)cell;
         Hotel *hotel=hotelViewCell.hotels;
         NSLog(@"hotelCheckIn=%@",hotel.checkin);
        
        [[[Data sharedData]reviewTipDisplayArray]insertObject:hotel atIndex:reviewIndex];
        if([Data sharedData].deleteIndex>=0)
        {
            [[[LiveData getInstance]hotelArray]insertObject:hotel atIndex:[Data sharedData].deleteIndex];
        }
        cost1=hotelViewCell.hotels.cost;;
    }
    else
    {
       // cell=(FlightViewCell *)cell;
        FlightViewCell *flightViewCell=(FlightViewCell *)cell;
        Flight *flight=flightViewCell.flights;
        [[[Data sharedData]reviewTipDisplayArray]insertObject:flight atIndex:reviewIndex];
        if([Data sharedData].deleteIndex>=0)
        {
            [[[LiveData getInstance]flightArray]insertObject:flight atIndex:[Data sharedData].deleteIndex];
            
        }

        cost1=flightViewCell.flights.cost;
    }
    NSInteger indexValue=cell.tag;
    totalCost=totalCost+cost1.floatValue;
  
    if(totalPriceCell)
    {
        [totalPriceCell updateTotalCost:[NSString stringWithFormat:@"$%.02f",totalCost]];
    }
    cell.tag=indexValue;
    [ObjectStorage insertObject:cell atIndex:cell.tag];
    [cell setAlpha:1.0];
    [cell setFrame:CGRectMake(1,cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
    [scrollView addSubview:cell];
    array=[[NSMutableArray alloc]initWithArray:ObjectStorage];
    
    for(NSInteger i=indexValue+1;i<array.count;i++)
    {
        UIView *cell=[array objectAtIndex:i];
        cell.tag=i;
        [ObjectStorage removeObject:cell];
        [ObjectStorage addObject:cell];
    }

    for(NSInteger i=indexValue+1;i<ObjectStorage.count;i++)
    {
         isInsideLoop=YES;
         UIView *cell=[ObjectStorage objectAtIndex:i];
           animationTime+=timeGap;
        [self performSelector:@selector(animateCellUndo:) withObject:cell afterDelay:animationTime];
    }
    line.frame=CGRectMake(screenWidth*.24f,-2,3,line.frame.size.height+cellFrameHeight+8);
    
    if(!isInsideLoop)
    {
         [self performSelector:@selector(animateLastCellInListView:) withObject:cell afterDelay:animationTime];
         if([cell isKindOfClass:[HotelViewCell class]])
         {
             [((HotelViewCell *)cell)addBorder];
             [((HotelViewCell *)cell)drawalternativeDetail:YES];
         }
         else if([cell isKindOfClass:[FlightViewCell class]])
         {
             [((FlightViewCell *)cell)addBorder];
             [((FlightViewCell *)cell)drawalternativeDetail:YES];
         }
    }
}


-(void)checkUndoClick
{
    [self.imageView setAlpha:0.0f];
}

-(void)touchStart
{
    if(self.imageView.alpha>0)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkUndoClick) object:self];
        [self.imageView setAlpha:0.0];
    }
    
}

-(void)gotoNextScreen:(NSString *)string withRootView:(UIView *)cell
{
    
}
@end
