//
//  ReviewTipViewController.m
//  Amgine
//
//  Created by Amgine on 22/07/14.
//   
//

#import "ReviewTipViewController.h"
#import "ReviewCell.h"
#import "ScreenInfo.h"
#import "Data.h"
#import "Hotel.h"
#import "Flight.h"
//#import "ProfileAndPayMentInfoController.h"
#import "PayMentInfoViewController.h"
#import "Passenger.h"
#import "LiveData.h"
#import "UpdateClass.h"
//#import "ReviewForBookingController.h"

@interface ReviewTipViewController ()

@end

@implementation ReviewTipViewController
{
    UITableView *tableView;
    NSMutableArray *ObjectToBeDisplay;
    int screenWidth;
    int screenHeight;
    BOOL isEdit;
    UIButton *editButton;
}

@synthesize passengerClickArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark viewLifeCycleFunctions
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Review";
    screenHeight=[ScreenInfo getScreenHeight];
    tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,320,screenHeight*.60f) style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view setBackgroundColor:[UIColor whiteColor]];
   // ObjectToBeDisplay=[Data sharedData].reviewTipDisplayArray;
    ObjectToBeDisplay=[[NSMutableArray alloc]init];
    [self getData];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    if(screenHeight==480)
    {
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    }
    if(ObjectToBeDisplay.count>0)
    {
        [self drawEditButton];
        [self drawContinueButton];
    }
    
}
-(void)getData
{
    for(Flight *flight in [[LiveData getInstance]flightArray])
    {
      for(Passenger *passenger in passengerClickArray)
      {
          if([flight.isalternative isEqualToString:@"0"] && [passenger.paxguid isEqualToString:flight.paxguid])
          {
              [ObjectToBeDisplay addObject:flight];
          }

      }
    }
    
    NSLog(@"VALUE OF HOTELARRAY:%lu",(unsigned long)[LiveData getInstance].hotelArray.count);
    for(Hotel *hotel in [[LiveData getInstance]hotelArray])
    {
        for(Passenger *passenger in passengerClickArray)
        {
            if([hotel.isalternative isEqualToString:@"0"] && [passenger.paxguid isEqualToString:hotel.paxguid])
            {
                [ObjectToBeDisplay addObject:hotel];
            }
        }
        
    }
    
    
}

#pragma mark ButtonDrawingFunction
-(void)drawEditButton
{
    isEdit=YES;
    editButton=[UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame=CGRectMake(250, tableView.frame.size.height+10, 45, 45);
    [editButton setTitle:@"Edit" forState:UIControlStateNormal];
    //[editButton setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    [editButton setTitleColor:[[Data sharedData]buttonColor] forState:UIControlStateNormal];
    editButton.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleTopMargin;
    [editButton addTarget:self action:@selector(touchesOnEditButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editButton];
}
-(void)drawContinueButton
{
    UIButton *continueButton=[UIButton buttonWithType:UIButtonTypeCustom];
    continueButton.frame=CGRectMake(220,screenHeight*.90f,80, 45);
    [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    //[editButton setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    [continueButton setTitleColor:[[Data sharedData]buttonColor] forState:UIControlStateNormal];
    continueButton.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleTopMargin;
    [continueButton addTarget:self action:@selector(touchesOnContinueButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueButton];
}


-(void)touchesOnContinueButton:(id)sender
{
    NSLog(@"Touch on Continue Button");
    NSArray *arr=self.navigationController.viewControllers;
    PayMentInfoViewController *paymentController=nil;
    //PayMentInfoNavigationController
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    paymentController=[storyBoard instantiateViewControllerWithIdentifier:@"Amgine_PayMentInfoView"];
        paymentController.selectedData=ObjectToBeDisplay;
    [self.navigationController pushViewController:paymentController animated:YES];
    
}
-(void)touchesOnEditButton:(id)sender
{
    
    if(isEdit)
    {
        
        [self showDoneText];
        [tableView setEditing:YES animated:YES];
      
    }
    else
    {
        
        [self showEditText];
        [tableView setEditing:NO animated:YES];
    }
   
}
-(void)showDoneText
{
    if([self isExpire])
    {
        [editButton removeFromSuperview];
        return;
    }
    isEdit=NO;
    [editButton setTitle:@"Done" forState:UIControlStateNormal];
    
}
-(void)showEditText
{
    if([self isExpire])
    {
        [editButton removeFromSuperview];
        return;
    }

    isEdit=YES;
    [editButton setTitle:@"Edit" forState:UIControlStateNormal];
    
}

-(BOOL)isExpire
{
    if(ObjectToBeDisplay.count>0)
    {
        return 0;
    }
    else
    {
        return 1;
    }
    
}
#pragma mark TableViewSpecific Function
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ObjectToBeDisplay.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reviewCellIdentifier=@"ReviewCell";
    ReviewCell *reviewCell = [tableView dequeueReusableCellWithIdentifier:reviewCellIdentifier];
    if(reviewCell==nil)
    {
         reviewCell=[[ReviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewCellIdentifier];
    }
    [reviewCell configureCell:[ObjectToBeDisplay objectAtIndex:indexPath.row]];
    reviewCell.selectionStyle=UITableViewCellSelectionStyleNone;
    return reviewCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDoneText];
}

-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [self]
     [self showEditText];
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [tableView setEditing:editing animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self showEditText];
        [self deleteRow:indexPath];
        
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)deleteRow:(NSIndexPath *)indexPath
{
   
    id item=[ObjectToBeDisplay objectAtIndex:indexPath.row];
    if([item isKindOfClass:[Hotel class]])
    {
        [[Data sharedData]deleteHotel:(Hotel *)item];
    }
    else if ([item isKindOfClass:[Flight class]])
    {
         [[Data sharedData]deleteFlight:(Flight *)item];
    }
    [ObjectToBeDisplay removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
