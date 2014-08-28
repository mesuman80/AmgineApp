//
//  RegisterNewUserController.m
//  Amgine
//
//    on 16/08/14.

//

#import "RegisterNewUserController.h"
#import "Constants.h"
#import "ScreenInfo.h"
#import "Data.h"
#import "RegisterNewUser.h"
#import "ProfileInfo.h"
//#import "UserLoginViewController.h"
#import "ViewController.h"
#import "UrlConnection.h"
#import "DatePickerView.h"
#import "DropDownListView.h"
#import "CreateAccountInfo.h"
#import "IteratorViewController.h"

#define AmgineNewUserRegister @"RegisterUser"

#define ACCEPTABLE_CHARACTERS @"0123456789"

@interface RegisterNewUserController ()<UrlConnectionDelegate,kDropDownListViewDelegate,DatePickerViewDelegate,UIAlertViewDelegate>

@end

@implementation RegisterNewUserController
{
    UIScrollView *scrollView;
    UITextField *activeField;
    
    NSMutableArray *allFieldArray;
    NSMutableArray *errorFieldArray;
    
    float screenWidth;
    float screenHeight;
    
    float yy;
    BOOL isUSerAccount;
    
    UITextField *CountryField;;
    UITextField *provinceTextField;
    
    NSString *countryCode;
    NSString *provinceCode;
    NSDate *SelectedDate;
    
    BOOL isTouchOnCountryTextField;
    BOOL isTouchOnProvinceTextField;
    NSMutableArray *dropDownListViewArray;
    NSMutableArray *parentViewArray;
    DatePickerView *datePickerView;
    NSMutableArray *mandatoryTextField;
    BOOL isAlertViewOnScreen;

}
@synthesize isNewUser;
@synthesize  iteratorViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

#pragma mark view LifeCycle Function
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initilizeView];
    [self drawButtonOnNavigationBar];
    [self drawUI];
    [self addGestureOnScreen];
    if(!isNewUser)
    {
        [self textFieldSetup];
    }
    else
    {
         self.title=@"CreateAccount";
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isAlertViewOnScreen=NO;
    [self addNotification];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self clearNotification];
    [scrollView setDelegate:nil];
}
-(void)textFieldSetup
{
    RegisterNewUser *registerNewUser=[[Data sharedData]getExistingUserInfo];
    CreateAccountInfo *existingUser=[[Data sharedData]checkUserAccountAgainstKey:registerNewUser.userName WithUserName:nil];
    self.title=@"UserProfile";
    if(existingUser)
    {
        [[allFieldArray objectAtIndex:0] setText:[registerNewUser userName]];
        [[allFieldArray objectAtIndex:0]setEnabled:NO];
        [[allFieldArray objectAtIndex:1]setText:[registerNewUser password]];
        [[allFieldArray objectAtIndex:1]setEnabled:NO];
        [[allFieldArray objectAtIndex:2]setText:registerNewUser.password];
        [[allFieldArray objectAtIndex:2]setEnabled:NO];
        [[allFieldArray objectAtIndex:3]setText:existingUser.title];
        [[allFieldArray objectAtIndex:4]setText:[existingUser firstName]];
        [[allFieldArray objectAtIndex:5]setText:[existingUser middleName]];
        [[allFieldArray objectAtIndex:6]setText:[existingUser lastName]];
        
        
        NSString *dateString=[[Data sharedData]getDateFormat:@"yyyy-MM-dd" withDateString:[existingUser d_o_b] dateFormat:@"MMM dd,yyyy"];
        [[allFieldArray objectAtIndex:7]setText:dateString];
        NSString *genderString=nil;
    
        NSLog(@"value of Existing user=%@",existingUser.gender);
        if([[existingUser gender]isEqualToString:@"M"])
        {
            genderString=@"Male";
        }
        else
        {
              genderString=@"Female";
        }
        [[allFieldArray objectAtIndex:8]setText:genderString];
        [[allFieldArray objectAtIndex:9]setText:[existingUser cellPhone]];
        [[allFieldArray objectAtIndex:10]setText:[existingUser homePhone]];
        [[allFieldArray objectAtIndex:11]setText:[existingUser address1]];
        [[allFieldArray objectAtIndex:12]setText:[existingUser address2]];
        [[allFieldArray objectAtIndex:13]setText:[existingUser postalCode]];
        [[allFieldArray objectAtIndex:14]setText:[existingUser city]];
        [[allFieldArray objectAtIndex:15]setText:[existingUser country]];
        countryCode=existingUser.countryCode;
        [[allFieldArray objectAtIndex:16]setText:[existingUser province]];
        provinceCode=existingUser.provinceCode;
        NSString *cardType=nil;
        if([existingUser.cctype isEqualToString:@"2"])
        {
            cardType=@"Visa";
        }
        else if([existingUser.cctype isEqualToString:@"3"])
        {
            cardType=@"MasterCard";
        }
        else
        {
            cardType=@"Amex";
        }

        [[allFieldArray objectAtIndex:17]setText:cardType];
        [[allFieldArray objectAtIndex:18]setText:[existingUser ccFirstName]];
        [[allFieldArray objectAtIndex:19]setText:[existingUser ccLastName]];

    }
    
    
    
}

