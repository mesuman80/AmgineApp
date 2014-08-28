//
//  PassportInfoViewController.m
//  Amgine
//
//  Created by Amgine on 13/08/14.
//   .
//

#import "PassportInfoViewController.h"
#import "ScreenInfo.h"
#import "Constants.h"
#import "DropDownListView.h"
#import "UrlConnection.h"
#import "DatePickerView.h"
#import "Data.h"
#import "ProfileInfo.h"
#import "ProfilePassportInfo.h"

#define ACCEPTABLE_CHARACTERS @"0123456789"
#define PassportIssue @"passportissue"
#define PassportExpire @"passportExpire"

@interface PassportInfoViewController ()<kDropDownListViewDelegate,UrlConnectionDelegate,DatePickerViewDelegate>

@end

@implementation PassportInfoViewController

{
     UIScrollView *scrollView;
    
     UITextField *activeField;
     UITextField *CountryField;
    
     NSMutableArray *allTextFieldArray;
     NSMutableArray *errorFieldArray;
     NSMutableArray *dropDownListViewArray;
     NSMutableArray *parentViewArray;
    
     NSString *countryCode;
     BOOL isTouchOnCountryTextField;
    
    float screenWidth;
    float screenHeight;
    
   // DatePickerView *datePickerView;
    NSDate *SelectedDate;
   
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"Passport Info"];
    [self initilizeView];
    [self scrollViewSetup];
    [self drawUI];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addKeyBoardNotification];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [scrollView setDelegate:nil];
    [self resignFirstResponder];
    [self clearDropDownObject];
    [self clearKeyBoardNotification];
}
#pragma mark InitilizeView
-(void)initilizeView
{
    screenWidth=[ScreenInfo getScreenWidth];
    screenHeight=[ScreenInfo getScreenHeight];
    
    dropDownListViewArray=[[NSMutableArray alloc]init];
    parentViewArray=[[NSMutableArray alloc]init];
    
    UIBarButtonItem  *doneButton=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(touchOnDoneButton:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
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
    NSMutableArray *labelArray=[[NSMutableArray alloc]initWithObjects:@"Country",@"Passport Number",@"Date of issues",@"Expire Date",nil];
    
    
   // mandatoryFieldArray=[[NSMutableArray alloc]init];
    errorFieldArray=[[NSMutableArray alloc]init];
    allTextFieldArray=[[NSMutableArray alloc]init];
    
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
        
        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(0,0,320-100,32)];
        textField.center=CGPointMake(200, label.center.y);
        textField.tag=tagValue;
        textField.borderStyle=UITextBorderStyleRoundedRect;
        [textField setDelegate:self];
        [scrollView addSubview:textField];
        
        yy+=frame.size.height+32;
         if (tagValue==0)
        {
            [textField setUserInteractionEnabled:YES];
            [textField setDelegate:nil];
            textField.userInteractionEnabled = YES;
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOnTextField:)];
            [recognizer setNumberOfTapsRequired:1];
            recognizer.delegate= self;
            [textField addGestureRecognizer:recognizer];
            
        }
        else if (tagValue==1)
        {
            textField.keyboardType=UIKeyboardTypeNumberPad;
        }
        
        [allTextFieldArray addObject:textField];
        tagValue++;
        NSLog(@"%f",yy);
    }
    [scrollView setContentSize:CGSizeMake(320, yy)];
    [self setUpTextField];
    
    
    
}
#pragma mark CustomViewDelegate
-(void)customViewSetup:(NSArray *)country_Data textField:(UITextField *)textField objectType:(NSString *)objectType title:(NSString *)title withSize:(CGSize)size
{
    //287, 280
    
    [self resignFirstResponder];
    [self clearDropDownObject];
    
    UIView *parentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    parentView.alpha=0.2;
    
    [self.view addSubview:parentView];
    UITapGestureRecognizer *gestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchOnParentView:)];
    gestureRecognizer.numberOfTapsRequired=1;
    [parentView addGestureRecognizer:gestureRecognizer];
    [parentViewArray addObject:parentView];
    
    
    DropDownListView *dropDownListView=[[DropDownListView alloc]initWithTitle:title options:country_Data xy:CGPointMake(16, 150) size:size isMultiple:NO];
    dropDownListView.delegate=self;
    [dropDownListView SetBackGroundDropDwon_R:240 G:240 B:240 alpha:0.80];
    dropDownListView.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    dropDownListView.alpha=1.0f;
    dropDownListView.textField=textField;
    dropDownListView.objectType=objectType;
    
    [dropDownListView SetBackGroundDropDwon_R:240 G:240 B:240 alpha:0.80];
    [self.view addSubview:dropDownListView];
    [dropDownListViewArray addObject:dropDownListView];
    
    
}
-(void)touchOnParentView:(id)sender
{
    [self clearDropDownObject];
}
-(void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex
{
    id type=[dropdownListView._kDropDownOption objectAtIndex:anIndex];
    
    UITextField *textField=dropdownListView.textField;
    [textField endEditing:YES];
    if([type isKindOfClass:[NSString class]])
    {
        textField.text=[dropdownListView._kDropDownOption objectAtIndex:anIndex];
    }
    else if([dropdownListView.objectType isEqualToString:AmgineCountryCode])
    {
        NSDictionary *dictionary=[dropdownListView._kDropDownOption objectAtIndex:anIndex];
        [textField setText:[dictionary objectForKey:@"name"]];
        countryCode=[dictionary objectForKey:@"code"];
    }
    [self clearDropDownObject];
}
-(void)DropDownListViewDidCancel:(DropDownListView *)dropdownListView
{
    [self clearDropDownObject];
}
//@"Country",@"Passport Number",@"Date of issues",@"Expire Date"
#pragma mark Fill TextField From LocalData
-(void)setUpTextField
{
    ProfileInfo *profileInfo=[Data sharedData].userLoginProfileInfo;
    ProfilePassportInfo *passportProfile=profileInfo.relationProfilePassportInfo;
    if(passportProfile)
    {
        for(UITextField *textField in allTextFieldArray)
        {
            switch (textField.tag)
            {
                case 0:
                    textField.text=passportProfile.country;
                    countryCode=passportProfile.country_Code;
                break;
                    
                case 1:
                    textField.text=passportProfile.passportNumber;
                break;
                    
                case 2:
                    textField.text=passportProfile.date_Of_issue;
                break;
                    
                case 3:
                    textField.text=passportProfile.expire_date;
                break;
                    
            }
        }
    }
}


#pragma mark Validation,Error Generation and Alert View Generation
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

-(void)touchOnDoneButton:(id)sender
{
    [self saveDataToLocal];
    [self resignFirstResponder];
    [self clearDropDownObject];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.view endEditing:YES];
}

