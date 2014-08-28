









//
//  PayMentInfoViewController.m
//  Amgine
//
//  Created by Amgine on 26/06/14.
//   
//

#import "PayMentInfoViewController.h"
#import "Data.h"
#import "PaymentInfo.h"
#import "Constants.h"
//#import "CustomViewController.h"
#import "DropDownListView.h"
#import "ScreenInfo.h"
#import "DatePickerView.h"
#import "BillingInformationViewController.h"
#import "LiveData.h"
#import "Luhn.h"
//#import "DropDownListView.h"
#import "UrlConnection.h"
#define ACCEPTABLE_CHARACTERS @"0123456789"

@interface PayMentInfoViewController ()<kDropDownListViewDelegate,DatePickerViewDelegate,UIGestureRecognizerDelegate,UrlConnectionDelegate,UIAlertViewDelegate>

@end

@implementation PayMentInfoViewController
{
    NSMutableArray *errorFieldArray;
    NSMutableArray *saveTextFieldArray;
    NSMutableArray *editTextField;
    UIScrollView *scrollView;
    UITextField *activeField;
    float screenWidth;
    float screenHeight;
    DatePickerView *datePickerView;
    NSDate *selectedDate;
    NSMutableArray *dropDownListViewArray;
    NSMutableArray *MonthArray;
    NSMutableArray *YearArray;
     BOOL isTouchOnProvinceTextField;
     NSString *provinceCode;
      UITextField *provinceTextField;
     NSMutableArray *parentViewArray;
    BOOL isAlertVisible;
   // NSMutableArray *

}

@synthesize selectedData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
#pragma mark  ViewDidLoad Function
- (void)viewDidLoad
{
    [super viewDidLoad];
    dropDownListViewArray=[[NSMutableArray alloc]init];
    parentViewArray=[[NSMutableArray alloc]init];
    [self initilizeView];
    [self drawDoneButton];
    [self drawUI];
    [self setupTextField];
    
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
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    isAlertVisible=NO;
    [self addNotification];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self resignFirstResponder];
    [self clearDropDownObject];
    [self clearNotification];
}
-(void)drawDoneButton
{
   UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(touchOnDone:)];
    self.navigationItem.rightBarButtonItem = doneButton;
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(60.0,0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}
-(void) keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets =UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    NSLog(@"Live=%f",self.view.frame.size.height/2.0f);
}


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
    //scrollView.bounces=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
}
-(void)drawUI
{
    float yy=60.0f;
    int tagValue=0;
    NSArray *labelArray=[[NSArray alloc]initWithObjects:@"First Name",@"Last Name",@"Credit Card Type",@"Credit Card Number",@"Expiration Date",@"CVV",nil];
    
    editTextField=[[NSMutableArray alloc]init];
    errorFieldArray=[[NSMutableArray alloc]init];
    saveTextFieldArray=[[NSMutableArray alloc]init];
    UITextField *yearTextField=nil;
    
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
        UITextField *textField=nil;
        if(tagValue==4)
        {
            textField =[[UITextField alloc]initWithFrame:CGRectMake(0,0,80,32)];
            textField.center=CGPointMake(140, label.center.y);
            textField.placeholder=@"MM";
            textField.tag=tagValue;
            textField.borderStyle=UITextBorderStyleRoundedRect;
            [textField setDelegate:self];
            [scrollView addSubview:textField];
            
            yearTextField =[[UITextField alloc]initWithFrame:CGRectMake(0,0,80,32)];
            yearTextField.center=CGPointMake(250, label.center.y);
            yearTextField.placeholder=@"Year";
            yearTextField.tag=++tagValue;
            yearTextField.borderStyle=UITextBorderStyleRoundedRect;
            [yearTextField setDelegate:self];
            [scrollView addSubview:yearTextField];
            
            
        }
        else
        {
            textField =[[UITextField alloc]initWithFrame:CGRectMake(0,0,320-100,32)];
            textField.center=CGPointMake(200, label.center.y);
            textField.tag=tagValue;
            textField.borderStyle=UITextBorderStyleRoundedRect;
            [textField setDelegate:self];
            [scrollView addSubview:textField];

        }
        
        yy+=frame.size.height+32;
        if(tagValue==3 || tagValue==6)
        {
            textField.keyboardType=UIKeyboardTypeNumberPad;
        }
        if(tagValue==2 || tagValue==5 /*|| tagValue==7 */)
        {
            [textField setUserInteractionEnabled:YES];
            [textField setDelegate:nil];
            textField.userInteractionEnabled = YES;
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOnTextField:)];
            [recognizer setNumberOfTapsRequired:1];
            recognizer.delegate= self;
            [textField addGestureRecognizer:recognizer];

        }
        if(tagValue==5)
        {
            [yearTextField setUserInteractionEnabled:YES];
            [yearTextField setDelegate:nil];
            yearTextField.userInteractionEnabled = YES;
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOnTextField:)];
            [recognizer setNumberOfTapsRequired:1];
            recognizer.delegate= self;
            [yearTextField addGestureRecognizer:recognizer];
        }
        
        [editTextField addObject:textField];
        if (tagValue==5)
        {
            [editTextField addObject:yearTextField];
            [saveTextFieldArray addObject:yearTextField];
        }
        
       [saveTextFieldArray addObject:textField];
        tagValue++;
        NSLog(@"%d",tagValue);
    }
    [scrollView setContentSize:CGSizeMake(320, yy)];
}

