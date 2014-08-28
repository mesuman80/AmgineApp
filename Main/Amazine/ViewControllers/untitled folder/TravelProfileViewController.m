//
//  TravelProfileViewController.m
//  Amgine
//
//  Created by Amgine on 13/08/14.
//   .
//

#import "TravelProfileViewController.h"
#import "ScreenInfo.h"
#import "Constants.h"

@interface TravelProfileViewController ()<UIScrollViewDelegate>

@end

@implementation TravelProfileViewController
{
    UIScrollView *scrollView;
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

#pragma mark ViewLifeCycleFunction
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"Travel Profile"];
    [self initilizeView];
    [self scrollViewSetup];
    [self drawUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [scrollView setDelegate:nil];
}
#pragma mark InitilizeView
-(void)initilizeView
{
    screenWidth=[ScreenInfo getScreenWidth];
    screenHeight=[ScreenInfo getScreenHeight];
}
#pragma mark ScrollView SetupFnction
-(void)scrollViewSetup
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    scrollView.scrollEnabled=YES;
    scrollView.showsHorizontalScrollIndicator=YES;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.pagingEnabled=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
}
#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark DrawingFunction
-(void)drawUI
{
    float yy=20.0f;
    int tagValue=0;
    NSMutableArray *labelArray=[[NSMutableArray alloc]initWithObjects:@"Profile Name",@"Profile Type (Business / Leisure)",@"Traveling with (Significant other,Kids,etc)",@"Preferred Departure Time",@"Preferred Airline",@"Preferred AirCraft type",@"Preferred Seating",@"Class or service",@"Number of stops",@"Preferred Hotel Chain",@"Preferred Hotel Type",@"Preferred Car Chain",@"Preferred Car Type",@"Preferred Car Class",nil];
    
    for(NSString *str in labelArray)
    {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectZero];
        label.text=str;
        label.textColor=[UIColor blackColor];
        label.font=[UIFont fontWithName:AmgineFont size:14.0];
        label.adjustsFontSizeToFitWidth=NO;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=0;
        [scrollView addSubview:label];
        CGSize  textSize = {80, 10000.0};
        CGRect frame = [str boundingRectWithSize:textSize options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:14.0f]}
                                         context:nil];
        
        label.frame=CGRectMake(6,yy,75,frame.size.height);
        yy+=frame.size.height+32;
        tagValue++;
        NSLog(@"%f",yy);
    }
    [scrollView setContentSize:CGSizeMake(320, yy)];
    
    
    
}
#pragma mark Memory Warning
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
