//
//  HotelDetailViewController.m
//  Amgine
//
//  Created by Amgine on 23/06/14.
//   
//

#import "HotelDetailViewController.h"
#import "Constants.h"
#import "UrlConnection.h"
#import "Data.h"

@interface HotelDetailViewController ()<UrlConnectionDelegate,UIAlertViewDelegate>

@end

@implementation HotelDetailViewController
{
     UIScrollView  *scrollView;
     UrlConnection *urlConnection;
     float factor;
   
    BOOL isImageTouch;
    UIView *hotelImageContainer;
    
}
@synthesize hotel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark ViewLifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(touchOnBackButton:)];
    self.navigationItem.leftBarButtonItem=item;
    factor=self.view.frame.size.height/568.0f;
     [self drawHotelDetail:hotel];
    isImageTouch=NO;

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [urlConnection setDelegate:nil];
    isImageTouch=NO;
    
}

#pragma mark ScrollViewFunctions
-(void)scrollViewSetup
{
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,1, 320, self.view.frame.size.height)];
    scrollView.pagingEnabled=NO;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:scrollView];
}



-(void)setScrollViewContentSize:(CGSize)size
{
    scrollView.contentSize=size;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TouchOnBackButton
-(void)touchOnBackButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

#pragma mark DrawMethods
-(void)drawHotelDetail:(Hotel*)hotelData
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10,factor*48,215,30)];
    [label setText:hotelData.hotelname];
    label.font=[UIFont fontWithName:AmgineFont size:14.0*factor];
    [self.view addSubview:label];
    
    UILabel *costLabel=[[UILabel alloc]init];
    NSString *costString=[NSString stringWithFormat:@"$ %@",hotelData.cost];
    costLabel.font=[UIFont fontWithName:AmgineFont size:14.0*factor];
    CGSize labelValueSize = [costString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:14.0*factor]}];
    costLabel.frame=CGRectMake(320-labelValueSize.width-10,factor*48, labelValueSize.width, 30);
    costLabel.text=costString;
    [self.view addSubview:costLabel];
    [self drawView];
    [self descriptionSetUp:[[Data sharedData]convertToString:hotelData.shortdescription]];
    [self downloadImage:hotelData.image];
    
   
}

-(void)descriptionSetUp:(NSString *)descriptionText
{
    NSString *descriptionText1=@"Description:";
    UILabel *description=[[UILabel alloc]init];
     description.font=[UIFont fontWithName:AmgineFont size:16.0*factor];
    CGSize labelValueSize = [descriptionText1 sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:16.0*factor]}];
    description.frame=CGRectMake(6,factor*350, labelValueSize.width,labelValueSize.height);
   description.text=descriptionText1;
    [self.view addSubview:description];
    
 
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(8,factor*374,305,74)];
    [view setBackgroundColor:[UIColor clearColor]];
    [[Data sharedData]addBorderToUiView:view];
    [self.view addSubview:view];
    //[self.view sendSubviewToBack:vi]
    
     UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(0,-6,305,76)];
     textView.font=[UIFont fontWithName:AmgineFont size:15.0*factor];
     textView.text=descriptionText;
     textView.editable=NO;
     textView.selectable=NO;
     [view addSubview:textView];
    
}


-(void)drawView
{
    hotelImageContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 145, 145)];
    hotelImageContainer.center=CGPointMake(160,factor*180);
    [[Data sharedData]addBorderToUiView:hotelImageContainer];
    [self.view addSubview:hotelImageContainer];
}
-(void)DrawImage:(NSData *)imageData
{
    UIImageView *hotelImage=[[UIImageView alloc]initWithImage:[UIImage imageWithData:imageData]];
     hotelImage.frame=CGRectMake(0, 0, 145, 145);
    [hotelImageContainer addSubview:hotelImage];
    isImageTouch=NO;
    
}
-(void)downloadImage:(NSString *)url
{
     urlConnection=[[UrlConnection alloc]init];
    [urlConnection setDelegate:self];
    [urlConnection setServiceName:@"Download-Image"];
    [urlConnection openUrl:url];
    [self showLoaderView:YES withText:@"Loading"];
}

#pragma mark URL Delegate
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
     [self showLoaderView:NO withText:nil];
     [self showAlertViewWithTitle:@"Error!" Message:errorMessage delegate:nil];
      isImageTouch=YES;
}
-(void)ConnectionSuccess:(NSData *)data
{
    [self showLoaderView:NO withText:nil];
    [self DrawImage:data];
    
}
-(void)ConnectionSuccessFull:(NSDictionary *)dictionary
{
    
}
#pragma mark AlertDelegate
-(void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message delegate:(id)delegate
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

#pragma mark LoaderViewDelegate
-(void)showLoaderView:(BOOL)show withText:(NSString *)text
{
    static UILabel *label;
    static UIActivityIndicatorView *activity;
    static UIView *loaderView;
    
    if(show)
    {
        
        loaderView=[[UIView alloc] initWithFrame:hotelImageContainer.bounds];
        [loaderView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.4]];
        
        label=[[UILabel alloc] initWithFrame:CGRectMake(0, (loaderView.bounds.size.height/2)-10, loaderView.bounds.size.width, 20)];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [label setText:text];
        [label setTextAlignment:NSTextAlignmentCenter];
        [loaderView addSubview:label];
        
        activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        activity.center=CGPointMake(label.center.x, label.frame.origin.y+label.frame.size.height+10+activity.frame.size.height/2);
        
        [activity startAnimating];
        [loaderView addSubview:activity];
        [hotelImageContainer addSubview:loaderView];
    }else
    {
        
        [label removeFromSuperview];
        [activity removeFromSuperview];
        [loaderView removeFromSuperview];
        label=nil;
        activity=nil;
        loaderView=nil;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point=[[touches anyObject]locationInView:self.view];
    if(CGRectContainsPoint(hotelImageContainer.frame, point)&& isImageTouch)
    {
       [self downloadImage:hotel.image];
    }
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
