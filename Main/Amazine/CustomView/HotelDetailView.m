//
//  HotelDetailView.m
//  Amgine
//
//  Created by Amgine on 23/06/14.
//   
//

#import "HotelDetailView.h"
#import "Hotel.h"
#import "ScreenInfo.h"
#import "Data.h"
#import "Constants.h"

@implementation HotelDetailView
{
    Hotel *hotelDetail;
    UIScrollView  *scrollView;
    UrlConnection *urlConnection;
    
    float screenHeight;
     float screenWidth;
    BOOL isImageTouch;
    UIView *hotelImageContainer;
}
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame withHotelView:(Hotel*)hotel
{
    self = [super initWithFrame:frame];
    if (self)
    {
        screenHeight=[ScreenInfo getScreenHeight];
        screenWidth=[ScreenInfo getScreenWidth];
        hotelDetail=(Hotel *)hotel;
        NSLog(@"hotel.cost=%@",hotelDetail.cost);
        [self drawHotelDetail:hotel];
        isImageTouch=NO;
        UISwipeGestureRecognizer *oneFingerSwipeLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(oneFingerSwipeLeft:)];
        [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:oneFingerSwipeLeft];
    }
    return self;
}

- (void)oneFingerSwipeLeft:(UITapGestureRecognizer *)recognizer
{
    
    [self.rootViewController.parentView setAlpha:1.0f];
    [self cleanDetailView];
    [UIView animateWithDuration:AmgineCellSwipeAnimationTime animations:^{
        self.center=CGPointMake(-screenWidth/2, self.center.y);
        self.rootViewController.parentView .center=CGPointMake(screenWidth/2, self.rootViewController.parentView.center.y);
    } completion:^(BOOL finished) {
                   [self viewDisappear];
           [self removeFromSuperview];
    }];

}


#pragma mark ScrollViewFunctions
-(void)scrollViewSetup
{
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,1, 320, self.frame.size.height)];
    scrollView.pagingEnabled=NO;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    [self addSubview:scrollView];
}
-(void)setScrollViewContentSize:(CGSize)size
{
    scrollView.contentSize=size;
}
#pragma mark DrawMethods
-(void)drawHotelDetail:(Hotel*)hotelData
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10,factor*94,215,30)];
    [label setText:hotelData.hotelname];
    label.font=[UIFont fontWithName:AmgineFont size:14.0*factor];
    [self addSubview:label];
    
    UILabel *costLabel=[[UILabel alloc]init];
    NSString *costString=[NSString stringWithFormat:@"$ %.02f",[[hotelData cost]floatValue]];
    costLabel.font=[UIFont fontWithName:AmgineFont size:14.0*factor];
    CGSize labelValueSize = [costString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:14.0*factor]}];
    costLabel.frame=CGRectMake(320-labelValueSize.width-10,factor*94, labelValueSize.width, 30);
    costLabel.text=costString;
    [self addSubview:costLabel];
    [self drawView];
    [self descriptionSetUp:[[Data sharedData]convertToString:hotelData.shortdescription]];
    
   
}


-(void)descriptionSetUp:(NSString *)descriptionText
{
    NSString *descriptionText1=@"Description:";
    UILabel *description=[[UILabel alloc]init];
    description.font=[UIFont fontWithName:AmgineFont size:16.0*factor];
    CGSize labelValueSize = [descriptionText1 sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:16.0*factor]}];
    description.frame=CGRectMake(6,factor*350, labelValueSize.width,labelValueSize.height);
    description.text=descriptionText1;
    [self addSubview:description];
    
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(8,factor*380,305,84)];
    [view setBackgroundColor:[UIColor clearColor]];
    [[Data sharedData]addBorderToUiView:view];
    [self addSubview:view];
    //[self.view sendSubviewToBack:vi]
    
    UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(0,-6,305,84)];
    textView.font=[UIFont fontWithName:AmgineFont size:15.0*factor];
    textView.text=descriptionText;
    textView.editable=NO;
    textView.selectable=NO;
    [view addSubview:textView];
    
    //[self performSelector:@selector(downLoadImage) withObject:self afterDelay:0.8f];
    
}
-(void)downLoadImage
{
     [self downloadImage:hotelDetail.image];
}


-(void)drawView
{
    hotelImageContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 145, 145)];
    hotelImageContainer.center=CGPointMake(160,factor*228);
    [[Data sharedData]addBorderToUiView:hotelImageContainer];
    [self addSubview:hotelImageContainer];
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
    if(!urlConnection)
    {
         urlConnection=[[UrlConnection alloc]init];
         [self showLoaderView:YES withText:@"Loading"];
    }
   
    [urlConnection setDelegate:self];
    [urlConnection setServiceName:@"Download-Image"];
    [urlConnection openUrl:url];
   
}

#pragma mark URL Delegate
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
  //  [self showLoaderView:NO withText:nil];
   // [self showAlertViewWithTitle:@"Error!" Message:error.localizedDescription delegate:nil];
   // isImageTouch=YES;
    [self downloadImage:hotelDetail.image];
    
}

-(void)connectionDidFinishLoadingData:(NSData *)myData withService:(UrlConnection *)connection
{
    [self showLoaderView:NO withText:nil];
    [self DrawImage:myData];
    
}
-(void)ConnectionSuccessFull:(NSDictionary *)dictionary
{
    
}
#pragma mark AlertDelegate
-(void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message delegate:(id)delegate1
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate1 cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
    CGPoint point=[[touches anyObject]locationInView:self];
    if(CGRectContainsPoint(hotelImageContainer.frame, point)&& isImageTouch)
    {
        [self downloadImage:hotelDetail.image];
    }
}

-(void)viewDisappear
{
    if(delegate)
    {
        [self.delegate hotelDetailViewDisappear];
    }
       
 
}
-(void)cleanDetailView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(downLoadImage) object:nil];
    [urlConnection setDelegate:nil];
    urlConnection=nil;
    isImageTouch=NO;
}
-(void)dealloc
{
    [urlConnection setDelegate:nil];
     urlConnection=nil;
    isImageTouch=NO;
}


@end
