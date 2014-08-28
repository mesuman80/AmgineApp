#import "ViewController.h"
#import "Data.h"
#import "Constants.h"
#import "InformationView.h"
#import "VIewInfoViewController.h"
#import "SearchViewController.h"
#import "TravelerViewController.h"
#import "UserLoginViewController.h"

#import "BookingConfirmationController.h"
#import "RegisterNewUser.h"
#import "ProfileInfo.h"
#import "RegisterNewUserController.h"
//#import "hotel.json"

#define AmgineUserLogIn @"LogIn"
#define AmgineUserLogOut @"LogOut"


@interface ViewController ()

@end

@implementation ViewController
{
    float factor;
    NSMutableArray *textArray;
    NSMutableArray *ImageArray;
    UIScrollView *scrollView;
    float screenWidth;
    float screenHeight;
    BOOL pageControlBeingUsed;
    NSMutableArray *infoViewArray;
    UIPageControl *pageControl;
    int no_of_pages;
    NSMutableArray *infoImageArray;
    UIColor *backGroundColor;
    
    UIDatePicker *datePicker;
    UIBarButtonItem *logInButton;
}
@synthesize tableView,buttonTypeRequest,buttonSpeechRequest;

#pragma mark ViewLifeCycleMethods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    factor=self.view.frame.size.height/568.0f;
    backGroundColor=[UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0f];
    [self.view setBackgroundColor:backGroundColor];
    pageControlBeingUsed=NO;
    screenWidth=self.view.frame.size.width;
    screenHeight=self.view.frame.size.height;
    infoImageArray=[[NSMutableArray alloc]initWithObjects:@"hotel1.jpg",@"hotel2.jpg",@"hotel3.jpg", nil];
    textArray=[[NSMutableArray alloc]initWithObjects:@"Voice Search",@"Text Search",@"My Profile", nil];
    ImageArray=[[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"", nil];
    [[Data sharedData]addBorderToButton:buttonSpeechRequest];
    [[Data sharedData]addBorderToButton:buttonTypeRequest];
    [self scrollViewSetup];
    [self setInformationView];
    [tableView setBackgroundColor:backGroundColor];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    logInButton=[[UIBarButtonItem alloc]initWithTitle:AmgineUserLogIn style:UIBarButtonItemStyleBordered target:self action:@selector(TouchOnLoginButton:)];

    self.navigationItem.rightBarButtonItem= logInButton;   //[self datePicker];
   
    
//    RegisterNewUser *registerNewUser=[[Data sharedData]getExistingUserInfo];
//    if(registerNewUser)
//    {
////        ProfileInfo *profileInfo  =[[Data sharedData]getExistingProfileInfo:registerNewUser.userName];
////        if(!profileInfo)
////        {
////            profileInfo =[NSEntityDescription insertNewObjectForEntityForName:AmgineProfileInfo inManagedObjectContext:[[Data sharedData]getContext]];
////        }
////        profileInfo.email_Id=registerNewUser.userName;
////        [[Data sharedData]writeToDisk];
////        [Data sharedData].userLoginProfileInfo=profileInfo;
//        [Data sharedData].isUserLogin=YES;
//
//    }
      // [self readJsonFomLocal];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    RegisterNewUser *registerNewUser=[[Data sharedData]getExistingUserInfo];
    if(registerNewUser)
    {
       if([logInButton.title isEqualToString:AmgineUserLogIn])
       {
            [Data sharedData].isUserLogin=YES;
           logInButton.title=registerNewUser.firstName;
       }
       
    }
    pageControlBeingUsed=NO;
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark TableViewSpecific Function
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return textArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    cell.textLabel.text=[textArray objectAtIndex:indexPath.row];
    // cell.imageView.image=[ImageArray objectAtIndex:indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor=backGroundColor;
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==1)
    {
       UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
      SearchViewController *searchViewController=[storyBoard instantiateViewControllerWithIdentifier:@"TextSearchController"];
       [self.navigationController pushViewController:searchViewController animated:YES];
        
//        BookingConfirmationController *bookingConfirmation=[[BookingConfirmationController alloc]init];
//        [self.navigationController pushViewController:bookingConfirmation animated:YES];
        
        
    }
    else if(indexPath.row==2)
    {
      if([[Data sharedData]isUserLogin])
      {
          RegisterNewUserController *registerNewUserLoginViewController=[[RegisterNewUserController alloc]init];
          [self.navigationController pushViewController:registerNewUserLoginViewController animated:YES];
          
      }
      else
      {
          UserLoginViewController *userLoginViewController=[[UserLoginViewController alloc]init];
          [self.navigationController pushViewController:userLoginViewController animated:YES];
      }
    }
    
       
        
}


