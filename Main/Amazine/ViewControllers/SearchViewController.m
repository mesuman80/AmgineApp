//
//  SearchViewController.m
//  Amazine
//
//  Created by Amgine on 11/06/14.
//  Copyright (c) 2014 Amgine. All rights reserved.
//

#import "SearchViewController.h"
#import "ScreenInfo.h"
#import "Data.h"
#import "UrlConnection.h"
#import "IteratorViewController.h"
#import "Passenger.h"
#import "Constants.h"
#import "Flightleg.h"
#import "TipView.h"
#import "UserLoginViewController.h"

@interface SearchViewController ()<UrlConnectionDelegate>
@end

@implementation SearchViewController
{
    float screenWidth;
    float screenHeight;
    UrlConnection *connection;
    UIScrollView *tipsScrollView;
    BOOL pageControlBeingUsed;
    UIPageControl *pageControl;
    int no_of_pages;
    NSMutableArray *tipViewStorage;
    float factor;
    
}

@synthesize textView,searchButton;
@synthesize scrollView;
@synthesize searchingString;
@synthesize  searchType;


#pragma mark ViewLifeCycleMethods
- (void)viewDidLoad
{
    [super viewDidLoad];
    factor=self.view.frame.size.height/568.0f;
    tipViewStorage=[[NSMutableArray alloc]init];
    pageControlBeingUsed=NO;
    screenWidth=[ScreenInfo getScreenWidth];
    screenHeight=[ScreenInfo getScreenHeight];
    [[Data sharedData]addBorderToTextView:textView];
    [[Data sharedData]addBorderToButton:searchButton];
    textView.returnKeyType = UIReturnKeyDone;
    [textView setDelegate:self];
    [self setTitle:@"Search"];
    
    scrollView.autoresizesSubviews=YES;
    scrollView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight;
    
    
    [self.view layoutIfNeeded];
    [scrollView setContentSize:CGSizeMake(0,searchButton.frame.origin.y+searchButton.frame.size.height)];
    [scrollView setContentOffset:CGPointMake(0, scrollView.center.y-(90/factor))];
    NSLog(@"%f*****",scrollView.contentSize.height);
    [scrollView setDelegate:nil];
    [self tipSetup];
    
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [textView setText:textView.text];
     [connection setDelegate:nil];
     [connection stopConnection:connection.urlConnection];
      connection=nil;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // [textView setText:[Data sharedData].searchString];
     pageControlBeingUsed=NO;
     connection=nil;
}
#pragma mark Button Action
-(IBAction)search:(id)sender
{
   
     [textView endEditing:YES];
    
     NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    if([[textView.text stringByTrimmingCharactersInSet:set] length] == 0)
    {
        [self notValidSearch];
    }
    else
    {
        // [self setupConnection:textView.text searchType:@"Search" isIndicatorNeed:YES];
       [self setupConnection:@"Roy from new york to san francisco on 10 nov for two days" searchType:@"Search" isIndicatorNeed:YES];
//         return;
        
           
            // [self authenticate];
            //[self setupConnection:textView.text searchType:@"Search" isIndicatorNeed:YES];
             // [self setupConnection:@"Roy and Matthew from toronto to seattle for 3 days" searchType:@"Search" isIndicatorNeed:YES];
            // [self setupConnection:@"Roy and Matthew from toronto to seattle" searchType:@"Search" isIndicatorNeed:YES];
            // [self readJsonFomLocal];
            
            // [self setupConnection:@"Roy from new york to san francisco on 10 Dec for two days" searchType:@"Search" isIndicatorNeed:YES];
    }

    
}


-(void)readJsonFomLocal
{
    NSString *filePath =[[NSBundle mainBundle] pathForResource:@"amgine" ofType:@"json"];
    NSLog(@"value of filePath=%@",filePath);
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
    NSError *error = nil;
    NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"Value of Json object:-%@", jsonDict);
    if(error)
    {
        NSLog(@"Error->>>>%@",error);
        [self showAlertMessage:error.localizedDescription withTitle:@"Error!"];
        return;
    }
    NSArray *response=[jsonDict objectForKey:@"response"];
    [[Data sharedData]saveSolutionEntity:[jsonDict objectForKey:@"solutionid"] withResponse:response];
    [self gotoNextScreen:[jsonDict objectForKey:@"solutionid"]];
}
-(void)setupConnection:(NSString *)searchString searchType:(NSString *)type isIndicatorNeed:(BOOL)isIndicator
{
      connection=[[UrlConnection alloc]init];
     [connection setDelegate:self];
     [connection setServiceName:@"Find-Query"];
     NSDictionary *dictionary=@{@"query":searchString
                               };
    [connection postData:dictionary searchType:type];
    if(isIndicator)
    {
        [self showLoaderView:YES withText:@"Loading"];
    }
    
}
#pragma mark UrlConnectionDelegate
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    NSLog(@"Error->>>>>>%@",errorMessage);
    [self showLoaderView:NO withText:nil];
    [self showAlertMessage:errorMessage withTitle:@"Error!"];
}

