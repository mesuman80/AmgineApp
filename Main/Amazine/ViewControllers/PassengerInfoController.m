//
//  PassengerInfoController.m
//  Amgine
//
//   on 31/07/14.
//   
//

#import "PassengerInfoController.h"
#import "ScreenInfo.h"
#import "LiveData.h"
#import "PassengerInfoCell.h"
#import "Passenger.h"
#import "ReviewTipViewController.h"
#import "TravelerViewController.h"
#import "Data.h"

@interface PassengerInfoController ()

@end

@implementation PassengerInfoController
{
    UITableView *passengerTableView;
    NSArray *passengerArray;
   // BOOL isTouchAnyCell;
    int screenWidth;
    int screenHeight;
    NSMutableArray *passengerCellArray;
    NSMutableArray *passengerClick;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
     screenWidth=[ScreenInfo getScreenWidth];
    screenHeight=[ScreenInfo getScreenHeight];
    self.title=@"PassengerInfo";
    passengerArray=[LiveData getInstance].passengerArray;
    [self drawTableView];
     if(passengerArray.count>0)
    {
        [self drawContinueButton];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
    
    
}
#pragma mark tableViewSpecificFuction
-(void)drawTableView
{
    passengerTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, screenHeight-80) style:UITableViewStylePlain];
    passengerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [passengerTableView setDelegate:self];
    [passengerTableView setDataSource:self];
    [self.view addSubview:passengerTableView];
    
}
-(void)drawContinueButton
{
    UIButton *continueButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    continueButton.frame=CGRectMake(200,screenHeight-70,100,50);
    [continueButton setTitleColor:[[Data sharedData]buttonColor] forState:UIControlStateNormal];
    continueButton.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleTopMargin;
    [continueButton addTarget:self action:@selector(touchesOnContinueButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueButton];
}
-(void)touchesOnContinueButton:(id)sender
{
    if([self checkCellClick])
    {
        passengerClick=[[NSMutableArray alloc]init];
        for(PassengerInfoCell *cell in passengerCellArray)
        {
            if(cell.is_Touch==YES)
            {
                [passengerClick addObject:cell.passenger];
            }
            
        }
        ReviewTipViewController *reviewTipViewController=[[ReviewTipViewController alloc]init];
         reviewTipViewController.passengerClickArray=passengerClick;
        [LiveData getInstance].selectedpassengerArray=passengerClick;
        [self.navigationController pushViewController:reviewTipViewController animated:YES];
    }
    else
    {
        [self showAlertView:@"You must Select atleast one passenger" title:@"Alert"];
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    passengerCellArray=[[NSMutableArray alloc]init];
    return passengerArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"PassengerInfoCell";
    PassengerInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[PassengerInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Passenger *passenger=[passengerArray objectAtIndex:indexPath.row];
    cell.passenger=passenger;
    cell.passengerInfoController=self;
    [cell configureCell:passenger.name];
    [passengerCellArray addObject:cell];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark alertViewSpecific Function
-(void)showAlertView:(NSString *)alertMessage title:(NSString *)title
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      [alertView show];
}

-(BOOL)checkCellClick
{
    BOOL isTouchAnyCell=NO;
    for(PassengerInfoCell *cell in passengerCellArray)
    {
        if(cell.is_Touch==YES)
        {
            isTouchAnyCell=YES;
            break;
        }

    }
    return isTouchAnyCell;
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