#pragma mark Button Action
-(IBAction)speechRequest:(id)sender
{
    
}
-(IBAction)typeRequest:(id)sender
{
    
}
- (IBAction)TouchOnLoginButton:(id)sender
{
    UIBarButtonItem *loginButton=(UIBarButtonItem *)sender;
    if([loginButton.title isEqualToString:AmgineUserLogIn])
    {
        UserLoginViewController *userLoginViewController=[[UserLoginViewController alloc]init];
        [self.navigationController pushViewController:userLoginViewController animated:YES];
    }
    else
    {
        RegisterNewUserController *registerNewUserLoginViewController=[[RegisterNewUserController alloc]init];
        [self.navigationController pushViewController:registerNewUserLoginViewController animated:YES];
        
    }
   
}
#pragma mark ScrollViewFunctions
-(void)scrollViewSetup
{
     scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(screenWidth*.16,136*factor,screenWidth*.67f,216*factor)];
     scrollView.pagingEnabled=YES;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    [scrollView setDelegate:self];
    [self.view addSubview:scrollView];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    NSLog(@"origin=%f",scrollView.center.y);
}

-(void)setScrollViewContentSize:(CGSize)size
{
    scrollView.contentSize=size;
}
-(void)setInformationView
{
    //214
    infoViewArray=[[NSMutableArray alloc]init];
    int xx=107;
    for( int i=0;i<infoImageArray.count;i++)
    {
        InformationView *informationView=[[InformationView alloc]initWithFrame:CGRectMake(0,0,screenWidth*.67f,216*factor)];
         informationView.center=CGPointMake(xx,factor*108);
         informationView.tag=i;
         [informationView drawImage:[infoImageArray objectAtIndex:i]];
         xx+=214;
        [infoViewArray addObject:informationView];
        [scrollView addSubview:informationView];
        NSLog(@"origin=%f",scrollView.center.x);
    }
    
    [self setScrollViewContentSize:CGSizeMake(2*screenWidth, scrollView.frame.size.height)];
    no_of_pages =infoImageArray.count;
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((screenWidth)/2, (screenHeight)*.64,(screenWidth)*.010,(screenHeight)*.015)];
    pageControl.currentPage=0;
    pageControl.numberOfPages=no_of_pages;
    pageControl.pageIndicatorTintColor=[UIColor whiteColor];
    [pageControl setCurrentPageIndicatorTintColor:[[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:1]];
    [self.view addSubview:pageControl];
    
    UITapGestureRecognizer *infoImageTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(infoViewSelected:)];
    infoImageTap.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:infoImageTap];
    
    
}
-(void)infoViewSelected:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [(UITapGestureRecognizer*) recognizer locationInView:scrollView];
    for(InformationView *infoView in infoViewArray)
    {
        if(CGRectContainsPoint(infoView.frame, point))
        {
            [self gotoNextScreen:infoView];
            break;
        }
        
    }
}

-(void)gotoNextScreen:(InformationView *)infoView
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController=[storyBoard instantiateViewControllerWithIdentifier:@"ViewInfoController"];
    VIewInfoViewController *infoViewController=[navController.viewControllers objectAtIndex:0];
    infoViewController.imageView=infoView.infoImage;
    [infoViewController drawImage1:infoView.infoImage];
    [self presentViewController:navController animated:YES completion:nil];
}
-(void)modalHalfView
{
       
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
	if (!pageControlBeingUsed)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
		int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	    pageControl.currentPage = page;
		
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

#pragma mark Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end