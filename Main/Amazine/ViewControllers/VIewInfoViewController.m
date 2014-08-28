//
//  VIewInfoViewController.m
//  Amgine
//
//  Created by Amgine on 30/06/14.
//   
//

#import "VIewInfoViewController.h"
#import "ViewInfoVIew.h"
#import "TouchInfoViewController.h"

@interface VIewInfoViewController ()

@end

@implementation VIewInfoViewController
{
    UIScrollView *scrollView;
    NSMutableArray *customViewStorage;
    float screenWidth;
    float screenHeight;
}
@synthesize imageView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark ViewLifeCycle Function
- (void)viewDidLoad
{
    [super viewDidLoad];
    screenWidth=self.view.frame.size.width;
    screenHeight=self.view.frame.size.height;
    customViewStorage=[[NSMutableArray alloc]init];
    [self scrollViewSetup];
     [self viewSetup];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
 
}
#pragma mark ScrollViewFunctions
-(void)scrollViewSetup
{
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,screenHeight*.65f,screenWidth,screenHeight*.35f)];
    scrollView.pagingEnabled=NO;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
   // [scrollView setBackgroundColor:[UIColor redColor]];
    [scrollView setDelegate:self];
    [self.view addSubview:scrollView];
}

-(void)setScrollViewContentSize:(CGSize)size
{
    scrollView.contentSize=size;
}

#pragma drawing function
-(void)drawImage1:(UIImageView *)imageView1
{
    UIImageView *imageDraw=[[UIImageView alloc]initWithImage:imageView1.image];
    imageDraw.frame=imageView1.frame;
    imageDraw.center=CGPointMake(self.view.frame.size.width*.50f, self.view.frame.size.height*.38f);
    [self.view addSubview:imageDraw];
   
}
-(void)viewSetup
{
    int xx=2;
    for(int i=0 ;i<10;i++)
    {
        ViewInfoVIew *viewInfoView=[[ViewInfoVIew alloc]initWithFrame:CGRectMake(xx, 0, screenWidth*.33f, screenHeight*.347f)];
        viewInfoView.tag=i;
        [viewInfoView drawImage:@"hotelIcon.jpg"];
        [scrollView addSubview:viewInfoView];
        [viewInfoView setBackgroundColor:[UIColor colorWithRed:0 green:153/255.0f blue:204/255.0f alpha:1.0f]];
        xx+=viewInfoView.frame.size.width+2;
        [customViewStorage addObject:viewInfoView];
        
    }
    [self setScrollViewContentSize:CGSizeMake(xx,scrollView.frame.size.height)];
    UITapGestureRecognizer *infoImageTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(infoViewSelected:)];
    infoImageTap.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:infoImageTap];
}
#pragma mark navigation Touches
-(void)touchOnBackButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)infoViewSelected:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [(UITapGestureRecognizer*) recognizer locationInView:scrollView];
    for(ViewInfoVIew *item in customViewStorage)
    {
        if(CGRectContainsPoint(item.frame, point))
        {
            NSLog(@"value of item.tag=%i",item.tag);
            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TouchInfoViewController *viewCotrl=[storyBoard instantiateViewControllerWithIdentifier:@"TouchInfoView"];
            [self.navigationController pushViewController:viewCotrl animated:YES];
            
            break;
        }
    }
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
