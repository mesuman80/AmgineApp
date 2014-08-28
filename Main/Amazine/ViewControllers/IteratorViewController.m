//
//  ResultViewController.m
//  Amazine
//
//  Created by Amgine on 11/06/14.
//  Copyright (c) 2014 Amgine. All rights reserved.
//

#import "IteratorViewController.h"
#import "Data.h"
#import "ScreenInfo.h"
#import "Constants.h"
#import "IteratorView.h"
#import "Passenger.h"
#import "LineView.h"

#import "LiveData.h"
//#import "ReviewTipViewController.h"
#import "PassengerInfoController.h"
#import "UrlConnection.h"
#import "UserLoginViewController.h"

@interface IteratorViewController ()

@end

@implementation IteratorViewController
{
    float screenWidth;
    float screenHeight;
    BOOL is_First_Time;
    NSInteger buttonTag;
   
    NSArray *entityArray;
   
    UIColor *backGroundColor;
   
    NSMutableArray *iteratorViewArray;
    float lineDistance;
    int previousIndex;
    float displaceMent;
    int difference;
 
    NSMutableArray *colorCodeArray;
    float factor;
    UIImageView *selectedPassenger;
    UIButton *allPassengerButton;
    
    BOOL isUpdate;
    
    
}
@synthesize searchingBar,solutionid;
@synthesize parentView;

