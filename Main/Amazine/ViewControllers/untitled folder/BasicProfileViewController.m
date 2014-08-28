//
//  BasicProfileViewController.m
//  Amgine
//
//  Created by Amgine on 13/08/14.
//   .
//

#import "BasicProfileViewController.h"
#import "ScreenInfo.h"
#import "Constants.h"
#import "DropDownListView.h"
#import "UrlConnection.h"
#import "DatePickerView.h"
#import "Data.h"
#import "ProfileInfo.h"
#import "BasicProfile.h"

#define ACCEPTABLE_CHARACTERS @"0123456789"
@interface BasicProfileViewController ()<kDropDownListViewDelegate,UrlConnectionDelegate,DatePickerViewDelegate>

@end

@implementation BasicProfileViewController
{
    UIScrollView *scrollView;
    
    UITextField *activeField;
    UITextField *CountryField;;
    UITextField *provinceTextField;
    
    NSMutableArray *mandatoryFieldArray;
    NSMutableArray *allTextFieldArray;
    NSMutableArray *errorFieldArray;
    
    NSMutableArray *dropDownListViewArray;
    NSMutableArray *parentViewArray;
    
    NSString *countryCode;
    NSString *provinceCode;
    
    
    BOOL isTouchOnCountryTextField;
    BOOL isTouchOnProvinceTextField;
    
    float screenWidth;
    float screenHeight;
    
    DatePickerView *datePickerView;
    NSDate *SelectedDate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

#pragma mark ViewLifeCycleFunction
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"Basic Profile"];
    // Do any additional setup after loading the view.
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
    [self resignFirstResponder];
    [self clearDropDownObject];
    [self clearKeyBoardNotification];
    [scrollView setDelegate:nil];
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
    NSMutableArray *labelArray=[[NSMutableArray alloc]initWithObjects:@"First Name",@"Last Name",@"Middle Name",@"Date Of Birth",@"Gender",@"Address1",@"Address2",@"City",@"ZipCode",@"Country",@"state",@"Phone",@"Email",@"Income Range",@"Martial Status",@"Children",@"Average # of Business Trips per year",@"Average # of Leisure Trips per year",@"How far in advanced do you book travel",@"Are you more price of time sensitive",nil];
    
    
    mandatoryFieldArray=[[NSMutableArray alloc]init];
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
        if(tagValue<13)//These are mendatory Field
        {
            
            [mandatoryFieldArray addObject:textField];
            
        }
        if(tagValue==11 ||tagValue==16 || tagValue==17 || tagValue==18)
        {
            textField.keyboardType=UIKeyboardTypeDecimalPad;
        }
        
        else if (tagValue==13|| tagValue==14 || tagValue==15|| tagValue==19|| tagValue==4 ||tagValue==10 ||tagValue==9)
        {
            [textField setUserInteractionEnabled:YES];
            [textField setDelegate:nil];
            textField.userInteractionEnabled = YES;
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOnTextField:)];
            [recognizer setNumberOfTapsRequired:1];
            recognizer.delegate= self;
            [textField addGestureRecognizer:recognizer];
            
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
    else if([dropdownListView.objectType isEqualToString:AmgineProvinceCode])
    {
        NSDictionary *dictionary=[dropdownListView._kDropDownOption objectAtIndex:anIndex];
        [textField setText:[dictionary objectForKey:@"provincename"]];
        provinceCode=[dictionary objectForKey:@"provincecode"];
    }

    [self clearDropDownObject];
}
-(void)DropDownListViewDidCancel:(DropDownListView *)dropdownListView
{
     [self clearDropDownObject];
}
#pragma mark Fill TextField From LocalData
-(void)setUpTextField
{
    ProfileInfo *profileInfo=[Data sharedData].userLoginProfileInfo;
    BasicProfile *basicProfile=profileInfo.relationBasicProfile;
    if(basicProfile)
    {
       for(UITextField *textField in allTextFieldArray)
       {
           switch (textField.tag)
           {
               case 0:
                   textField.text=basicProfile.firstName;
               break;
                
               case 1:
                     textField.text=basicProfile.lastName;
               break;
                   
               case 2:
                    textField.text=basicProfile.middleName;
                break;
                   
               case 3:
                    textField.text=basicProfile.date_of_Birth;
               break;
                   
               case 4:
                   textField.text=basicProfile.gender;
               break;
                   
               case 5:
                   textField.text=basicProfile.address1;
               break;
                   
               case 6:
                   textField.text=basicProfile.address2;
               break;
                   
               case 7:
                    textField.text=basicProfile.city;
               break;
                   
               case 8:
                     textField.text=basicProfile.zipCode;
                break;
                   
               case 10:
                    textField.text=basicProfile.state;
                    provinceCode=basicProfile.provinceCode;
                break;
                   
               case 9:
                   textField.text=basicProfile.country;
                   countryCode=basicProfile.countryCode;
               break;
   
              case 11:
                   textField.text=basicProfile.phone;
                break;
                   
               case 12:
                   textField.text=basicProfile.email;
                break;
                   
               case 13:
                    textField.text=basicProfile.incomeRange;
                break;
                   
               case 14:
                    textField.text=basicProfile.maritalStatus;
                break;
                   
               case 15:
                   textField.text=basicProfile.children;
                break;
                   
               case 16:
                   textField.text=basicProfile.bussinessTripPerYear;
                break;
                   
               case 17:
                    textField.text=basicProfile.leisureTripPerYear;
                break;
                   
               case 18:
                   textField.text=basicProfile.far_in_advance_book_Travel;
                break;
                   
               case 19:
                   textField.text=basicProfile.more_price_of_time_sensitive;
               break;
           }
       }
    }
}

