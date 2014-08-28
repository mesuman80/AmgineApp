//
//  AlterNativeBaseScrollClass.m
//  Amgine
//
//  Created by Amgine on 17/07/14.
//   
//

#import "AlterNativeBaseScrollClass.h"
#import "ScreenInfo.h"
#import "Flight.h"
#import "Hotel.h"
#import "LineView.h"
#import "Data.h"
#import "AlternativeView.h"


@implementation AlterNativeBaseScrollClass
{
    NSString *displayString;
    NSString *costString;
    NSMutableArray *alternativeViewStorage;
}
@synthesize rootViewController,cell;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        screenWidth=[ScreenInfo getScreenWidth];
        screenHeight=[ScreenInfo getScreenHeight];
        factor=screenHeight/568.0f;
        [self scrollViewSetup];
    }
    return self;
}

#pragma mark ScrollViewFunctions
-(void)scrollViewSetup
{
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,5,screenWidth,self.frame.size.height)];
    scrollView.pagingEnabled=NO;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    [self addSubview:scrollView];
}

-(void)setScrollViewContentSize:(CGSize)size
{
    scrollView.contentSize=size;
}

-(void)drawUI:(NSArray *)drawArray
{
    BOOL isInFlight=NO;
    LineView *lineView=[[LineView alloc]initWithFrame:CGRectMake(0, 0,screenWidth,4)];
    [lineView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f]];
    [self addSubview:lineView];
    [self setBackgroundColor:[UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0f]];
    
     float yy=4;
    for( int i=0;i<drawArray.count;i++)
    {
        isInFlight=NO;
        id item=[drawArray objectAtIndex:i];
        if([item isKindOfClass:[Hotel class]])
        {
            Hotel *hotel=(Hotel *)item;
            displayString=hotel.hotelname;
            costString=hotel.cost;
        }
        else if ([item isKindOfClass:[Flight class]])
        {
              isInFlight=YES;
             Flight *flight=(Flight *)item;
             displayString=[NSString stringWithFormat:@"%@-%@",flight.origin,flight.destination];
             costString=flight.cost;
        }
         AlternativeView *alterNativeView=[[AlternativeView alloc]initWithFrame:CGRectMake(0,yy,screenWidth,50)];
         alterNativeView.rootCell=cell;
         alterNativeView.indexValue=i;
         alterNativeView.rootViewCtrl=rootViewController;
        alterNativeView.view=(UIView *)item;
        [alterNativeView labelDisplay:displayString];
        [alterNativeView costDisplay:costString];
        [alterNativeView drawIcon];
         yy+=alterNativeView.frame.size.height+2;
        [scrollView addSubview:alterNativeView];
        [alternativeViewStorage addObject:alterNativeView];
    }
    [self setScrollViewContentSize:CGSizeMake(0, yy+25)];
}

@end
