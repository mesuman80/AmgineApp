//
//  SettingViewController.m
//  Amgine
//
//  Created by Amgine on 18/07/14.
//   
//

#import "SettingViewController.h"
#import "SettingView.h"
#import "Data.h"
#import "BasicProfileViewController.h"
#import "EmergencyViewController.h"
#import "PassportInfoViewController.h"
#import "PayMentProfileInfoViewController.h"
#import "PaymentHistoryViewController.h"
#import "TravelProfileViewController.h"



@interface SettingViewController ()

@end

@implementation SettingViewController
{
    NSArray *displayArray;
}
@synthesize settingTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

#pragma mark View Life Cycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Profile Info"];
    displayArray=[[NSArray alloc]initWithObjects:@"Basic Profile",@"Emergency Contact",@"Passport Info",@"Payment Info",@"Payment History",@"Travel Profile", nil];
    settingTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [settingTableView setDelegate:self];
    [settingTableView setDataSource:self];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark TableView Specific Function
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return   displayArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"SettingCell";
     //SettingView *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    SettingView *cell = [[SettingView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell configureCell:displayArray[indexPath.row]];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==0)//Basic Profile
    {
         BasicProfileViewController *basicProfileController=[[BasicProfileViewController alloc]init];
        [self.navigationController pushViewController:basicProfileController animated:YES];
    }
    else if(indexPath.row==1)//Emergency Contact
    {
         EmergencyViewController *emergencyViewController=[[EmergencyViewController alloc]init];
        [self.navigationController pushViewController:emergencyViewController animated:YES];

    }
    else if(indexPath.row==2)//Passport Info
    {
        PassportInfoViewController *passportInfoViewController=[[PassportInfoViewController alloc]init];
        [self.navigationController pushViewController:passportInfoViewController animated:YES];

    }
    else if (indexPath.row==3)//payment Info
    {
         PayMentProfileInfoViewController *payMentProfileInfoViewController=[[PayMentProfileInfoViewController alloc]init];
        [self.navigationController pushViewController:payMentProfileInfoViewController animated:YES];
    }
    else if(indexPath.row==4)//Payment History
    {
        PaymentHistoryViewController *paymentHistoryViewController=[[PaymentHistoryViewController alloc]init];
        [self.navigationController pushViewController:paymentHistoryViewController animated:YES];

    }
    else if(indexPath.row==5)//Travel Profile
    {
        TravelProfileViewController *travelProfileViewController=[[TravelProfileViewController alloc]init];
        [self.navigationController pushViewController:travelProfileViewController animated:YES];
 
    }
    
    
}

#pragma mark buttonTouch
- (IBAction)TouchOnCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Memory Warning Function
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
