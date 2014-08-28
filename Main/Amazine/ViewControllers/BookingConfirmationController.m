//
//  BookingConfirmationController.m
//  Amgine
//


#import "BookingConfirmationController.h"
#import "LiveData.h"
#import "BookingConfirmationCell.h"
#import "LineView.h"


@interface BookingConfirmationController ()

@end

@implementation BookingConfirmationController
{
    float screenWidth;
    float screenHeight;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark View Life Cycle Function
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self drawDoneButton];
    //[self readJsonFomLocal];
    [self setScrollView];
    
    
}
-(void)drawDoneButton
{
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:@"New Search" style:UIBarButtonItemStyleBordered target:self action:@selector(touchOnDone:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}
-(void)touchOnDone:(id)sender
{
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController=[storyboard instantiateInitialViewController];
    [self presentViewController:navigationController animated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
     
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark ReadJsonFromLocal
-(void)readJsonFomLocal
{
  //  NSString *filePath =[[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];//For Flight
   // NSString *filePath =[[NSBundle mainBundle] pathForResource:@"hotel" ofType:@"json"];
    // NSString *filePath =[[NSBundle mainBundle] pathForResource:@"Hotel_Flight" ofType:@"json"];
    
    NSString *filePath =[[NSBundle mainBundle] pathForResource:@"Error" ofType:@"json"];
    
     NSLog(@"value of filePath=%@",filePath);
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
    NSError *error = nil;
    NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if(error)
    {
        NSLog(@"Error=%@",error.description);
    }
    NSLog(@"Value of Json object:-%@", jsonDict);
    [LiveData getInstance].bookingConfirmationDictionary=jsonDict;
    
}


#pragma mark scrollViewSetUp
-(void)setScrollView
{
    screenWidth=self.view.frame.size.width;
    screenHeight=self.view.frame.size.height;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    float yy=0.0;
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,screenWidth,screenHeight)];
    [self.view addSubview:scrollView];
    NSDictionary *dictionary=[LiveData getInstance].bookingConfirmationDictionary;
    NSArray *responseArray=[dictionary valueForKey:@"response"];
     for(NSDictionary *dictionary in responseArray)
     {
         NSDictionary *responseDict=[dictionary objectForKey:@"response"];
         int tbc=[[dictionary objectForKey:@"tbc"]intValue];
         if(tbc!=7)
         {
             NSString *message=[responseDict objectForKey:@"message"];
             [self showAlertViewWithTitle:@"Alert" Message:message delegate:nil];
         }
         else
         {
              NSDictionary *responseValue=[responseDict objectForKey:@"value"];
              int metatype=[[responseDict objectForKey:@"metatype"]intValue];
              BookingConfirmationCell *confirmationCell=[[BookingConfirmationCell alloc]initWithFrame:CGRectMake(0,yy,320,100)];
             confirmationCell.responseDictionary=responseValue;
             if(metatype==2)//Hotel
             {
                 [confirmationCell configureBookingHotelCell];
             }
             else if(metatype==1) //Flight
             {
                 [confirmationCell configureBookingFlightCell];
             }
     
             [scrollView addSubview:confirmationCell];
              yy+=confirmationCell.frame.size.height;
              LineView *lineView=[[LineView alloc]initWithFrame:CGRectMake(0,yy,screenWidth,4)];
             [lineView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f]];
             [scrollView addSubview:lineView];
              yy+=lineView.frame.size.height;
         }
     }
    
    scrollView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [scrollView setContentSize:CGSizeMake(320, yy)];
    
    
//    for(NSDictionary *dictionary in responseArray)
//    {
//        NSDictionary *responseDict=[dictionary objectForKey:@"response"];
//        NSDictionary *responseValue=[responseDict objectForKey:@"value"];
//        int metatype=[[responseDict objectForKey:@"metatype"]intValue];
//        BookingConfirmationCell *confirmationCell=[[BookingConfirmationCell alloc]initWithFrame:CGRectMake(0,yy,320,100)];
//        confirmationCell.responseDictionary=responseValue;
//        if(metatype==2)//Hotel
//        {
//            [confirmationCell configureBookingHotelCell];
//        }
//        else if(metatype==1) //Flight
//        {
//            [confirmationCell configureBookingFlightCell];
//        }
//       
//        [scrollView addSubview:confirmationCell];
//         yy+=confirmationCell.frame.size.height;
//         LineView *lineView=[[LineView alloc]initWithFrame:CGRectMake(0,yy,screenWidth,4)];
//        [lineView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f]];
//        [scrollView addSubview:lineView];
//         yy+=lineView.frame.size.height;
//    }
//    scrollView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    [scrollView setContentSize:CGSizeMake(320, yy)];
    
}

-(void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message delegate:(id)delegate
{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
   
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
