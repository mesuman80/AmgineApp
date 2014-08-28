//
//  UserLoginViewController.m
//  Amgine
//
//  Created by Amgine on 14/08/14.
//
//

#import "UserLoginViewController.h"
#import "ScreenInfo.h"
#import "Constants.h"
#import "Data.h"
#import "ProfileInfo.h"
#import "RegisterNewUserController.h"
#import "ViewController.h"
#import "RegisterNewUser.h"
#import "UrlConnection.h"
#import "IteratorViewController.h"

@interface UserLoginViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UrlConnectionDelegate,UIAlertViewDelegate>

@end

@implementation UserLoginViewController
{
    NSMutableArray *allFieldArray;
    NSMutableArray *errorFieldArray;
    UIScrollView *scrollView;
    UITextField *activeField;
    float screenWidth;
    float screenHeight;
    float yy;
    BOOL isSignIn;
    NSString *token;
    BOOL isAlertView;
    BOOL touchOnNewUser;
    
}
@synthesize iteratorViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

#pragma mark viewLifeCycleFunction
- (void)viewDidLoad
{
    [super viewDidLoad];
    isSignIn=NO;
     self.title=@"Login";
    [self initilizeView];
    [self drawUI];
     [self drawLoginButton];
    [self addGestureOnScreen];
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    touchOnNewUser=YES;
    isAlertView=NO;
    [self addNotification];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [scrollView setDelegate:nil];
    [self clearNotification];
}
#pragma mark DrawingFunction
-(void)initilizeView
{
    screenWidth=[ScreenInfo getScreenWidth];
    screenHeight=[ScreenInfo getScreenHeight];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    scrollView.scrollEnabled=YES;
    scrollView.showsHorizontalScrollIndicator=YES;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.pagingEnabled=NO;
    [self.view addSubview:scrollView];
}
-(void)drawUI
{
    yy=20.0f;
    int tagValue=0;
    allFieldArray=[[NSMutableArray alloc]init];
    errorFieldArray=[[NSMutableArray alloc]init];
    NSArray *labelArray=[[NSArray alloc]initWithObjects:@"Email",@"Password", nil];
    
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
        label.frame=CGRectMake(6,yy,120,40);
        
        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(0,0,320-100,32)];
        textField.center=CGPointMake(200, label.center.y);
        textField.tag=tagValue;
        textField.borderStyle=UITextBorderStyleRoundedRect;
        [textField setDelegate:self];
        [scrollView addSubview:textField];
        if(tagValue==1)
        {
            textField.secureTextEntry=YES;
        }
        else
        {
            textField.keyboardType=UIKeyboardTypeEmailAddress;
        }
        
        yy+=label.frame.size.height+4;
        tagValue++;
        NSLog(@"%f",yy);
        [allFieldArray addObject:textField];

    }
    [scrollView setContentSize:CGSizeMake(320, yy)];
    [self drawNewUserButton];
    
}

-(void)drawNewUserButton
{
  
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"New User" style:UIBarButtonItemStyleBordered target:self action:@selector(touchOnNewUSer:)];
}