-(void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}
-(void)saveDataToLocal
{
    ProfileInfo *profileInfo=[Data sharedData].userLoginProfileInfo;
    ProfilePassportInfo *passportInfo=profileInfo.relationProfilePassportInfo;
    if(passportInfo==nil)
    {
        passportInfo=[NSEntityDescription insertNewObjectForEntityForName:AmgineProfilePassportInfo inManagedObjectContext:[[Data sharedData]getContext]];
    }
    for(UITextField *textField in allTextFieldArray)
    {
        switch (textField.tag)
        {
            case 0:
                passportInfo.country=textField.text;
                passportInfo.country_Code=countryCode;
            break;
                
            case 1:
                passportInfo.passportNumber=textField.text;
            break;
                
            case 2:
                passportInfo.date_Of_issue=textField.text;
            break;
                
            case 3:
                passportInfo.expire_date=textField.text;
            break;
                
        }
    }
    profileInfo.relationProfilePassportInfo=passportInfo;
    [[Data sharedData]writeToDisk];
    [Data sharedData].userLoginProfileInfo=profileInfo;
    
}

#pragma mark TextField Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Text field did begin editing tag=%i",textField.tag);
    activeField = textField;
    [self removeErrorSign:textField];
    [self clearDropDownObject];
    if(textField.tag==2)//Date of issue
    {
        NSDictionary *dictionary=@{@"maxYear":@"0",
                                   @"month":@"0",
                                   @"day":@"-1",
                                   @"minYear":@"-10"
                                   };
        
        [self openDatePicker:textField withObjectType:PassportExpire dataDictionary:dictionary];
        
    }
    else if (textField.tag==3)//Date of Expire
    {
         NSDictionary *dictionary=@{@"maxYear":@"10",
                                    @"month":@"0",
                                    @"day":@"1",
                                    @"minYear":@"0"
                                    };
        
        [self openDatePicker:textField withObjectType:PassportExpire dataDictionary:dictionary];
    }
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSLog(@"Text field Should Return tag=%i",textField.tag);
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag==1)
    {
        if([string isEqualToString:@" "])
        {
            return NO;
        }
        else
        {
            NSLog(@"TextField.Text=%@",textField.text);
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            return [string isEqualToString:filtered];
        }
    }
    else if (textField.tag==2 || textField.tag==3)
    {
        return NO;
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField.inputView removeFromSuperview];
    activeField =nil;
}

#pragma mark UrlConectionDelegate
-(void)openUrl:(NSString *)stringUrl textField:(UITextField *)textField objectType:(NSString *)objectType