#pragma mark InitilizeView
-(void)initilizeView
{
    dropDownListViewArray=[[NSMutableArray alloc]init];
    parentViewArray=[[NSMutableArray alloc]init];
    mandatoryTextField=[[NSMutableArray alloc]init];
    isUSerAccount=NO;
   
    screenWidth=[ScreenInfo getScreenWidth];
    screenHeight=[ScreenInfo getScreenHeight];
    errorFieldArray=[[NSMutableArray alloc]init];
    allFieldArray=[[NSMutableArray alloc]init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    scrollView.scrollEnabled=YES;
    scrollView.showsHorizontalScrollIndicator=YES;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.pagingEnabled=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
}
#pragma mark CustomViewDelegate
-(void)customViewSetup:(NSArray *)country_Data textField:(UITextField *)textField objectType:(NSString *)objectType title:(NSString *)title withSize:(CGSize)size
{
    //287, 280
    
    [self resignFirstResponder];
    [self clearDropDownObject];
    [scrollView endEditing:YES];
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
-(void)openDatePicker:(UITextField *)textField
{
    if(!datePickerView)
    {
        datePickerView=[[DatePickerView alloc]initWithFrame:CGRectMake(0,screenHeight*.60,320,screenHeight*.40f)];
        NSMutableDictionary *dateDictionary=[[NSMutableDictionary alloc]init];
        [dateDictionary setValue:@"-10" forKey:@"maxYear"];
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
    [dropdownListView.textField endEditing:YES];
    [self clearDropDownObject];
}

-(void)clearDropDownObject
{
    if(dropDownListViewArray.count>0)
    {
        [[dropDownListViewArray lastObject]removeFromSuperview];
    }
    [dropDownListViewArray removeAllObjects];
    if(parentViewArray.count>0)
    {
        [[parentViewArray lastObject]removeFromSuperview];
    }
    [parentViewArray removeAllObjects];
}


#pragma  mark navigationBar Button Setup
-(void)drawButtonOnNavigationBar
{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(touchOnDone:)];
    self.title=@"Create Account";
    
    
}
#pragma mark drawing Function
-(void)drawUI
{
    NSLog(@"draw UI");
     yy=20.0f;
    int tagValue=0;
    NSArray *labelArray=[[NSArray alloc]initWithObjects:@"Email",@"Password",@"Confirm Password",@"Title",@"FirstName",@"MiddleName",@"LastName",@"DOB",@"Gender",@"CellPhone",@"HomePhone",@"Address1",@"Address2",@"PostalCode",@"City",@"Country",@"Province",@"CCType",@"CC FirstName",@"CC LastName",nil];
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
        
        label.frame=CGRectMake(6,yy,frame.size.width,frame.size.height);
        
        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(0,0,320-100,32)];
        textField.center=CGPointMake(200, label.center.y);
        textField.tag=tagValue;
        textField.borderStyle=UITextBorderStyleRoundedRect;
        [textField setDelegate:self];
        [scrollView addSubview:textField];
        if(tagValue==0)
        {
            textField.keyboardType=UIKeyboardTypeEmailAddress;
        }
        if(tagValue==1 || tagValue==2)
        {
            textField.secureTextEntry=YES;
        }
        else if (tagValue==3||tagValue==8 || tagValue==15 || tagValue==16 || tagValue==17)
        {
            [textField setUserInteractionEnabled:YES];
            [textField setDelegate:nil];
            //CountryField=textField;
            textField.userInteractionEnabled = YES;
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOnTextField:)];
            [recognizer setNumberOfTapsRequired:1];
            recognizer.delegate= self;
            [textField addGestureRecognizer:recognizer];
        }
        if(tagValue==15)
        {
            [textField setText:@"Canada"];
             countryCode=@"CA";
        }
        yy+=frame.size.height+32;
        
        if(tagValue!=5 && tagValue!=9 && tagValue!=12)
        {
             NSLog(@"TagValue =%i",tagValue);
            [mandatoryTextField addObject:textField];
        }
        if(tagValue==9 || tagValue==10)
        {
            textField.keyboardType=UIKeyboardTypeNumberPad;
        }
        [allFieldArray addObject:textField];
        
       
            
        tagValue++;
       // NSLog(@"%f",yy);
       
        
    }
    [scrollView setContentSize:CGSizeMake(320, yy)];

}