-(void)drawLoginButton
{
    
     UIButton *newUser=[UIButton buttonWithType:UIButtonTypeCustom];
     newUser.frame=CGRectMake(220,yy+45,80,30);
     [newUser setTitle:@"SignIn" forState:UIControlStateNormal];
      [newUser addTarget:self action:@selector(touchOnLogin:) forControlEvents:UIControlEventTouchUpInside];
     [newUser setTitleColor:[[Data sharedData]buttonColor] forState:UIControlStateNormal];
      [self.view addSubview:newUser];
    //[newUser setBackgroundColor:[UIColor redColor]];
}
#pragma mark ButtonTouchFunction
-(void)touchOnNewUSer:(id)sender
{
    if(touchOnNewUser)
    {
       [self gotoRegisterAccountScreen:YES];
    }
  
}
-(void)gotoRegisterAccountScreen:(BOOL)isNewUser
{
    ViewController *viewController=[[self.navigationController childViewControllers]objectAtIndex:0];
    [self.navigationController popViewControllerAnimated:NO];
    
    RegisterNewUserController *registerNewUserLoginViewController=[[RegisterNewUserController alloc]init];
    registerNewUserLoginViewController.isNewUser=isNewUser;
    if(iteratorViewController)
    {
        registerNewUserLoginViewController.iteratorViewController=iteratorViewController;
    }
    [viewController.navigationController pushViewController:registerNewUserLoginViewController animated:YES];
}
-(void)touchOnLogin:(id)sender
{
//    [self gotoNextScreen];
//    return;
    [self.view endEditing:YES];
   
    if(isSignIn)
    {
        return;
    }
    
    if([self validation]==-1)
    {
        [self setupConnection:[[allFieldArray objectAtIndex:0]text] withPassword:[[allFieldArray objectAtIndex:1]text] withType:@"Token"];
    }
    else
    {
        //[self showAlertViewWithTitle:[NSString stringWithFormat:@"Error!"] Message:[NSString stringWithFormat:@"Please Fill Information Correctly"]];
    }
}
-(void)saveDataInLocal:(NSString *)token1 withDictionary:(NSDictionary *)dictionary
{
    [[Data sharedData]userSaveInLocal:[[allFieldArray objectAtIndex:0]text] password:[[allFieldArray objectAtIndex:1]text] FirstName:[dictionary objectForKey:@"firstname"] token:token1];
    [[Data sharedData]saveAccountWithPassword:[[allFieldArray objectAtIndex:1]text] withServerDictionary:dictionary];
     [Data sharedData].isUserLogin=YES;

}
-(void)gotoNextScreen
{
   if(iteratorViewController)
   {
       
       [self.navigationController popViewControllerAnimated:NO];
       [iteratorViewController gotoPassengerInfoScreen];
   }
   else
   {
      [self gotoRegisterAccountScreen:NO];
   }
    
//    RegisterNewUserController *registerNewUserController=[[RegisterNewUserController alloc]init];
//    
//    [self.navigationController pushViewController:registerNewUserController animated:YES];
    
//    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UINavigationController *navigationController=[storyboard instantiateViewControllerWithIdentifier:@"SettingViewCtrlNav"];
//    [self presentViewController:navigationController animated:YES completion:
//     ^{
//         [self.navigationController popViewControllerAnimated:NO];
//     }
//     ];

}
#pragma mark Validation and Error Genertaion code
-(int)validation
{
    int tagValue=-1;
    if(errorFieldArray.count>0)
    {
        for(UILabel *label in errorFieldArray)
        {
            [label removeFromSuperview];
        }
        [errorFieldArray removeAllObjects];
    }
    for(UITextField *textField in allFieldArray)
    {
        NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
        NSLog(@"tag value=%i",textField.tag);
        if ([[textField.text stringByTrimmingCharactersInSet: set] length] == 0)
        {
            [textField setText:nil];
            [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
             tagValue=textField.tag;
            
            
             break;
        }
        else if (textField.tag==0)
        {
            if(![[Data sharedData]NSStringIsValidEmail:textField.text])
            {
                 NSLog(@"FAIL");
                [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                
                tagValue=textField.tag;
                break;
                
            }
            else
            {


            }
        }
    }
    if(tagValue>=0)
    {
        [self showError:tagValue];
    }
    
return tagValue;
}
-(void)showError:(int)ErrorNumber
{
    if(ErrorNumber==0)
    {
        [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Valid Email" Delegate:self];
    }
    else if(ErrorNumber==1)
    {
         [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Password" Delegate:self];
    }
}

-(UILabel*)addErrorField:(CGPoint)center withtag:(int)tag
{
    UILabel *errorSign=[[UILabel alloc]initWithFrame:CGRectMake(0, 200, 5, 20)];
    errorSign.textColor=[UIColor redColor];
    errorSign.text=@"!";
    [errorSign setAlpha:0.0f];
    [scrollView addSubview:errorSign];
    [errorSign setAlpha:1.0f];
    errorSign.center=center;
    errorSign.tag=tag;
    [errorFieldArray addObject:errorSign];
    return errorSign;
}
-(void)removeErrorSign:(UITextField *)textField
{
    if(errorFieldArray.count>0)
    {
        for(UILabel *label in errorFieldArray)
        {
            if(label.tag==textField.tag)
            {
                [label removeFromSuperview];
                [errorFieldArray removeObject:label];
                
                break;
            }
        }
        
    }
    
}
#pragma mark AlertViewSpecificFunction
-(void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate
{
    if(!isAlertView)
    {
        isAlertView=YES;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    isAlertView=NO;
}
#pragma mark TextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Text field did begin editing tag=%i",textField.tag);
    activeField = textField;
    [self removeErrorSign:textField];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"Text field ended editing");
    activeField =nil;
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@" "])
    {
       // [self showAlertViewWithTitle:@"Alert" Message:@"Please don't use space" Delegate:self];
        return NO;
    }
   return YES;
}
#pragma mark ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  [self.view endEditing:YES];
}

#pragma mark KeyBoard Specific Function
-(void)clearNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    
}
-(void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark KeyBoard Notification
-(void) keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(40.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}
-(void) keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets=UIEdgeInsetsMake(40.0, 0.0,0.0, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    NSLog(@"Live=%f",self.view.frame.size.height/2.0f);
}

#pragma mark view Gesture
-(void)addGestureOnScreen
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
};
#pragma mark UrlConnectionDelegate
-(void)setupConnection:(NSString *)userName withPassword:(NSString *)password withType:(NSString *)type
{
     touchOnNewUser=NO;
    UrlConnection *connection=[[UrlConnection alloc]init];
    [connection setDelegate:self];
     [connection setServiceName:AmgineLoginUser];
    [connection createNewUserType:type withKey:[NSString stringWithFormat:@"grant_type=password&username=%@&password=%@",userName,password]];
    [self showLoaderView:YES withText:@"Loading"];
     self.navigationItem.hidesBackButton = YES;
    isSignIn=YES;
}
-(void)fetchUserInfo
{
    UrlConnection *connection=[[UrlConnection alloc]init];
    [connection setDelegate:self];
    [connection setServiceName:AmgineFetchUserProfileInfo];
     NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:[[allFieldArray objectAtIndex:0]text] forKey:@"email"];
    [connection postData:dictionary searchType:@"UserProfile/PostProfileByUserName"];
}
-(void)connectionDidFinishLoadingData:(NSData *)data withService:(UrlConnection *)connection
{
     id dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    if([dictionary isKindOfClass:[NSArray class]]||[dictionary isKindOfClass:[NSMutableArray class]])
    {
        dictionary=(NSMutableArray *)dictionary;
    }
    else if([dictionary isKindOfClass:[NSDictionary class]]||[dictionary isKindOfClass:[NSMutableDictionary class]])
    {
        dictionary=(NSDictionary *)dictionary;
    }

    if ([connection.serviceName isEqualToString:AmgineLoginUser])
    {

         NSString *messsageStr=[dictionary objectForKey:@"message"];
         NSString *errorMessage=[dictionary valueForKey:@"error_description"];
          NSLog(@"value of dictionary=%@",dictionary);
        
        if(messsageStr)
        {
            self.navigationItem.hidesBackButton = NO;
            isSignIn=NO;
            touchOnNewUser=YES;
            [self showLoaderView:NO withText:nil];
            [self showAlertViewWithTitle:@"Error!" Message:messsageStr Delegate:self];
        }
        else if (errorMessage)
        {
            self.navigationItem.hidesBackButton = NO;
            isSignIn=NO;
            touchOnNewUser=YES;
            [self showLoaderView:NO withText:nil];
            [self showAlertViewWithTitle:[dictionary valueForKey:@"error"] Message:errorMessage Delegate:self];
        }
        else
        {
             NSString *access_Token=[dictionary valueForKey:@"access_token"];
             token=access_Token;
          //  [self saveRegisterUser:access_Token];
            [self fetchUserInfo];;
           // [self gotoNextScreen];
        }
    }
    else if ([connection.serviceName isEqualToString:AmgineFetchUserProfileInfo])
    {
         NSLog(@"value of data=%@",dictionary);
         self.navigationItem.hidesBackButton = NO;
         [self showLoaderView:NO withText:nil];
         isSignIn=NO;
        
        [self saveDataInLocal:token withDictionary:dictionary];
        //[self.navigationController popToRootViewControllerAnimated:YES];
         [self gotoNextScreen];
        touchOnNewUser=YES;
        
    }
    
}
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    
    isSignIn=NO;
   
    self.navigationItem.hidesBackButton = NO;
    [self showAlertViewWithTitle:@"Error!" Message:errorMessage Delegate:self];
     [self showLoaderView:NO withText:nil];
     touchOnNewUser=YES;
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




#pragma mark memoryWarning
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