{
    if([objectType isEqualToString:AmgineCountryCode])
    {
        CountryField=textField;
    }
    
    UrlConnection *connection=[[UrlConnection alloc]init];
    connection.delegate=self;
    connection.serviceName=objectType;
    connection.activity= [self showActivityIndicator:textField];
    [connection openUrl:stringUrl];
    
}
-(void)connectionDidFinishLoadingData:(NSData *)data withService:(UrlConnection *)connection
{
    
    NSMutableArray *JsonData=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if([connection.serviceName isEqualToString:AmgineCountryCode])
    {
        [self removeActivityIndicator:connection];
        JsonData=[[[Data sharedData]sortArray:JsonData keyValue:@"name"]mutableCopy];
        NSMutableArray *countryArray=[[NSMutableArray alloc]init];
        for(NSDictionary *dictionary in JsonData)
        {
            if([[dictionary objectForKey:@"name"] isEqualToString:@"Canada"])
            {
                [countryArray addObject:dictionary];
            }
            else if ([[dictionary objectForKey:@"name"] isEqualToString:@"UnitedStates"])
            {
                [countryArray addObject:dictionary];
            }
            if(countryArray.count==2)
            {
                break;
            }
        }
        
        for(NSDictionary *dictionary in countryArray)
        {
            [JsonData removeObject:dictionary];
            [JsonData insertObject:dictionary atIndex:0];
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:JsonData forKey:@"countryData"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSLog(@"****************value of Dictionary****************:%@",JsonData);
        [self customViewSetup:JsonData textField:CountryField objectType:AmgineCountryCode title:@"Country" withSize:CGSizeMake(287,420)];
        isTouchOnCountryTextField=NO;
        
    }
    
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    //[passport setEnabled:YES];
    
    [self removeActivityIndicator:connection];
    [self showAlertViewWithTitle:@"Error!" Message:errorMessage];
    if([connection.serviceName isEqualToString:AmgineCountryCode])
    {
        isTouchOnCountryTextField=NO;
    }
}
#pragma mark DatePicker Delegate
-(void)openDatePicker:(UITextField *)textField withObjectType:(NSString *)objectType dataDictionary:(NSDictionary *)dictionary
{
       DatePickerView *datePickerView=[[DatePickerView alloc]initWithFrame:CGRectMake(0,screenHeight*.60,320,screenHeight*.40f)];
        datePickerView.objectType=objectType;
        NSMutableDictionary *dateDictionary=[[NSMutableDictionary alloc]init];
        [dateDictionary setValue:[dictionary objectForKey:@"maxYear"] forKey:@"maxYear"];
        [dateDictionary setValue:[dictionary objectForKey:@"month"] forKey:@"month"];
        [dateDictionary setValue:[dictionary objectForKey:@"day"] forKey:@"day"];
        [dateDictionary setValue:[dictionary objectForKey:@"minYear"] forKey:@"minYear"];
       // [dateDictionary setValue:@"-20" forKey:@"setDate"];
        datePickerView.dictionary=dateDictionary;
        datePickerView.delegate=self;
        [datePickerView drawDatePicker];
    
    datePickerView.textField=textField;
    textField.inputView=datePickerView;
    
}

-(void)returnFromDatePickerView:(NSString *)string textField:(UITextField *)textField fromView:(UIView *)view
{
    [textField endEditing:YES];
    DatePickerView *datePicker=(DatePickerView *)view;
    [textField.inputView removeFromSuperview];
    if([datePicker.objectType isEqualToString:PassportExpire])
    {
        
    }
    else if ([datePicker.objectType isEqualToString:PassportIssue])
    {
        
    }
}

#pragma mark activity Indicator Specific Function
-(UIActivityIndicatorView *)showActivityIndicator:(UITextField *)textField
{
    UIActivityIndicatorView * activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.center=CGPointMake(textField.center.x,16);
    [textField addSubview:activity];
    [activity startAnimating];
    return activity;
}

-(void)removeActivityIndicator:(UrlConnection *)connection
{
    [connection.activity stopAnimating];
    [connection.activity removeFromSuperview];
}

#pragma mark TextFieldGestureDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)touchOnTextField:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
    UITextField *textField=(UITextField *)sender.view;
    [self removeErrorSign:textField];
    activeField = textField;
     if(textField.tag==0)//Country
    {
        [self resignFirstResponder];
        if(isTouchOnCountryTextField)
        {
            return;
        }
        NSArray *countryArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"countryData"];
        if(countryArray)
        {
            [self resignFirstResponder];
            [self customViewSetup:countryArray textField:textField objectType:AmgineCountryCode title:@"Country" withSize:CGSizeMake(287,420)];
        }
        else
        {
            isTouchOnCountryTextField=YES;
            CountryField=textField;
            [self openUrl:[NSString stringWithFormat:@"%@/%@",AmgineAccessUrl,@"static/AllCountries"] textField:textField objectType:AmgineCountryCode];
        }
        
        
    }
   activeField = nil;
}


#pragma mark KeyBoard Specific Function
-(void)addKeyBoardNotification
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

-(void)clearKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    
}

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
-(void)clearDropDownObject
{
    if(dropDownListViewArray.count>0)
    {
        [[dropDownListViewArray lastObject]removeFromSuperview];
        // isKeyBoardUp=NO;
    }
    [dropDownListViewArray removeAllObjects];
    if(parentViewArray.count>0)
    {
        [[parentViewArray lastObject]removeFromSuperview];
    }
    [parentViewArray removeAllObjects];
}


#pragma mark Memory Warnings
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