#pragma mark Gesture handling Function
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(void)touchOnTextField:(UITapGestureRecognizer*)sender
{
    UITextField *textField=(UITextField *)sender.view;
    [self removeErrorSign:textField];
    activeField = textField;
    if(textField.tag==8) //Gender
    {
        [self resignFirstResponder];
        [self customViewSetup:[[NSArray alloc]initWithObjects:@"Male",@"Female", nil] textField:textField objectType:nil title:@"Gender" withSize:CGSizeMake(287, 280)];
    }
    else if(textField.tag==3)//Title
    {
        [self resignFirstResponder];
        [self customViewSetup:[[NSArray alloc]initWithObjects:@"Mr",@"Mrs",@"Miss", nil] textField:textField objectType:nil title:@"Title" withSize:CGSizeMake(287, 280)];
    }

    else if(textField.tag==15)//Country
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
    else if (textField.tag==16)//Province
    {
        UITextField *countryTextField=[allFieldArray objectAtIndex:15];
        NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
        NSLog(@"text value=%@",countryTextField.text);
        if ([[countryTextField.text stringByTrimmingCharactersInSet: set] length] == 0)
        {
            [self showAlertViewWithTitle:@"Alert" Message:@"Select Country First" delegate:self];
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
    else if (textField.tag==17)//CC Type
    {
        [self customViewSetup:[[NSArray alloc]initWithObjects:@"Visa",@"MasterCard",@"Amex", nil] textField:textField objectType:nil title:@"Card Type" withSize:CGSizeMake(287, 280)];
    }
}
#pragma mark button Touch handling Function
-(void)touchOnCancel:(id)sender
{
   [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)touchOnDone:(id)sender
{
    [self.view endEditing:YES];
    if(isUSerAccount)
    {
        return;
    }
    [self clearDropDownObject];
    if([self validation]==-1)
    {
        UITextField *password=[allFieldArray objectAtIndex:1];
        UITextField *confirmPassword=[allFieldArray objectAtIndex:2];
        if([password.text isEqualToString:confirmPassword.text])
        {
            NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
            [dictionary setValue:[[allFieldArray objectAtIndex:0]text] forKey:@"username"];
            [dictionary setValue:[[allFieldArray objectAtIndex:1]text] forKey:@"Password"];
            [dictionary setValue:[[allFieldArray objectAtIndex:2]text]forKey:@"ConfirmPassword"];
            [dictionary setValue:[[allFieldArray objectAtIndex:3]text]forKey:@"Title"];
            [dictionary setValue:[[allFieldArray objectAtIndex:4]text] forKey:@"FirstName"];
            [dictionary setValue:[[allFieldArray objectAtIndex:5]text] forKey:@"MiddleName"];
            [dictionary setValue:[[allFieldArray objectAtIndex:6]text] forKey:@"LastName"];
              UITextField *textField=[allFieldArray objectAtIndex:8];
            NSLog(@"Value of Gender=%@",textField.text);
            if([textField.text isEqualToString:@"Male"])
            {
                [dictionary setValue:@"M" forKey:@"Gender"];
            }
            else
            {
                [dictionary setValue:@"F" forKey:@"Gender"];
            }
            
            UITextField *dateTextField=[allFieldArray objectAtIndex:7];
            NSString *dateString=[[Data sharedData]getDateFormat:@"MMM dd,yyyy" withDateString:dateTextField.text dateFormat:@"yyyy/MM/dd"];
             NSLog(@"Value of dateTextField=%@ & date=%@",dateTextField.text,dateString);
            
            [dictionary setValue:dateString forKey:@"DOB"];
            [dictionary setValue:[[allFieldArray objectAtIndex:9]text] forKey:@"CellPhone"];
            [dictionary setValue:[[allFieldArray objectAtIndex:10]text] forKey:@"HomePhone"];
            [dictionary setValue:[[allFieldArray objectAtIndex:11]text] forKey:@"AddressLineOne"];
            [dictionary setValue:[[allFieldArray objectAtIndex:12]text] forKey:@"AddressLineTwo"];
            [dictionary setValue:[[allFieldArray objectAtIndex:13]text] forKey:@"PostalCode"];
            [dictionary setValue:[[allFieldArray objectAtIndex:14]text] forKey:@"City"];
            [dictionary setValue:countryCode forKey:@"Country"];
            [dictionary setValue:provinceCode forKey:@"Province"];
            NSString *cardType=nil;
            NSString *cardTypeStr=[[allFieldArray objectAtIndex:17]text];
            if([cardTypeStr isEqualToString:@"Visa"])
            {
                cardType=@"2";
            }
            else if([cardTypeStr isEqualToString:@"MasterCard"])
            {
                cardType=@"3";
            }
            else
            {
                cardType=@"1";
            }

            [dictionary setValue:cardType forKey:@"CCType"];
            [dictionary setValue:[[allFieldArray objectAtIndex:18]text] forKey:@"CCFirstName"];
            [dictionary setValue:[[allFieldArray objectAtIndex:19]text] forKey:@"CCLastName"];
            NSLog(@"value of Dictionary=%@",dictionary);
            
            
            [self setupServiceName:AmgineNewUserRegister withType:@"api/Account/Register" withDict:dictionary isIndicator:YES];
          
        }
        else
        {
            [self showAlertViewWithTitle:[NSString stringWithFormat:@"Error!"] Message:[NSString stringWithFormat:@"Passwords don't match.Please Try Again"]delegate:self];
        }
    }
    else
    {
        //[self showAlertViewWithTitle:[NSString stringWithFormat:@"Error!"] Message:[NSString stringWithFormat:@"Please Fill Information //Correctly"]];
    }
   
}
-(void)removeParentView
{
   

}

#pragma mark Validation Specific Function
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
    for(UITextField *textField in mandatoryTextField)
    {
        NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
        NSLog(@"tag value=%i",textField.tag);
        if ([[textField.text stringByTrimmingCharactersInSet: set] length] == 0 && textField.tag!=5)
        {
            //[textField setText:nil];
            [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
            tagValue=textField.tag;
            [self showAlertViewWithTitle:@"Alert" Message:@"You Can't leave this empty" delegate:self];
            break;
        }
        else if (textField.tag==0)
        {
            if(![[Data sharedData]NSStringIsValidEmail:textField.text])
            {
                [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                tagValue=textField.tag;
                [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Valid Email" delegate:self];
                break;
            }
        }
        else if (textField.tag==13)
        {
            if(![[Data sharedData]postalZipValidation:countryCode withPostalZipCode:textField.text])
            {
                [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                 tagValue=textField.tag;
                 [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Valid PostalCode" delegate:self];
                 break;
            }
        }
        else if (textField.tag==1)
        {
            if (textField.text.length<6)
            {
                [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                 tagValue=textField.tag;
                 [self showAlertViewWithTitle:@"Alert" Message:@"Password should have atleast six characters" delegate:self];
                 break;
            }

        }
        else if (textField.tag==4)
        {
            if(![[Data sharedData]nameValidation:textField.text])
            {
                [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                tagValue=textField.tag;
                [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Valid First Name" delegate:self];
                 break;
            }
        }
        else if (textField.tag ==5)
        {
            if(textField.text.length >0)
            {
                 if(![[Data sharedData]nameValidation:textField.text])
                 {
                     [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                     tagValue=textField.tag;
                     [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Valid Middle Name" delegate:self];
                     break;
 
                 }
            }
        }
        else if (textField.tag==6)
        {
            if(![[Data sharedData]nameValidation:textField.text])
            {
                [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                tagValue=textField.tag;
                [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Valid Last Name" delegate:self];
                break;
                
            }
        }

    }
//    if(tagValue==-1)
//    {
//        UITextField *genderField=[allFieldArray objectAtIndex:8];
//        NSString *genderText=genderField.text;
//        UITextField *titleField=[allFieldArray objectAtIndex:3];
//        NSString *titleText=titleField.text;
//        if([genderText isEqualToString:@"Male"])
//        {
//            
//        }
//        else
//        {
//            
//        }
//
//    }
//    
    
    return tagValue;
}


#pragma mark alertView Specific Function
-(void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message delegate:(id)delegate
{
    if(!isAlertViewOnScreen)
    {
        isAlertViewOnScreen=YES;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    isAlertViewOnScreen=NO;
}

#pragma mark TextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Text field did begin editing tag=%i",textField.tag);
    activeField = textField;
    [self removeErrorSign:textField];
    if (textField.tag==7)
    {
        [self openDatePicker:textField];
    }

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField endEditing:YES];
    NSLog(@"Text field ended editing");
    activeField =nil;
    [self clearDropDownObject];
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int tagValue=textField.tag;
    if(tagValue==0 || tagValue==1 || tagValue==2 || tagValue==17)
    {
        if([string isEqualToString:@" "])
        {
          // [self showAlertViewWithTitle:@"Alert" Message:@"Please don't use space" Delegate:self];
           // [self showAlertViewWithTitle:@"Alert" Message:@"Please don't use space" delegate:self];
             return NO;
        }
    }
    else if(tagValue==9 || tagValue==10)
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
            BOOL isSuccess=[string isEqualToString:filtered];
            if(!isSuccess)
            {
                [self showAlertViewWithTitle:@"Alert" Message:@"Allow Number" delegate:self];
            }
            return isSuccess;
        }

    }
    else if (tagValue==17)
    {
        if(range.location>1 && textField.text.length>1)
        {
            return NO;
            
        }
    }
    else if (tagValue==7)
    {
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
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
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(dismissKeyboard)];
//    
//    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}


#pragma mark saveDataInLocal
-(void)saveRegisterUser:(NSString *)access_Token
{
    [[Data sharedData]userSaveInLocal:[[allFieldArray objectAtIndex:0]text] password:[[allFieldArray objectAtIndex:1]text] FirstName:[[allFieldArray objectAtIndex:4]text] token:access_Token];
     [Data sharedData].isUserLogin=YES;
}
-(void)saveDataInLocal:(NSString *)password dict:(NSDictionary *)dict
{
   //[self save]
    
   // NSString *emailText=[[allFieldArray objectAtIndex:0]text];
//    ProfileInfo *profileInfo  =[[Data sharedData]getExistingProfileInfo:emailText];
//    if(!profileInfo)
//    {
//        profileInfo =[NSEntityDescription insertNewObjectForEntityForName:AmgineProfileInfo inManagedObjectContext:[[Data sharedData]getContext]];
//    }
//    profileInfo.email_Id=emailText;
//    [[Data sharedData]writeToDisk];
//    [Data sharedData].userLoginProfileInfo=profileInfo;
   
    [[Data sharedData]saveAccountWithPassword:password withServerDictionary:dict];
    
    
    
    
}
#pragma mark UrlConnectionDelegate
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

-(void)setupServiceName:(NSString *)serviceName withType:(NSString *)type withDict:(NSDictionary *)dict isIndicator:(BOOL)isIndicator
{
    self.navigationItem.hidesBackButton = YES;
    isUSerAccount=YES;
    UrlConnection *connection=[[UrlConnection alloc]init];
    [connection setDelegate:self];
    [connection setServiceName:AmgineNewUserRegister];
    [connection postData:dict searchType:type];
    
    if(isIndicator)
    {
      [self showLoaderView:YES withText:@"Loading"];
    }
   
}

-(void)loginName:(NSString *)userName withPassword:(NSString *)password withType:(NSString *)type
{
    UrlConnection *connection=[[UrlConnection alloc]init];
    [connection setDelegate:self];
    [connection setServiceName:AmgineLoginUser];
    [connection createNewUserType:type withKey:[NSString stringWithFormat:@"grant_type=password&username=%@&password=%@",userName,password]];
   // [self showLoaderView:YES withText:@"Loading"];
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
    id JsonData=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if([JsonData isKindOfClass:[NSArray class]]||[JsonData isKindOfClass:[NSMutableArray class]])
    {
        JsonData=(NSMutableArray *)JsonData;
    }
    else if([JsonData isKindOfClass:[NSDictionary class]]||[JsonData isKindOfClass:[NSMutableDictionary class]])
    {
        JsonData=(NSDictionary *)JsonData;
    }
     NSLog(@"value of data=%@",JsonData);
    if([connection.serviceName isEqualToString:AmgineNewUserRegister])
    {
       
       NSDictionary *errorDictionary=[JsonData objectForKey:@"modelstate"];
       if(errorDictionary)
       {
           isUSerAccount=NO;
           self.navigationItem.hidesBackButton = NO;
           [self showLoaderView:NO withText:nil];
           NSLog(@"value of Error Dictionary=%@",errorDictionary);
           NSArray *arr=[errorDictionary objectForKey:@""""];
           NSString *errorString=[arr objectAtIndex:0];
           [self showAlertViewWithTitle:@"Alert" Message:errorString delegate:self];
       }
        else
        {
            [self loginName:[[allFieldArray objectAtIndex:0]text] withPassword:[[allFieldArray objectAtIndex:1]text] withType:@"Token"];
        }

    }
    else if ([connection.serviceName isEqualToString:AmgineLoginUser])
    {
        NSLog(@"value of data=%@",JsonData);
        NSString *errorMessage=[JsonData valueForKey:@"message"];
        if(errorMessage)
        {
            self.navigationItem.hidesBackButton = NO;
            [self showLoaderView:NO withText:nil];
            isUSerAccount=NO;
            [self showAlertViewWithTitle:@"Alert" Message:errorMessage delegate:self];
        }
        else
        {
            NSString *access_Token=[JsonData valueForKey:@"access_token"];
            [self saveRegisterUser:access_Token];
            [self fetchUserInfo];
        }
        
    }
    else if ([connection.serviceName isEqualToString:AmgineFetchUserProfileInfo])
    {
         NSLog(@"value of data=%@",JsonData);
        self.navigationItem.hidesBackButton = NO;
        [self showLoaderView:NO withText:nil];
        isUSerAccount=NO;
        [self saveDataInLocal:[[allFieldArray objectAtIndex:1]text] dict:JsonData];
        [self nextScreenDraw];
       
    }
    else if([connection.serviceName isEqualToString:AmgineCountryCode])
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
     if([connection.serviceName isEqualToString:AmgineNewUserRegister] || [connection.serviceName isEqualToString:AmgineLoginUser] || [connection.serviceName isEqualToString:AmgineFetchUserProfileInfo])
     {
         isUSerAccount=NO;
         self.navigationItem.hidesBackButton = NO;
     }
    [self showAlertViewWithTitle:@"Error!" Message:errorMessage delegate:self];
    [self showLoaderView:NO withText:nil];
}
-(void)nextScreenDraw
{
    if(iteratorViewController)
    {
        
        [self.navigationController popViewControllerAnimated:NO];
        [iteratorViewController gotoPassengerInfoScreen];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
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


#pragma mark UIActivityIndicator function
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
