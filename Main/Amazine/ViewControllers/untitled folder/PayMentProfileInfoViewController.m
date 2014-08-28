//
//  PayMentInfoViewController.m
//  Amgine
//
//  Created by Amgine on 13/08/14.
//   .
//

#import "PayMentProfileInfoViewController.h"
#import "ScreenInfo.h"
#import "Constants.h"
#import "DropDownListView.h"

#import "DatePickerView.h"
#import "Data.h"
#import "Luhn.h"
#import "ProfileInfo.h"
#import "ProfilePayMentInfo.h"

#define ACCEPTABLE_CHARACTERS @"0123456789"

@interface PayMentProfileInfoViewController ()<kDropDownListViewDelegate,DatePickerViewDelegate>

@end

@implementation PayMentProfileInfoViewController
{
    UIScrollView *scrollView;
    UITextField *activeField;
    
    NSMutableArray *allTextFieldArray;
    NSMutableArray *errorFieldArray;
    NSMutableArray *dropDownListViewArray;
    NSMutableArray *parentViewArray;
    
    float screenWidth;
    float screenHeight;
    
    DatePickerView *datePickerView;
    NSDate *SelectedDate;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"Payment Info"];
    
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
    NSMutableArray *labelArray=[[NSMutableArray alloc]initWithObjects:@"Add Card",@"Card Type",@"Name on Card",@"Card Number",@"Expire Date",@"CVV",nil];
    
    
  //  mandatoryFieldArray=[[NSMutableArray alloc]init];
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
        if(tagValue==3 ||tagValue==5)
        {
            textField.keyboardType=UIKeyboardTypeDecimalPad;
        }
        
        else if (tagValue==0|| tagValue==1)
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
    ProfilePayMentInfo *profilePaymentInfo=profileInfo.relationProfilePayment;
    if(profilePaymentInfo)
    {
        for(UITextField *textField in allTextFieldArray)
        {
            switch (textField.tag)
            {
                case 0:
                    textField.text=profilePaymentInfo.addCard;
                break;
                    
                case 1:
                    textField.text=profilePaymentInfo.cardType;
                break;
                    
                case 2:
                    textField.text=profilePaymentInfo.name_on_Card;
                break;
                    
                case 3:
                    textField.text=profilePaymentInfo.card_Number;
                break;
                    
                case 4:
                    textField.text=profilePaymentInfo.expire_date;
                break;
                    
                case 5:
                    textField.text=profilePaymentInfo.cvv;
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
    
   for(UITextField *textField in allTextFieldArray)
   {
       NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
       NSLog(@"tag value=%i",textField.tag);
       if ([[textField.text stringByTrimmingCharactersInSet: set] length]!= 0)
       {
           if(textField.tag==3)
           {
               BOOL isValid = [textField.text isValidCreditCardNumber];
               NSLog(@"isvalid=%i",isValid);
               if(!isValid)
               {
                   //[textField setText:nil];
                   [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                   tagValue=textField.tag;
               }

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

-(void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}
-(void)saveDataToLocal
{
    ProfileInfo *profileInfo=[Data sharedData].userLoginProfileInfo;
    ProfilePayMentInfo *profilePayMentInfo=profileInfo.relationProfilePayment;
    if(profilePayMentInfo==nil)
    {
        profilePayMentInfo=[NSEntityDescription insertNewObjectForEntityForName:AmgimeProfilePayMentInfo inManagedObjectContext:[[Data sharedData]getContext]];
    }
    for(UITextField *textField in allTextFieldArray)
    {
        switch (textField.tag)
        {
            case 0:
                profilePayMentInfo.addCard=textField.text;
            break;
                
            case 1:
                profilePayMentInfo.cardType=textField.text;
            break;
                
            case 2:
                profilePayMentInfo.name_on_Card=textField.text;
            break;
                
            case 3:
                profilePayMentInfo.card_Number=textField.text;
            break;
                
            case 4:
                profilePayMentInfo.expire_date=textField.text;
                break;
                
            case 5:
                profilePayMentInfo.cvv= textField.text;
            break;
        }
    }
    profileInfo.relationProfilePayment=profilePayMentInfo;
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
    if(textField.tag==4)
    {
        [self openDatePicker:textField];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag==3)
    {
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
    else if (textField.tag==5)
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
    else if (textField.tag==4)
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

#pragma mark DatePicker Delegate
-(void)openDatePicker:(UITextField *)textField
{
    if(!datePickerView)
    {
        datePickerView=[[DatePickerView alloc]initWithFrame:CGRectMake(0,screenHeight*.60,320,screenHeight*.40f)];
        NSMutableDictionary *dateDictionary=[[NSMutableDictionary alloc]init];
        [dateDictionary setValue:@"10" forKey:@"maxYear"];
        [dateDictionary setValue:@"0" forKey:@"month"];
        [dateDictionary setValue:@"1" forKey:@"day"];
        [dateDictionary setValue:@"0" forKey:@"minYear"];
       // [dateDictionary setValue:@"-20" forKey:@"setDate"];
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
    if(textField.tag==0 || textField.tag==1)
    {
        [self customViewSetup:[[NSArray alloc]initWithObjects:@"Visa",@"MasterCard",@"Amex", nil] textField:textField objectType:nil title:@"Card Type" withSize:CGSizeMake(287, 280)];
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
