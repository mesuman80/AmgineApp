        
//  TravelerViewController.m
//  Amgine
//
//  Created by Amgine on 26/06/14.
//   
//

#import "TravelerViewController.h"
#import "Data.h"
#import "Constants.h"
#import "ContactData.h"
#import "Contacts.h"
#import "ScreenInfo.h"
//#import "CustomViewController.h"
#import "PassengerInfoCell.h"
#import "DatePickerView.h"
#import "LiveData.h"
#import "Passenger.h"
#import "DropDownListView.h"
#import "ContactData.h"
#import "RegisterNewUser.h"
#import "CreateAccountInfo.h"

#define ACCEPTABLE_CHARACTERS @"0123456789"


@interface TravelerViewController ()<kDropDownListViewDelegate,DatePickerViewDelegate,UIAlertViewDelegate>

@end

@implementation TravelerViewController
{
    NSMutableArray *saveTextFieldArray;
    NSMutableArray *editTextField;
     NSMutableArray *errorFieldArray;
    // UIActivityIndicatorView *activity;
    float screenWidth;
    float screenHeight;
  //  NSArray *countryData;
    UIScrollView *scrollView;
    UITextField *activeField;
    DatePickerView *datePickerView;
    UITextField *CountryField;;
    UITextField *provinceTextField;
    
    NSString *countryCode;
    NSString *provinceCode;
    NSDate *SelectedDate;
    
    BOOL isTouchOnCountryTextField;
    BOOL isTouchOnProvinceTextField;
    
    NSMutableArray *dropDownListViewArray;
    NSMutableArray *parentViewArray;
    
    BOOL isKeyBoardUp;
    float factor;
    BOOL isAlertVisible;
    
    
  //  NSString *editCountryText;
}


@synthesize passengerName;
@synthesize passengerInfoCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
#pragma mark View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    dropDownListViewArray=[[NSMutableArray alloc]init];
    parentViewArray=[[NSMutableArray alloc]init];
    //factor=screenHeight*568;
     self.title=@"PassengerInfo";
    [self initilize];
    [self drawUI];
    [self setupTextField];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
     isKeyBoardUp=NO;
    isAlertVisible=NO;
    [self addNotification];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
     isKeyBoardUp=NO;
    [self resignFirstResponder];
    [self clearDropDownObject];
    [self clearNotification];
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
    isKeyBoardUp=YES;
}
-(void) keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets=UIEdgeInsetsMake(40.0, 0.0,0.0, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    NSLog(@"Live=%f",self.view.frame.size.height/2.0f);
    isKeyBoardUp=NO;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    if (action == @selector(paste:))
    {
         NSLog(@"i am in paste action");
        return NO;
    }
    if (action == @selector(select:))
    {
        NSLog(@"i am in select action");
        return NO;
    }
    if (action == @selector(selectAll:))
    {
        NSLog(@"i am in selectAll action");
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

-(void)initilize
{
    screenWidth=[ScreenInfo getScreenWidth];
    screenHeight=[ScreenInfo getScreenHeight];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    scrollView.scrollEnabled=YES;
    scrollView.showsHorizontalScrollIndicator=YES;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.pagingEnabled=NO;
    //scrollView.bounces=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
   
}
-(void)dismissKeyboard:(id)sender
{
    if(isKeyBoardUp)
    {
        [self resignFirstResponder];
        [self clearDropDownObject];
    }
    
}
-(void)drawUI
{
     float yy=20.0f;
     int tagValue=0;
    
    NSMutableArray *labelArray=[[NSMutableArray alloc]initWithObjects:@"Title",@"First Name",@"Middle Name",@"Last Name",@"Gender",@"Phone Mobile",@"PhoneHome",@"Address",@"City",@"Country",@"province",@"Date of Birth:",@"Email",@"postal/Zip",@"Frequent Flyer Program:",@"Mileage Program #",@"Seat Preference",@"Special Requiremnts",@"Special Meal Requests",@"Select Insurance Provider",@"Select Package",nil];
    
    editTextField=[[NSMutableArray alloc]init];
    errorFieldArray=[[NSMutableArray alloc]init];
    saveTextFieldArray=[[NSMutableArray alloc]init];
    if([LiveData getInstance].isHotel)
    {
        [labelArray insertObject:@"Smoking" atIndex:14];
    }
    
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
        
        label.frame=CGRectMake(6,yy,80,frame.size.height);
    
        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(0,0,320-100,32)];
        textField.center=CGPointMake(200, label.center.y);
        textField.tag=tagValue;
        textField.borderStyle=UITextBorderStyleRoundedRect;
        [textField setDelegate:self];
        [scrollView addSubview:textField];
        
         yy+=frame.size.height+32;
        if(tagValue==12)
        {
            textField.keyboardType=UIKeyboardTypeEmailAddress;
        }
        if((tagValue>=0 && tagValue<2)||(tagValue>=3 && tagValue<5) ||(tagValue>5 && tagValue<=13))//These are mendatory Field
        {
    
            [editTextField addObject:textField];
            
        }
        else if (tagValue==14 && [LiveData getInstance].isHotel)
        {
            [editTextField addObject:textField];
        }
        if(tagValue==5 || tagValue==6)
        {
            textField.keyboardType=UIKeyboardTypeDecimalPad;
        }
        
        if(tagValue==14 && [LiveData getInstance].isHotel)
        {
           // NSLog(@"Country TextField");
            [textField setUserInteractionEnabled:YES];
            [textField setDelegate:nil];
           // CountryField=textField;
            textField.userInteractionEnabled = YES;
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOnTextField:)];
            [recognizer setNumberOfTapsRequired:1];
            recognizer.delegate= self;
            [textField addGestureRecognizer:recognizer];
            
        }
        else if (tagValue==0 || tagValue==4 || tagValue==9|| tagValue==10)
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
         //[textField
        if(tagValue==9)
        {
            [textField setText:@"Canada"];
            countryCode=@"CA";
        }

        [saveTextFieldArray addObject:textField];
        tagValue++;
         NSLog(@"%f",yy);
    }
    
    
    
    UIButton *resetButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [resetButton setFrame:CGRectMake(250,yy,60,30)];
    [resetButton setTitleColor:[Data sharedData].buttonColor forState:UIControlStateNormal];
    [resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetPassengerData:) forControlEvents:UIControlEventTouchUpInside];
    // [cancelButton setBackgroundColor:[UIColor redColor]];
    yy+=resetButton.frame.size.height;
    [scrollView addSubview:resetButton];