#pragma mark Validation,Error Generation and Alert View Generation

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
    
    for(UITextField *textField in mandatoryFieldArray)
    {
        NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
        NSLog(@"tag value=%i",textField.tag);
        if ([[textField.text stringByTrimmingCharactersInSet: set] length] == 0)
        {
            [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
            tagValue=textField.tag;
            [textField setText:nil];
        }
        else if (textField.tag==12)
        {
            if([[Data sharedData]NSStringIsValidEmail:textField.text])
            {
                NSLog(@"SUCCESS");
                
            }
            else
            {
                NSLog(@"FAIL");
                [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                tagValue=textField.tag;
            }
        }
        else if (textField.tag==8)
        {
            if([countryCode isEqualToString:@"CA"]||[countryCode isEqualToString:@"US"])
            {
                if(![[Data sharedData]postalZipValidation:countryCode withPostalZipCode:textField.text])
                {
                    [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                    tagValue=textField.tag;
                }
                
            }
            else
            {
                NSLog(@"Success");
            }
        }
    }

    return tagValue;
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
    [self resignFirstResponder];
    [self clearDropDownObject];
    int comingValue=[self validation];
    [self.view endEditing:YES];
    if(comingValue==-1)
    {
        NSLog(@"success");
        [self saveDataToLocal];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    else
    {
        [self showAlertViewWithTitle:[NSString stringWithFormat:@"Error!"] Message:[NSString stringWithFormat:@"Please Fill Information Correctly"]];
    }
}
-(void)saveDataToLocal
{
    ProfileInfo *profileInfo=[Data sharedData].userLoginProfileInfo;
    BasicProfile *basicProfile=profileInfo.relationBasicProfile;
    if(basicProfile==nil)
    {
        basicProfile=[NSEntityDescription insertNewObjectForEntityForName:AmgineBasicProfileInfo inManagedObjectContext:[[Data sharedData]getContext]];
    }
    for(UITextField *textField in allTextFieldArray)
    {
        switch (textField.tag)
        {
            case 0:
                basicProfile.firstName=textField.text;
            break;
                
            case 1:
                basicProfile.lastName=textField.text;
            break;
                
            case 2:
                basicProfile.middleName=textField.text;
            break;
                
            case 3:
                basicProfile.date_of_Birth=textField.text;
            break;
                
            case 4:
                basicProfile.gender=textField.text;
            break;
                
            case 5:
                basicProfile.address1= textField.text;
            break;
                
            case 6:
                basicProfile.address2= textField.text;
            break;
                
            case 7:
                basicProfile.city=textField.text;
            break;
                
            case 8:
                basicProfile.zipCode=textField.text;
            break;
                
            case 10:
                basicProfile.state=textField.text;
                basicProfile.provinceCode= provinceCode;
            break;
                
            case 9:
                basicProfile.country=textField.text;
                basicProfile.countryCode=countryCode;
            break;
                
            case 11:
                basicProfile.phone=textField.text;
            break;
                
            case 12:
                basicProfile.email=textField.text;
            break;
                
            case 13:
                basicProfile.incomeRange=textField.text;
            break;
                
            case 14:
                basicProfile.maritalStatus=textField.text;
            break;
                
            case 15:
                basicProfile.children=textField.text;
            break;
                
            case 16:
                basicProfile.bussinessTripPerYear=textField.text;
            break;
                
            case 17:
                basicProfile.leisureTripPerYear=textField.text;
            break;
                
            case 18:
                basicProfile.far_in_advance_book_Travel=textField.text;
            break;
                
            case 19:
                basicProfile.more_price_of_time_sensitive=textField.text;
            break;
        }
    }
     profileInfo.relationBasicProfile=basicProfile;
     [[Data sharedData]writeToDisk];
     [Data sharedData].userLoginProfileInfo=profileInfo;

}
-(void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark TextField Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Text field did begin editing tag=%i",textField.tag);
    activeField = textField;
    [self removeErrorSign:textField];
    [self clearDropDownObject];
    if(textField.tag==3)
    {
        [self openDatePicker:textField];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag==11)
    {
        if(range.location>9 && textField.text.length>9)
        {
            return NO;
        }
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
    else if (textField.tag==12)
    {
        if([string isEqualToString:@" "])
        {
            return NO;
        }
    }

    else if (textField.tag==16 || textField.tag==17 || textField.tag==18)
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
    else if (textField.tag==3)
    {
        return NO;
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField =nil;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSLog(@"Text field Should Return tag=%i",textField.tag);
    return YES;
}

#pragma mark UrlConectionDelegate
-(void)openUrl:(NSString *)stringUrl textField:(UITextField *)textField objectType:(NSString *)objectType

{
    if([objectType isEqualToString:AmgineCountryCode])
    {
        CountryField=textField;
    }
    else if([objectType isEqualToString:AmgineProvinceCode])
    {
         provinceTextField=textField;
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
    else if([connection.serviceName isEqualToString:AmgineProvinceCode])
    {
        NSLog(@"value of data=%@",JsonData);
        [self removeActivityIndicator:connection];
        JsonData=[[[Data sharedData]sortArray:JsonData keyValue:@"provincename"]mutableCopy];
        NSArray *filterArray=[[Data sharedData]getprovincAcctoCountryCode:countryCode withArray:JsonData];
        
        [[NSUserDefaults standardUserDefaults]setObject:JsonData forKey:@"provinceData"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        if(filterArray.count>0)
        {
            [self customViewSetup:filterArray textField:provinceTextField objectType:AmgineProvinceCode title:@"Province Code" withSize:CGSizeMake(287, 420)];
        }
        else
        {
            [self customViewSetup:JsonData textField:provinceTextField objectType:AmgineProvinceCode title:@"Province Code" withSize:CGSizeMake(287, 420)];
        }
        
        isTouchOnProvinceTextField=NO;
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
    else if ([connection.serviceName isEqualToString:AmgineProvinceCode])
    {
        isTouchOnProvinceTextField=NO;
    }
    
}


#pragma mark DatePicker Delegate
-(void)openDatePicker:(UITextField *)textField
{
    if(!datePickerView)
    {
        datePickerView=[[DatePickerView alloc]initWithFrame:CGRectMake(0,screenHeight*.60,320,screenHeight*.40f)];
        NSMutableDictionary *dateDictionary=[[NSMutableDictionary alloc]init];
        [dateDictionary setValue:@"-20" forKey:@"maxYear"];
        [dateDictionary setValue:@"0" forKey:@"month"];
        [dateDictionary setValue:@"-1" forKey:@"day"];
        [dateDictionary setValue:@"-100" forKey:@"minYear"];
        [dateDictionary setValue:@"-20" forKey:@"setDate"];
        datePickerView.dictionary=dateDictionary;
        datePickerView.delegate=self;
        [datePickerView drawDatePicker];
    }
    datePickerView.textField=textField;
    textField.inputView=datePickerView;
    
}

-(void)returnFromDatePickerView:(NSString *)string textField:(UITextField *)textField fromView:(UIView *)view
{
    [textField endEditing:YES];
    if(string)
    {
        DatePickerView *datePicker=(DatePickerView *)view;
        SelectedDate=datePicker.datePicker.date;
    }
    else
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
    if(textField.tag==4)//Gender
    {
        [self resignFirstResponder];
        [self customViewSetup:[[NSArray alloc]initWithObjects:@"Male",@"Female", nil] textField:textField objectType:nil title:@"Gender" withSize:CGSizeMake(287, 280)];
    }
    else if(textField.tag==9)//Country
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
    else if (textField.tag==10)//Province
    {
        UITextField *countryTextField=[allTextFieldArray objectAtIndex:9];
        NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
        if ([[countryTextField.text stringByTrimmingCharactersInSet: set] length] == 0)
        {
            return;
        }
        else if(!isTouchOnProvinceTextField)
        {
            NSArray *provinceArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"provinceData"];
            if(provinceArray)
            {
                NSArray *filterArray=[[Data sharedData]getprovincAcctoCountryCode:countryCode withArray:provinceArray];
                if(filterArray.count>0)
                {
                    [self customViewSetup:filterArray textField:textField objectType:AmgineProvinceCode title:@"Province" withSize:CGSizeMake(287, 420)];
                }
                else
                {
                    [self customViewSetup:provinceArray textField:textField objectType:AmgineProvinceCode title:@"Province" withSize:CGSizeMake(287, 420)];
                }
                
            }
            else
            {
                [self resignFirstResponder];
                isTouchOnProvinceTextField=YES;
                [self openUrl:[NSString stringWithFormat:@"%@/%@",AmgineAccessUrl,@"static/AllProvinces"] textField:textField objectType:AmgineProvinceCode];
            }
        }
    }
    else if (textField.tag==13)
    {
        [self resignFirstResponder];
        [self customViewSetup:[[NSArray alloc]initWithObjects:@"10000-20000$",@"210000-30000$",@"31000-40000$",@"41000-50000$",@"51000-60000$",@"61000-70000$",@"71000-80000$",@"81000-90000$",@"91000-100000$",@">100000$", nil] textField:textField objectType:nil title:@"Income Range" withSize:CGSizeMake(287, 280)];
    }
    else if (textField.tag==14)//Martial Status
    {
        [self resignFirstResponder];
        [self customViewSetup:[[NSArray alloc]initWithObjects:@"Married",@"UnMarried", nil] textField:textField objectType:nil title:@"MartialStatus" withSize:CGSizeMake(287, 280)];
    }
    else if (textField.tag==15)//Children
    {
        [self resignFirstResponder];
        [self customViewSetup:[[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5", nil] textField:textField objectType:nil title:@"Children" withSize:CGSizeMake(287, 280)];
    }
    else if(textField.tag==19)//Are you more price of time sensitive
    {
        [self resignFirstResponder];
        [self customViewSetup:[[NSArray alloc]initWithObjects:@"Yes",@"No", nil] textField:textField objectType:nil title:@"ConFirmation" withSize:CGSizeMake(287, 280)];
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