-(void)connectionDidFinishLoadingData:(NSData *)myData withService:(UrlConnection *)connection
{
    //NSJSONReadingAllowFragments
    NSDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"Value of Search Dictionary=%@",dictionary);
    
    
    if(dictionary.count<=0)
    {
      [self notValidSearch];
        return;
    }
    
    
    NSString *solution_id=[dictionary objectForKey:@"solutionid"];
    NSArray *response=[dictionary objectForKey:@"response"];
    NSArray *components = [solution_id componentsSeparatedByString:@"-"];
    NSString *str=[components objectAtIndex:0];
    NSDictionary *responseDictionary=[response objectAtIndex:0];
    NSArray *responseArray=[responseDictionary objectForKey:@"response"];
    if([str isEqualToString:@"00000000"] || !components || responseArray.count==0)
    {
        [self notValidSearch];
         return;
    }
    
    [[Data sharedData]saveSolutionEntity:solution_id withResponse:response];
    //[textView setText:nil];
     [self showLoaderView:NO withText:nil];
    [self gotoNextScreen:solution_id];

}
-(void)notValidSearch
{
    [self showLoaderView:NO withText:nil];
    [self showAlertMessage:@"Not a Valid Search" withTitle:@"Error!"];
}
-(void)gotoNextScreen:(NSString *)solutionId
{
    IteratorViewController *iteratorViewController = [[IteratorViewController alloc]init];
    iteratorViewController.solutionid=solutionId;
    [self.navigationController pushViewController:iteratorViewController animated:YES];
}


#pragma mark AlertView
- (void)showAlertMessage:(NSString *)message withTitle:(NSString *)title
{
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:title
                                                       message:message
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [alertView show];
}

#pragma mark LoaderViewDelegate
-(void)showLoaderView:(BOOL)show withText:(NSString *)text
{
    static UILabel *label;
    static UIActivityIndicatorView *activity;
    static UIView *loaderView;
    
    if(show)
    {
        
        loaderView=[[UIView alloc] initWithFrame:self.view.bounds];
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
        [self.view addSubview:loaderView];
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


#pragma mark UIText View Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
   // NSLog(@"Did Begin Editing");
}
- (BOOL)textView:(UITextView *)textView1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView1 resignFirstResponder];
    }
    return YES;
}

#pragma mark Tips Setup
-(void)tipSetup
{
    NSString *text=@"Tips:";
    UILabel *label=[[UILabel alloc]init];
    [label setBackgroundColor:[UIColor clearColor]];
    label.text=text;
    label.font=[UIFont fontWithName:AmgineFont size:18.0*factor];
     CGSize labelValueSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:AmgineFont size:18.0*factor]}];
    label.frame=CGRectMake(2,307*factor,labelValueSize.width,labelValueSize.height);
    [self.view addSubview:label];
    [self scrollViewForTips];
   

}

-(void)scrollViewForTips
{
    tipsScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,335*factor,screenWidth ,100)];
    [tipsScrollView setDelegate:self];
    [tipsScrollView setScrollEnabled:YES];
    [tipsScrollView setPagingEnabled:YES];
   [tipsScrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:tipsScrollView];
    [self addCustomViewToScroll]; 
    
}

-(void)addCustomViewToScroll
{
    int xx=0;
    for(int i=0;i<3;i++)
    {
        TipView *tipView=[[TipView alloc]initWithFrame:CGRectMake(5,2,screenWidth-10 ,96)];
        tipView.center=CGPointMake(screenWidth/2+xx,49);
        tipView.tag=i;
        xx+=screenWidth;
       [tipView addtips:@"Dummy Text"];
      //  [tipView setBackgroundColor:[UIColor redColor]];
       [tipsScrollView addSubview:tipView];
        [tipViewStorage addObject:tipView];
    }
    [tipsScrollView setContentSize:CGSizeMake(xx, 100)];
    
    no_of_pages =tipViewStorage.count;
    
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((screenWidth)/2, (screenHeight)*.80,(screenWidth)*.010,(screenHeight)*.015)];
     pageControl.currentPage=0;
    pageControl.numberOfPages=no_of_pages;
    pageControl.pageIndicatorTintColor=[UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0f];
    [pageControl setCurrentPageIndicatorTintColor:[[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:1]];
    [self.view addSubview:pageControl];
    
}


#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
	if (!pageControlBeingUsed)
    {
        CGFloat pageWidth = tipsScrollView.frame.size.width;
		int page = floor((tipsScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
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