#pragma mark ViewLifeCycleFuction
- (void)viewDidLoad
{
    [super viewDidLoad];
    isUpdate=NO;
    [[Data sharedData]setSelectedPassengerIndex:-1];
    parentView=[[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:parentView];
    [Data sharedData].reviewTipDisplayArray=[[NSMutableArray alloc]init];
    factor=self.view.frame.size.height/568.0f;
    [self.view setBackgroundColor:[UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0f]];
    [self drawRightSideButton];
    [Data sharedData].passengerScreen=nil;
    [Data sharedData].deleteIndex=-1;
    if(![Data sharedData].dropDownObjContainer)
    {
        [Data sharedData].dropDownObjContainer=[[NSMutableArray alloc]init];
    }

    [self initilize];
    [self openUrl];
   
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"*********value of selected Index=%i",[[Data sharedData]selectedPassengerIndex]);
   if([Data sharedData].selectedPassengerIndex>=0 && isUpdate)
    {
        [self addIteratorView:[[Data sharedData]selectedPassengerIndex]];
        //[Data sharedData].selectedPassengerIndex=-1;
         isUpdate=NO;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        
        if(1)
        {
            NSLog(@"Touch on back Navigation Bar");
        }
    }
    
}
-(void)openUrl
{
    UrlConnection *connection=[[UrlConnection alloc]init];
    [connection setDelegate:nil];
    [connection setServiceName:AmginePreBooking];
    NSDictionary *dictionary=@{
                               @"solutionid":[[LiveData getInstance]solution_ID]
                               };
    [connection postData:dictionary searchType:@"book/prebookcache"];
}
-(void)drawRightSideButton
{
    UINavigationBar *navbar= self.navigationController.navigationBar;
    NSLog(@"bar=%@",navbar);
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"Book" style:UIBarButtonItemStyleBordered target:self action:@selector(touchOnBookButton:)];
    self.navigationItem.rightBarButtonItem=item;
    [navbar sizeToFit];

    
}
-(void)drawBackButton
{
    UINavigationBar *navbar= self.navigationController.navigationBar;
    NSLog(@"bar=%@",navbar);
 
   UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(touchOnBackButton:)];

    self.navigationItem.leftBarButtonItem=item;
   

}
-(void)touchOnBackButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)touchOnBookButton:(id)sender
{
      isUpdate=YES;
     [[Data sharedData]addDeatilView:NO view:nil];
      parentView .center=CGPointMake(320/2,parentView.center.y);
     parentView.alpha=1.0f;
    if([[Data sharedData]getExistingUserInfo])
    {
         [self gotoPassengerInfoScreen];
    }
    else
    {
        [self openLoginScreen];
    }
        
   
}
-(void)gotoPassengerInfoScreen
{
    PassengerInfoController *passengerInfo=[[PassengerInfoController alloc]init];
    [self.navigationController pushViewController:passengerInfo animated:YES];
}
-(void)openLoginScreen
{
    UserLoginViewController *loginController=[[UserLoginViewController alloc]init];
    loginController.iteratorViewController=self;
    [self.navigationController pushViewController:loginController animated:YES];
}
-(void)initilize
{
    difference=0;
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    [searchingBar setDelegate:self];
  
    is_First_Time=YES;
    screenWidth=[ScreenInfo getScreenWidth];
    screenHeight=[ScreenInfo getScreenHeight];
    displaceMent=0;
    
    [parentView addSubview:[self addLineInView:CGRectMake(0, screenHeight*.16f, self.view.bounds.size.width, 2) WithColor:[UIColor grayColor]]];
    [self addButton:[LiveData getInstance].passengerArray];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark SearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    
}
#pragma mark DisplaySpecificFunction
-(void)addButton:(NSArray *)passengerArray
{
   // screenWidth*.25f
    float xx=4;
    int i=0;
  
    iteratorViewArray=[[NSMutableArray alloc]init];
    UIScrollView *scrollPassengers=[[UIScrollView alloc]initWithFrame:CGRectMake(0, screenHeight*.08f, screenWidth,45)];
    scrollPassengers.pagingEnabled=NO;
    scrollPassengers.showsHorizontalScrollIndicator=NO;
    scrollPassengers.showsVerticalScrollIndicator=NO;
  
   [parentView addSubview:scrollPassengers];
    
    allPassengerButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [allPassengerButton setBackgroundImage:[UIImage imageNamed:@"groupIcon.png"] forState:UIControlStateNormal];
   
    allPassengerButton.tag=i;
    allPassengerButton.frame=CGRectMake(xx,7, 35, 35*factor);
    [allPassengerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     xx+=50;
    [allPassengerButton addTarget:self action:@selector(passengerClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollPassengers addSubview:allPassengerButton];
    i++;
    
   
 // NSLog(@"Rectangle Rect---->[%f,%f,%f,%f]", button.frame.origin.x, button.frame.origin.y, button.frame.size.width, button.frame.size.height);
    
   for(Passenger *passenger in passengerArray)
    {
        NSLog(@"value of passenger id=%@",passenger.paxguid);
     //   NSString *passengerId=passenger.paxguid;
         UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        
         [button setBackgroundImage:[UIImage imageNamed:@"UserIcon.png"] forState:UIControlStateNormal];
        //[button setTitle:[NSString stringWithFormat:@"P%i",i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         button.tag=i;
        button.frame=CGRectMake(xx, 7, 35, 35*factor);
      
         xx+=50;
        [button addTarget:self action:@selector(passengerClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollPassengers addSubview:button];
        i++;
      
       
    }
     scrollPassengers.contentSize=CGSizeMake(xx, 32*factor);
    colorCodeArray=[[Data sharedData]getColorCodeArray];
    [self addIteratorView:0];
}
-(void)addIteratorView:(NSInteger)index
{
    [[Data sharedData]setSelectedPassengerIndex:index];
     index=index-1;
  
    if(iteratorViewArray.count>0)
    {
        [[iteratorViewArray lastObject] removeFromSuperview];
        
    }
    [iteratorViewArray removeAllObjects];
    if(index>=0)
    {
        [self cleanArray];
        [self initilizeIteratorView:index];
    }
    else
    {
        [self cleanArray];
        [self addGlow:allPassengerButton];
        [self drawAllPassengerData];
    }
   
}
-(void)cleanArray
{
    if([Data sharedData].dropDownObjContainer.count>0)
    {
        [[[[Data sharedData].dropDownObjContainer lastObject]layer]removeAllAnimations];
        [[[Data sharedData].dropDownObjContainer lastObject]removeFromSuperview];
        [[Data sharedData].dropDownObjContainer removeAllObjects];
    }
    
}
-(void)initilizeIteratorView:(int)index
{
    [[Data sharedData]removeDropDownObject];
     IteratorView *iteratorView=[[IteratorView alloc]initWithFrame:CGRectMake(0, screenHeight*.165f, screenWidth, screenHeight*.699f-screenHeight*.165f)WithRootViewController:self];
     [[Data sharedData].reviewTipDisplayArray removeAllObjects];
     iteratorView.passengerIdArray=[[LiveData getInstance]passengerArray];
    [Data sharedData].passengerScreen=[[[[LiveData getInstance]passengerArray]objectAtIndex:index]paxguid];
     iteratorView.colorCodeArray=colorCodeArray;
    [iteratorView flightHotelData:index];
     NSLog(@"Value of PassengerScreen=%@",[Data sharedData].passengerScreen);
    [parentView addSubview:iteratorView];
    [iteratorViewArray addObject:iteratorView];
    previousIndex=index;
    
  //  [iteratorView setBackgroundColor:[UIColor redColor]];

}
-(void)passengerClick:(id)sender
{
    UIButton *button=(UIButton *)sender;
    
    if(button.tag==0 && is_First_Time)
    {
        NSLog(@"IS_FIrst Time");
              return;
    }
    else
    {
         is_First_Time=NO;
        if(button.tag!=buttonTag)
        {
             isUpdate=YES;
            [self addGlow:button];
            [self addIteratorView:button.tag];
        }
        else
        {
            NSLog(@"Touch on Same Button =%i",buttonTag+1);
        }
        buttonTag=button.tag;
       
    }
}
-(void)addGlow:(UIButton *)button
{
    if(selectedPassenger)
    {
        [selectedPassenger removeFromSuperview];
    }
    selectedPassenger =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circle.png"]];
    [selectedPassenger setFrame:CGRectMake(0, 0, 35, 35*factor)];
    [button addSubview:selectedPassenger];
}

-(void)imageTap:(UITapGestureRecognizer *)recognizer
{
  //  [self.imageView setAlpha:0.0f];
   // [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(deleteCellFromView) object:self];
   // [delegate undoOption:self withCost:flights.cost];
   // [self animationStart];
    
   
}

-(void)allPassenger:(id)sender
{
    [self drawAllPassengerData];
}

-(void)drawAllPassengerData
{
    [[Data sharedData]removeDropDownObject];
    IteratorView *iteratorView=[[IteratorView alloc]initWithFrame:CGRectMake(0, screenHeight*.165f, screenWidth, screenHeight*0.699f-screenHeight*.165f)WithRootViewController:self];
    [Data sharedData].passengerScreen=@"ALL";
    [[Data sharedData].reviewTipDisplayArray removeAllObjects];
     iteratorView.passengerIdArray=[[LiveData getInstance]passengerArray];
    
    iteratorView.colorCodeArray=colorCodeArray;
    [iteratorView drawAllPassengerData];
    [parentView addSubview:iteratorView];
    [iteratorViewArray addObject:iteratorView];

}

#pragma mark LineView
-(LineView *)addLineInView:(CGRect)rect WithColor:(UIColor *)color
{
    LineView *lineView=[[LineView alloc]initWithFrame:rect];
    [lineView drawLineWithColor:color];
    return  lineView;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