-(void)setupTextField
{
    PaymentInfo *paymentInfo=[[Data sharedData]checkExist];
    if(paymentInfo)
    {
        for(UITextField *textField in saveTextFieldArray)
        {
            switch (textField.tag)
            {
                case 0:
                    textField.text=paymentInfo.first_Name;
                break;
                    
                 case 1:
                    textField.text=paymentInfo.last_Name;
                 break;
                case 2:
                    textField.text=paymentInfo.credit_Card_Type;
                break;
                    
                case 3:
                    textField.text=paymentInfo.credit_Type_Number;
                break;
                case 4:
                    textField.text=paymentInfo.month;
                break;
                case 5:
                    textField.text=paymentInfo.year;
                break;
                case 6:
                    textField.text=paymentInfo.cvv;
                break;
//                case 7:
//                    textField.text=paymentInfo.provinceName;
//                    provinceCode=paymentInfo.provinceCode;
//                break;
            }
        }
    }
    else
    {
        
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark DrawErrorField
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

#pragma mark Button Touch
- (IBAction)touchOnCancelButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)touchOnDone:(id)sender
{
    int comingValue=[self validation];
     [self clearDropDownObject];
    [self.view endEditing:YES];
    if(comingValue==-1)
    {
         NSLog(@"success");
        [self saveDataToLocal];
        [self gotoNextScreen];
    }
    else
    {
        //[self showAlertViewWithTitle:[NSString stringWithFormat:@"Error!"] Message:[NSString stringWithFormat:@"Please Fill Information Correctly"]];
    }
    
    

}
-(void)gotoNextScreen
{
//    NSArray *arr=self.navigationController.viewControllers;
//    for(UIViewController *controller in arr)
//    {
//        NSLog(@"value of Controller =%@",controller);
//    }
    BillingInformationViewController *billingInfo=[[BillingInformationViewController alloc]init];
    billingInfo.bookingData=selectedData;
    [self.navigationController pushViewController:billingInfo animated:YES];
}
-(void)saveDataToLocal
{
    PaymentInfo *paymentInfo=[[Data sharedData]checkExist];
    NSManagedObjectContext *context=[[Data sharedData]getContext];
    
    if(!paymentInfo)
    {
        paymentInfo=[NSEntityDescription insertNewObjectForEntityForName:AmginePayMentInfo inManagedObjectContext:context];
    }
    
    for(UITextField *textField in saveTextFieldArray)
    {
        switch (textField.tag)
        {
            case 0:
                paymentInfo.first_Name=textField.text;
            break;
                
            case 1:
                paymentInfo.last_Name= textField.text;
            break;
                
            case 2:
                paymentInfo.credit_Card_Type= textField.text;
            break;
                
            case 3:
                paymentInfo.credit_Type_Number= textField.text;
            break;
                
            case 4:
                paymentInfo.month=textField.text;
            break;
                
            case 5:
                 paymentInfo.year=textField.text;
                NSLog(@"");
            break;
            case 6:
                paymentInfo.cvv=textField.text;
            break;
//            case 7:
//                paymentInfo.provinceName=textField.text;
//                paymentInfo.provinceCode=provinceCode;
//            break;
        }
    }
    
      [[Data sharedData]writeToDisk];
     [[LiveData getInstance]savePaymentInfo:paymentInfo];
  
}
-(int)validation
{
    int tagValue=-1;
    if(errorFieldArray>0)
    {
       for(UILabel *label in errorFieldArray)
       {
           [label removeFromSuperview];
       }
        [errorFieldArray removeAllObjects];
    }
    int CurrentYear=0;
    int SelectedYear=0;
    for(UITextField * textField in editTextField)
    {
            NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
            if ([[textField.text stringByTrimmingCharactersInSet: set] length] == 0)
            {
                [textField setText:nil];
                [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                tagValue=textField.tag;
                // [self showAlertViewWithTitle:@"Alert" Message:@"You Can't leave this empty" delegate:self];
                [self showAlertViewWithTitle:@"Alert" Message:@"You Can't leave this empty" Delegate:self];
                break;
            }
            else if (textField.tag==0)
            {
                if(![[Data sharedData]nameValidation:textField.text])
                {
                    [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                     tagValue=textField.tag;
                     [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Valid First Name" Delegate:self];
                    break;
                }
            }
            else if (textField.tag==1)
            {
                if(![[Data sharedData]nameValidation:textField.text])
                {
                    [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                    tagValue=textField.tag;
                    [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Valid Last Name" Delegate:self];
                    break;
                }

            }
            else if(textField.tag==6)
            {
                if(textField.text.length>3)
                {
                   // [textField setText:nil];
                    [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                    tagValue=textField.tag;
                    [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Valid cvv" Delegate:self];
                    break;
                }
                
            }
            else if (textField.tag==5)
            {
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy"];
                 NSString *yearString = [formatter stringFromDate:[NSDate date]];
                 CurrentYear=yearString.intValue;
                 SelectedYear=textField.text.intValue;
                if((SelectedYear-CurrentYear)<0)
                {
                    [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                    tagValue=textField.tag;
                    [self showAlertViewWithTitle:@"Alert" Message:@"Please select valid Year" Delegate:self];
                    break;
                }
            }
            else if (textField.tag==3)
            {
                 BOOL isValid = [textField.text isValidCreditCardNumber];
                 NSLog(@"isvalid=%i",isValid);
                if(!isValid)
                {
                    //[textField setText:nil];
                    [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                    tagValue=textField.tag;
                     [self showAlertViewWithTitle:@"Alert" Message:@"Not a Valid Credit Card Number" Delegate:self];
                    break;
                }
            }
       
     }
    
    if(tagValue==-1)
    {
        if ((SelectedYear-CurrentYear)==0)
        {
            
            UITextField *textField=[editTextField objectAtIndex:4];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM"];
            NSString *monthString = [formatter stringFromDate:[NSDate date]];
            int CurrentMonth=monthString.intValue;
            int SelectedMonth=textField.text.intValue;
            if(CurrentMonth>SelectedMonth)
            {
                [textField setText:nil];
                [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                tagValue=textField.tag;
                [self showAlertViewWithTitle:@"Alert" Message:@"Please Select Vaild Month" Delegate:self];
                 //[self showAlertViewWithTitle:@"Alert" Message:@"Not a Valid Credit Card" Number" Delegate:self];
               // tagValue=tagValue-1;

            }
         }

    }
    return tagValue;
}

#pragma mark TextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Text field did begin editing tag=%i",textField.tag);
    NSLog(@"Text field did begin editing tag=%i",textField.tag);
    activeField = textField;
    [self removeErrorSign:textField];
    [self clearDropDownObject];
//    if (textField.tag==4)
//    {
//        
//        [self openDatePicker:textField];
//    }
   
 }
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"Text field ended editing");
     activeField =nil;
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag==3)
    {
         NSLog(@"cursor location=%i",range.location);
        if(range.location>15 && textField.text.length>15)
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
    else if (textField.tag==6)
    {
        if(range.location>2 && textField.text.length>2)
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
    else if (textField.tag==4 || textField.tag==5)
    {
        return NO;
    }
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSLog(@"Text field Should Return tag=%i",textField.tag);
    return YES;
}

#pragma mark  AlertViewDisplay
-(void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate
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
#pragma mark urlConnectionDelegate
-(void)openUrl:(NSString *)stringUrl textField:(UITextField *)textField objectType:(NSString *)objectType
{
    if([objectType isEqualToString:AmgineProvinceCode])
    {
        provinceTextField=textField;
    }
    
    
    UrlConnection *connection=[[UrlConnection alloc]init];
    connection.delegate=self;
    connection.serviceName=objectType;
    connection.activity=[self showActivityIndicator:textField];
    [connection openUrl:stringUrl];
    [self showActivityIndicator:textField];
}


-(UIActivityIndicatorView*)showActivityIndicator:(UITextField *)textField
{
      UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.center=CGPointMake(textField.center.x+100, 16);
        [textField addSubview:activity];
        [activity startAnimating];
    return activity;
}

#pragma mark CustomViewSetup
-(void)customViewSetup:(NSArray *)country_Data textField:(UITextField *)textField objectType:(NSString *)objectType title:(NSString *)title withSize:(CGSize)size
{

    
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

    
     DropDownListView *dropDownListView=[[DropDownListView alloc]initWithTitle:title options:country_Data xy:CGPointMake(16,150) size:size isMultiple:NO];
    dropDownListView.delegate=self;
     dropDownListView.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    dropDownListView.alpha=1.0f;
    [dropDownListView SetBackGroundDropDwon_R:240 G:240 B:240 alpha:0.80];
    dropDownListView.textField=textField;
    dropDownListView.objectType=objectType;
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

-(void)openDatePicker:(UITextField *)textField
{
    if(!datePickerView)
    {
        datePickerView=[[DatePickerView alloc]initWithFrame:CGRectMake(0,screenHeight*.60,320,screenHeight*.40f)];
        NSMutableDictionary *dateDictionary=[[NSMutableDictionary alloc]init];
        [dateDictionary setValue:@"20" forKey:@"maxYear"];
        [dateDictionary setValue:@"0" forKey:@"month"];
        [dateDictionary setValue:@"1" forKey:@"day"];
        [dateDictionary setValue:@"0" forKey:@"minYear"];
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
        DatePickerView *datePickerView1=(DatePickerView *)view;
        selectedDate=datePickerView1.datePicker.date;
    }
    else
    {
        
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)touchOnTextField:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
    UITextField *textField=(UITextField *)sender.view;
     [self removeErrorSign:textField];
    if(textField.tag==2)
    {
       [self customViewSetup:[[NSArray alloc]initWithObjects:@"Visa",@"MasterCard",@"Amex", nil] textField:textField objectType:nil title:@"Card Type" withSize:CGSizeMake(287, 280)];
        
    }
    else if (textField.tag==4)//Month
    {
        if(!MonthArray)
        {
           // MonthArray=[[NSMutableArray alloc]initWithObjects:@"Jan",@"Feb",@"March",@"April",@"May",@"June",@"July",@"Aug",@"Sept",@"Oct",@"Nov",@"Dec", nil];
             MonthArray=[[NSMutableArray alloc]initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];
        }
        [self customViewSetup:MonthArray textField:textField objectType:nil title:@"Month" withSize:CGSizeMake(287, 280)];
    }
    else if (textField.tag==5)//year
    {
         if (!YearArray)
        {
            YearArray=[[NSMutableArray alloc]init];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy"];
            NSString *yearString = [formatter stringFromDate:[NSDate date]];
            [YearArray addObject:yearString];
            int year=yearString.intValue;
            for(int i=1;i<=20;i++)
            {
               // int newYear=year+i;
                [YearArray addObject:[NSString stringWithFormat:@"%i",year+i]];
               // year=newYear;
                NSLog(@"new Year=%i",year);
            }
            NSLog(@"Year Array=%@",YearArray);
            
        }

        [self customViewSetup:YearArray textField:textField objectType:nil title:@"Year" withSize:CGSizeMake(287, 280)];
    }
//    else if (textField.tag==7)
//    {
//        if(!isTouchOnProvinceTextField)
//        {
//            NSArray *provinceArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"provinceData"];
//            if(provinceArray)
//            {
//                [self customViewSetup:provinceArray textField:textField objectType:AmgineProvinceCode title:@"Province" withSize:CGSizeMake(287, 420)];
//            }
//            else
//            {
//                [self resignFirstResponder];
//                isTouchOnProvinceTextField=YES;
//                [self openUrl:[NSString stringWithFormat:@"%@/%@",AmgineAccessUrl,@"static/AllProvinces"] textField:textField objectType:AmgineProvinceCode];
//            }
//            
//        }
//        
//
//    }
    
    
}
#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //[textfield resignFirstResponder];
   // [self clearDropDownObject];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  //  [self clearDropDownObject];
    [self.view endEditing:YES];
}
#pragma mark connection delegate
-(void)connectionDidFinishLoadingData:(NSData *)data withService:(UrlConnection *)connection
{
     NSArray *countryData=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if([connection.serviceName isEqualToString:AmgineProvinceCode])
    {
        [[NSUserDefaults standardUserDefaults]setObject:countryData forKey:@"provinceData"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self removeActivityIndicator:connection];
        [self customViewSetup:countryData textField:provinceTextField objectType:AmgineProvinceCode title:@"Province Code" withSize:CGSizeMake(287, 420)];
        isTouchOnProvinceTextField=NO;
    }

}
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    [self removeActivityIndicator:connection];
    [self showAlertView:errorMessage];
    if ([connection.serviceName isEqualToString:AmgineProvinceCode])
    {
        isTouchOnProvinceTextField=NO;
    }

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