//    
//   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                  initWithTarget:self
//                                  action:@selector(dismissKeyboard:)];
//     tap.delegate= self;
//    tap.cancelsTouchesInView=NO;
//   
//   [scrollView addGestureRecognizer:tap];
    // scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    [scrollView setContentSize:CGSizeMake(320, yy)];
    
}
-(void)resetPassengerData:(id)sender
{
    ContactData *contactData =[self checkPassengerInfo:passengerName];
    if(contactData)
    {
        [[[Data sharedData]getContext]deleteObject:contactData];
        [[Data sharedData]writeToDisk];
    }
   
    for(UITextField *textField in saveTextFieldArray)
    {
        [textField setText:nil];
    }
    if(passengerInfoCell.is_Image)
    {
        [passengerInfoCell resetImage];
    }
}
-(ContactData *)checkPassengerInfo:(NSString *)name
{
    return[[Data sharedData]checkContactEntityExist:AmgineContactsData passengerName:name];
    
}
-(void)setUpLabel:(NSString *)str
{
    
}
-(void)setupTextField
{
    RegisterNewUser *registerNewUser=[[Data sharedData]getExistingUserInfo];
    CreateAccountInfo *existingUser=[[Data sharedData]checkUserAccountAgainstKey:registerNewUser.userName WithUserName:passengerName];
    if(existingUser)
    {
        for(UITextField *textField in saveTextFieldArray)
        {
            switch (textField.tag)
            {
                case 0:
                    textField.text=existingUser.title;
                    break;
                    
                case 1:
                    textField.text=existingUser.firstName;
                    break;
                    
                case 2:
                    textField.text=existingUser.middleName;
                    break;
                    
                case 3:
                    textField.text=existingUser.lastName;
                    break;
                    
                case 4:
                {
                    NSString *genderString=nil;
                    NSLog(@"value of existingUser.gender=%@",existingUser.gender);
                    if([existingUser.gender isEqualToString:@"M"])
                    {
                        genderString=@"Male";
                    }
                    else
                    {
                        genderString=@"Female";
                    }
                    textField.text=genderString;
                }
                    break;
                    
                case 5:
                    textField.text=existingUser.cellPhone;
                    break;
                    
                case 6:
                    textField.text=existingUser.homePhone;
                    break;
                    
                case 7:
                    textField.text=existingUser.address1;
                    break;
                    
                case 8:
                    textField.text=existingUser.city;
                    break;
                    
                case 10:
                    textField.text=existingUser.province;
                    provinceCode=existingUser.provinceCode;
                    break;
                    
                case 9:
                    textField.text=existingUser.country;
                    countryCode=existingUser.countryCode;
                    break;
                    
                case 11:
                {
                   NSString *dateString=[[Data sharedData]getDateFormat:@"yyyy-MM-dd" withDateString:[existingUser d_o_b] dateFormat:@"MMM dd,yyyy"];
                    
                    textField.text=dateString;
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    NSDate *date = [dateFormatter dateFromString:[existingUser d_o_b]];
                    SelectedDate=date;
              }
                    break;
                    
                case 12:
                    textField.text=existingUser.userName;
                    break;
                    
                case 13:
                    textField.text=existingUser.postalCode;
                    break;
                    
            }
        }

    }
    else
    {
        ContactData *contactData=[[Data sharedData]checkContactEntityExist:AmgineContactsData passengerName:passengerName];
        if(contactData)
        {
            Contacts *contacts=[contactData.contacts objectAtIndex:0];
            if(saveTextFieldArray.count==22)
            {
                for(UITextField *textField in saveTextFieldArray)
                {
                    switch (textField.tag)
                    {
                        case 0:
                            textField.text=contacts.title;
                            break;
                            
                        case 1:
                            textField.text=contacts.firstName;
                            break;
                            
                        case 2:
                            textField.text=contacts.middleName;
                            break;
                            
                        case 3:
                            textField.text=contacts.lastname;
                            break;
                            
                        case 4:
                            textField.text=contacts.gender;
                            break;
                            
                        case 5:
                            textField.text=contacts.phone_Mobile;
                            break;
                            
                        case 6:
                            textField.text=contacts.phone_Home;
                            break;
                            
                        case 7:
                            textField.text=contacts.address;
                            break;
                            
                        case 8:
                            textField.text=contacts.city;
                            break;
                            
                        case 10:
                            textField.text=contacts.state;
                            provinceCode=contacts.provinceCode;
                            break;
                            
                        case 9:
                            textField.text=contacts.country;
                            countryCode=contacts.country_Code;
                            break;
                            
                        case 11:
                            textField.text=contacts.date_of_birth;
                            SelectedDate=contacts.dob;
                            break;
                            
                        case 12:
                            textField.text=contacts.email;
                            break;
                            
                        case 13:
                            textField.text=contacts.postal_code;
                            break;
                            
                        case 14:
                            textField.text=contacts.is_Smoking;
                            break;
                            
                        case 15:
                            textField.text=contacts.frequent_flyer_program;
                            break;
                            
                        case 16:
                            textField.text=contacts.mileage_Program;
                            break;
                            
                        case 17:
                            textField.text=contacts.seat_preference;
                            break;
                            
                        case 18:
                            textField.text=contacts.special_Requirements;
                            break;
                            
                        case 19:
                            textField.text=contacts.special_Meal_Requests;
                            break;
                            
                        case 20:
                            textField.text=contacts.select_insurance_Provider;
                            break;
                            
                        case 21:
                            textField.text=contacts.select_Package;
                            break;
                    }
                }
            }
            else
            {
                for(UITextField *textField in saveTextFieldArray)
                {
                    switch (textField.tag)
                    {
                        case 0:
                            textField.text=contacts.title;
                            break;
                            
                        case 1:
                            textField.text=contacts.firstName;
                            break;
                            
                        case 2:
                            textField.text=contacts.middleName;
                            break;
                            
                        case 3:
                            textField.text=contacts.lastname;
                            break;
                            
                        case 4:
                            textField.text=contacts.gender;
                            break;
                            
                        case 5:
                            textField.text=contacts.phone_Mobile;
                            break;
                            
                        case 6:
                            textField.text=contacts.phone_Home;
                            break;
                            
                        case 7:
                            textField.text=contacts.address;
                            break;
                            
                        case 8:
                            textField.text=contacts.city;
                            break;
                            
                        case 10:
                            textField.text=contacts.state;
                            provinceCode=contacts.provinceCode;
                            break;
                            
                        case 9:
                            textField.text=contacts.country;
                            countryCode=contacts.country_Code;
                            break;
                            
                        case 11:
                            textField.text=contacts.date_of_birth;
                            SelectedDate=contacts.dob;
                            break;
                            
                        case 12:
                            textField.text=contacts.email;
                            break;
                            
                        case 13:
                            textField.text=contacts.postal_code;
                            break;
                            
                        case 14:
                            textField.text=contacts.frequent_flyer_program;
                            break;
                            
                        case 15:
                            textField.text=contacts.mileage_Program;
                            break;
                            
                        case 16:
                            textField.text=contacts.seat_preference;
                            break;
                            
                        case 17:
                            textField.text=contacts.special_Requirements;
                            break;
                            
                        case 18:
                            textField.text=contacts.special_Meal_Requests;
                            break;
                            
                        case 19:
                            textField.text=contacts.select_insurance_Provider;
                            break;
                            
                        case 20:
                            textField.text=contacts.select_Package;
                            break;
                    }
                }
                
            }
            
        }

    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  Bar Button Touch
-(IBAction)touchOnCancelButton:(id)sender
{
    [self resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)touchOnDoneButton:(id)sender
{
     [self resignFirstResponder];
    [self clearDropDownObject];
    int comingValue=[self validation];
    [self.view endEditing:YES];
   if(comingValue==-1)
   {
         NSLog(@"success");
        [self addContactDataInLocal];
        if(!passengerInfoCell.is_Image)
        {
            [passengerInfoCell drawTickImage];
        }
         [self dismissViewControllerAnimated:YES completion:nil];
       
      }
   else
   {
        //[self showAlertViewWithTitle:[NSString stringWithFormat:@"Error!"] Message:[NSString stringWithFormat:@"Please Fill Information Correctly"]];
         
       
//        if(comingValue==1)
//        {
//            stringValue=@"First Name";
//        }
//        else if(comingValue==2)
//        {
//           stringValue=@"Middle Name";
//        }
//        else if(comingValue==3)
//        {
//           stringValue=@"Last Name";
//        }
//        else if(comingValue==4)
//        {
//           stringValue=@"Phone Number";
//        }
//        else if(comingValue==5)
//        {
//           stringValue=@"Birthday";
//        }
//        else if(comingValue==6)
//        {
//           stringValue=@"Passport Field";
//        }
//       [self showAlertViewWithTitle:[NSString stringWithFormat:@"Error!"] Message:[NSString stringWithFormat:@"%@ Should not be empty",stringValue]];
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
    for(UITextField *textField in editTextField)
    {
        NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
        NSLog(@"tag value=%i",textField.tag);
         if ([[textField.text stringByTrimmingCharactersInSet: set] length] == 0)
        {
            [textField setText:nil];
            [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
            tagValue=textField.tag;
            [self showAlertViewWithTitle:@"Alert" Message:@"You Can't leave this empty" delegate:self];
            break;
        }
        else if (textField.tag==1)
        {
            if(![[Data sharedData]nameValidation:textField.text])
            {
                [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                tagValue=textField.tag;
               [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Valid First Name" delegate:self];
                break;

            }
        }
        else if (textField.tag==3)
        {
            if(![[Data sharedData]nameValidation:textField.text])
            {
                [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                tagValue=textField.tag;
                [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Valid Middle Name" delegate:self];
                break;

            }
        }
        else if (textField.tag==12)
        {
            if(![[Data sharedData]NSStringIsValidEmail:textField.text])
            {
                [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                tagValue=textField.tag;
                [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Valid Email" delegate:self];
                break;

                 break;
            }
        }
        else if (textField.tag==13)
        {
            if([countryCode isEqualToString:@"CA"]||[countryCode isEqualToString:@"US"])
            {
               if(![[Data sharedData]postalZipValidation:countryCode withPostalZipCode:textField.text])
               {
                   [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                   tagValue=textField.tag;
                   [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Valid PostalCode" delegate:self];
                   break;
               }
                
            }
        }
    }
    if(tagValue>=0)
    {
        //[self showError:tagValue];
    }
    return tagValue;
}

-(void)showError:(int)errorNumber
{
    if(errorNumber==1)
    {
         [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Valid First Name" delegate:self];
    }
    else if (errorNumber==3)
    {
        [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Valid Middle Name" delegate:self];
    }
    else if (errorNumber==12)
    {
        [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Valid Email" delegate:self];
    }
    else if (errorNumber==13)
    {
         [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Valid PostalCode" delegate:self];
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
-(BOOL)validatePhoneNumber:(NSString *)phoneNumber
{
//    NSString *phoneRegex =@"^((\\+)|(00))[0-9]{6,14}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
//    return [phoneTest evaluateWithObject:phoneNumber];
    
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([phoneNumber rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        if(phoneNumber.length==10)
        {
            return 1;
        }
        else
        {
            return 0;
        }
        
    }
    return 0;
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
#pragma mark TextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Text field did begin editing tag=%i",textField.tag);
    activeField = textField;
    [self removeErrorSign:textField];
     [self clearDropDownObject];
     if (textField.tag==11)
     {
        [self openDatePicker:textField];
     }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"Text field ended editing");
    //[self.view endEditing:YES];
    activeField =nil;
   
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag==5 || textField.tag==6)
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
    else if (textField.tag==12)
    {
        if([string isEqualToString:@" "])
        {
            return NO;
        }
    }
    else if (textField.tag==11)
    {
        return NO;
    }

    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//  NSInteger nextTag = textField.tag + 1;
//  // Try to find next responder
//  UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
//  
//  if (nextResponder) {
//      [scrollView setContentOffset:CGPointMake(0,textField.center.y-60) animated:YES];
//      // Found next responder, so set it.
//      [nextResponder becomeFirstResponder];
//  } else {
//      [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
//      [textField resignFirstResponder];
//      return YES;
//  }
//  
//  return NO;
    
   [textField resignFirstResponder];
   return YES;
}


#pragma mark  AlertViewDisplay
-(void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message delegate:(id)delegate
{
    if(!isAlertVisible)
    {
        isAlertVisible=YES;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    isAlertVisible=NO;
}
#pragma mark ContactData
-(void)addContactDataInLocal
{
  BOOL isExist=NO;
  ContactData *contactData=[[Data sharedData]checkContactEntityExist:AmgineContactsData passengerName:passengerName];
  NSManagedObjectContext *context=[[Data sharedData]getContext];
  NSMutableOrderedSet *set=[[NSMutableOrderedSet alloc]init];
  if(!contactData)
  {
      isExist=NO;
       contactData=[NSEntityDescription insertNewObjectForEntityForName:AmgineContactsData inManagedObjectContext:context];
  }
  else
  {
       isExist=YES;
  }
  contactData.name=passengerInfoCell.passenger_Name;
  Contacts *contacts=nil;
  if(!isExist)
  {
      contacts =[NSEntityDescription insertNewObjectForEntityForName:AmgineContacts inManagedObjectContext:context];
     // passengerCell.contacts=contacts;
  }
  else
  {
      contacts=[contactData.contacts objectAtIndex:0];
  }
    
    if(saveTextFieldArray.count==22)
    {
        for(UITextField *textField in saveTextFieldArray)
        {
            switch (textField.tag)
            {
                case 0:
                    contacts.title=textField.text;
                break;
                    
                case 1:
                    contacts.firstName= textField.text;
                break;
                    
                case 2:
                    contacts.middleName= textField.text;
                break;
                    
                case 3:
                    contacts.lastname= textField.text;
                break;
                    
                case 4:
                    contacts.gender=textField.text;
                break;
                    
                case 5:
                    contacts.phone_Mobile= textField.text;
                break;
                    
                case 6:
                    contacts.phone_Home= textField.text;
                break;
                    
                case 7:
                    contacts.address=textField.text;
                break;
                    
                case 8:
                    contacts.city= textField.text;
                break;
                    
                case 10:
                    NSLog(@"contacts.state=%@",textField.text);
                    contacts.state= textField.text;
                    contacts.provinceCode=provinceCode;
                break;
                    
                case 9:
                    contacts.country=textField.text;
                    contacts.country_Code=countryCode;
                break;
                    
                case 11:
                    contacts.date_of_birth=textField.text;
                    contacts.dob=SelectedDate;
                break;
                    
                case 12:
                    contacts.email= textField.text;
                break;
                case 13:
                     contacts.postal_code= textField.text;
                break;
                case 14:
                    contacts.is_Smoking= textField.text;
                break;
                    
                case 15:
                    contacts.frequent_flyer_program= textField.text;
                break;
                    
                case 16:
                    contacts.mileage_Program=textField.text;
                break;
                    
                case 17:
                    contacts.seat_preference=textField.text;
                break;
                    
                case 18:
                    contacts.special_Requirements=textField.text;
                break;
                    
                case 19:
                    contacts.special_Meal_Requests=textField.text;
                break;
                    
                case 20:
                    contacts.select_insurance_Provider=textField.text;
                break;
                    
                case 21:
                    contacts.select_Package=textField.text;
                break;
            }
        }
    }
    else
    {
        for(UITextField *textField in saveTextFieldArray)
        {
            switch (textField.tag)
            {
                case 0:
                    contacts.title=textField.text;
                break;
                    
                case 1:
                    contacts.firstName= textField.text;
                break;
                    
                case 2:
                    contacts.middleName= textField.text;
                break;
                    
                case 3:
                    contacts.lastname= textField.text;
                break;
                    
                case 4:
                    contacts.gender=textField.text;
                break;
                    
                case 5:
                    contacts.phone_Mobile= textField.text;
                break;
                    
                case 6:
                    contacts.phone_Home= textField.text;
                break;
                    
                case 7:
                    contacts.address=textField.text;
                break;
                    
                case 8:
                    contacts.city= textField.text;
                break;
                    
                case 10:
                    NSLog(@"contacts.state=%@",textField.text);
                    contacts.state= textField.text;
                    contacts.provinceCode=provinceCode;
                break;
                    
                case 9:
                    contacts.country=textField.text;
                    contacts.country_Code=countryCode;
                break;
                    
                case 11:
                    contacts.date_of_birth=textField.text;
                    contacts.dob=SelectedDate;
                break;
                    
                case 12:
                    contacts.email= textField.text;
                break;
                    
                case 13:
                    contacts.postal_code= textField.text;
                break;
                    
                case 14:
                    contacts.frequent_flyer_program= textField.text;
                break;
                    
                case 15:
                    contacts.mileage_Program=textField.text;
                break;
                    
                case 16:
                    contacts.seat_preference=textField.text;
                break;
                    
                case 17:
                    contacts.special_Requirements=textField.text;
                break;
                    
                case 18:
                    contacts.special_Meal_Requests=textField.text;
                break;
                    
                case 19:
                    contacts.select_insurance_Provider=textField.text;
                break;
                    
                case 20:
                    contacts.select_Package=textField.text;
                break;
            }
        }

    }
     [set addObject:contacts];
     contactData.contacts=set;
    [[Data sharedData]writeToDisk];
    [[LiveData getInstance]savePassengerInfo:contacts passenger_Id:passengerInfoCell.passenger];
}

#pragma mark urlConnectionDelegate
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
    
    NSMutableArray *countryData=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if([connection.serviceName isEqualToString:AmgineCountryCode])
    {
        [self removeActivityIndicator:connection];
        countryData=[[[Data sharedData]sortArray:countryData keyValue:@"name"]mutableCopy];
        NSMutableArray *countryArray=[[NSMutableArray alloc]init];
        for(NSDictionary *dictionary in countryData)
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
            [countryData removeObject:dictionary];
            [countryData insertObject:dictionary atIndex:0];
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:countryData forKey:@"countryData"];
        [[NSUserDefaults standardUserDefaults]synchronize];
         NSLog(@"****************value of Dictionary****************:%@",countryData);
        [self customViewSetup:countryData textField:CountryField objectType:AmgineCountryCode title:@"Country" withSize:CGSizeMake(287,420)];
        isTouchOnCountryTextField=NO;
        
     }
    else if([connection.serviceName isEqualToString:AmgineProvinceCode])
    {
        NSLog(@"value of data=%@",countryData);
        [self removeActivityIndicator:connection];
         countryData=[[[Data sharedData]sortArray:countryData keyValue:@"provincename"]mutableCopy];
        NSArray *filterArray=[[Data sharedData]getprovincAcctoCountryCode:countryCode withArray:countryData];
        
        [[NSUserDefaults standardUserDefaults]setObject:countryData forKey:@"provinceData"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        if(filterArray.count>0)
        {
           [self customViewSetup:filterArray textField:provinceTextField objectType:AmgineProvinceCode title:@"Province Code" withSize:CGSizeMake(287, 420)];
        }
        else
        {
            [self customViewSetup:countryData textField:provinceTextField objectType:AmgineProvinceCode title:@"Province Code" withSize:CGSizeMake(287, 420)];
        }
       
        isTouchOnProvinceTextField=NO;
    }


}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    //[passport setEnabled:YES];
    
    [self removeActivityIndicator:connection];
    [self showAlertView:errorMessage];
    if([connection.serviceName isEqualToString:AmgineCountryCode])
    {
        isTouchOnCountryTextField=NO;
    }
    else if ([connection.serviceName isEqualToString:AmgineProvinceCode])
    {
        isTouchOnProvinceTextField=NO;
    }

}

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
-(void)showAlertView:(NSString *)message
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
        
}

#pragma mark CustomViewSetup
-(void)customViewSetup:(NSArray *)country_Data textField:(UITextField *)textField objectType:(NSString *)objectType title:(NSString *)title withSize:(CGSize)size
{
    //287, 280
    
    [self resignFirstResponder];
    isKeyBoardUp=YES;
    [scrollView endEditing:YES];
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


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
//    if(isKeyBoardUp)
//    {
//        [self resignFirstResponder];
//        [self clearDropDownObject];
//    }
    return YES;
}

-(void)touchOnTextField:(UITapGestureRecognizer*)sender
{
    
    [self.view endEditing:YES];
    UITextField *textField=(UITextField *)sender.view;
     [self removeErrorSign:textField];
     activeField = textField;
    if(sender.view.tag==9)
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
    else if (sender.view.tag==0)
    {
        [self resignFirstResponder];
        [self customViewSetup:[[NSArray alloc]initWithObjects:@"Mr",@"Mrs",@"Miss", nil] textField:textField objectType:nil title:@"Title" withSize:CGSizeMake(287, 280)];
    }
     else if (sender.view.tag==4)
    {
        [self resignFirstResponder];
        [self customViewSetup:[[NSArray alloc]initWithObjects:@"Male",@"Female", nil] textField:textField objectType:nil title:@"Gender" withSize:CGSizeMake(287, 280)];
    }
    else if (sender.view.tag==10)
    {
        UITextField *countryTextField=[saveTextFieldArray objectAtIndex:9];
        NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
     //   NSLog(@"tag value=%i",countryTextField.tag);
        if ([[countryTextField.text stringByTrimmingCharactersInSet: set] length] == 0)
        {
             [self showAlertViewWithTitle:@"Alert" Message:@"Select Country First" delegate:self];
            return;
        }
        else if(!isTouchOnProvinceTextField)
        {
           // editCountryText=countryTextField.text;
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
    else if (sender.view.tag==14)
    {
        [self resignFirstResponder];
        [self customViewSetup:[[NSArray alloc]initWithObjects:@"Yes",@"No", nil] textField:textField objectType:nil title:@"Smoking" withSize:CGSizeMake(287, 280)];
    }
    

    activeField = nil;
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //[textfield resignFirstResponder];
  //  [self clearDropDownObject];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   // if(isKeyBoardUp)
   // {
        //[textfield resignFirstResponder];
         // [self clearDropDownObject];
         [self.view endEditing:YES];
    //}
}

@end
