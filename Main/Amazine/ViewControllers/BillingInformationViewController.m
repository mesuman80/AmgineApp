//
//  BillingInformationViewController.m
//  Amgine
//

#import "BillingInformationViewController.h"
#import "ScreenInfo.h"
#import "Constants.h"
#import "UrlConnection.h"
//#import "CustomViewController.h"
#import "Data.h"
#import "BillingInfoData.h"
#import "LiveData.h"
#import "Passenger.h"
#import "Hotel.h"
#import "Flight.h"
#import "Contacts.h"
#import "ContactData.h"
#import "UrlConnection.h"
#import "DropDownListView.h"
#import "BillingInfo.h"
#import "BookingConfirmationController.h"



@interface BillingInformationViewController ()<UITextFieldDelegate,UITextViewDelegate,kDropDownListViewDelegate,UrlConnectionDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>


@end

@implementation BillingInformationViewController
{
    NSMutableArray *saveTextFieldArray;
    NSMutableArray *editTextField;
    NSMutableArray *errorFieldArray;
   // UIActivityIndicatorView *activity;
    float screenWidth;
    float screenHeight;
    UIScrollView *scrollView;
    UIView *activeField;
    float yy;
    int tagValue;
    // UITextView *addressView;
    UITextField *CountryField;
    UITextField *provinceTextField;
    // UIView *activeField;
    NSString *countryCode;
    NSString *provinceCode;
    BOOL is_Book_Touch;
    BOOL isTouchOnCountryTextField;
    BOOL isTouchOnProvinceTextField;
    
    NSMutableArray *dropDownListViewArray;
     NSMutableArray *parentViewArray;
    BOOL isAlertVisible;
    
}
@synthesize bookingData;
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
    self.title=@"Billing Address";
    dropDownListViewArray=[[NSMutableArray alloc]init];
    parentViewArray=[[NSMutableArray alloc]init];
    [self drawDoneButton];
    [self initilize];
    [self drawUI];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    isAlertVisible=NO;
     is_Book_Touch=YES;
    [self addNotification];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(44.0, 0.0, kbSize.height, 0.0);
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
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(44.0, 0.0,0.0, 0.0);

    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    NSLog(@"frame Height=%f",self.view.frame.size.height);
 
}


#pragma mark DrawingFunction
-(void)drawDoneButton
{

   UIBarButtonItem  *bookButton=[[UIBarButtonItem alloc]initWithTitle:@"Book" style:UIBarButtonItemStylePlain target:self action:@selector(gotoBooKingProcess:)];
    self.navigationItem.rightBarButtonItem = bookButton;
}
-(void)gotoBooKingProcess:(id)sender
{
    if(!is_Book_Touch)
    {
        return;
    }
    [self clearDropDownObject];
   [self resignFirstResponder];
    int success=[self validation];
    [self.view endEditing:YES];
    if(success==-1)
    {
        is_Book_Touch=NO;
         NSLog(@"success Dictionary=%@",liveData.bookingDictionary);
        self.navigationItem.hidesBackButton = YES;
        [self bookingDataStructure];
        [self callBooking:@"book/save"];
        
    }
    else
    {
         //[self showAlertViewWithTitle:[NSString stringWithFormat:@"Error!"] Message:[NSString stringWithFormat:@"Please Fill Information Correctly"]];
    }
}
-(void)bookingDataStructure
{
    [LiveData getInstance].bookingDictionary=[[NSMutableDictionary alloc]init];
    NSMutableArray *passengerArray=[[NSMutableArray alloc]init];
    
    NSLog(@"value of Dict=%lu",(unsigned long)[LiveData getInstance].selectedpassengerArray.count);
    for(Passenger *passenger in [LiveData getInstance].selectedpassengerArray)
    {
        NSMutableArray *itemArray=[[NSMutableArray alloc]init];
        
        NSMutableDictionary *dictionary=[[[LiveData getInstance]passenInfoDictionary]objectForKey:passenger.name];
        if(!dictionary)
        {
            ContactData *contactData=[[Data sharedData]checkContactEntityExist:AmgineContactsData passengerName:passenger.name];
            if(contactData)
            {
                Contacts *contacts=[contactData.contacts objectAtIndex:0];
                dictionary=[[LiveData getInstance]savePassengerInfo:contacts passenger_Id:passenger];
            }
        }
        for(Flight *flight in [[LiveData getInstance]flightArray])
        {
            if([flight.isalternative isEqualToString:@"0"] && [passenger.paxguid isEqualToString:flight.paxguid])
            {
                [itemArray addObject:flight.guid];
            }
        }
        for(Hotel *hotel in [[LiveData getInstance]hotelArray])
        {
            if([hotel.isalternative isEqualToString:@"0"] && [passenger.paxguid isEqualToString:hotel.paxguid])
            {
                [itemArray addObject:hotel.guid];
            }
            
        }
        [dictionary setObject:itemArray forKey:@"itemids"];
        [passengerArray addObject:dictionary];
    }
    
    BillingInfo *billingInfo=[[Data sharedData]checkExistanceofBillingInfo];
    if(!billingInfo)
    {
        billingInfo= [NSEntityDescription insertNewObjectForEntityForName:AmgineBillingInfo inManagedObjectContext:[[Data sharedData]getContext]];
    }
    billingInfo.address=[[editTextField objectAtIndex:0]text];
    billingInfo.suite=[[editTextField objectAtIndex:1]text];
    billingInfo.city=[[editTextField objectAtIndex:2]text];
    billingInfo.country=[[editTextField objectAtIndex:3]text];
    billingInfo.countryCode=countryCode;
    billingInfo.postal=[[editTextField objectAtIndex:4]text];
    billingInfo.province=[[editTextField objectAtIndex:5]text];
    billingInfo.provinceCode=provinceCode;
    [[Data sharedData]writeToDisk];
    
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setObject:billingInfo.address forKey:@"address"];
    [dictionary setObject:billingInfo.city forKey:@"city"];
    [dictionary setObject:billingInfo.provinceCode forKey:@"province"];
    [dictionary setObject:billingInfo.suite forKey:@"suite_apt"];
    [dictionary setObject:billingInfo.postal forKey:@"postalcode"];
    [dictionary setObject:billingInfo.countryCode forKey:@"country"];
    LiveData *liveData=[LiveData getInstance];
    [liveData.bookingDictionary setValue:liveData.solution_ID forKey:@"solutionid"];
    [liveData.bookingDictionary setValue:passengerArray forKey:@"paxdetails"];
    [liveData.billingInfoDictionary setObject:dictionary forKey:@"billingaddress"];
    [liveData.bookingDictionary setObject:liveData.billingInfoDictionary forKey:@"card"];
    NSLog(@"value of Booking Dictionary=%@",liveData.bookingDictionary);
}


-(void)initilize
{
    screenWidth=[ScreenInfo getScreenWidth];
    screenHeight=[ScreenInfo getScreenHeight];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, screenWidth, screenHeight)];
    scrollView.scrollEnabled=YES;
    scrollView.showsHorizontalScrollIndicator=YES;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.pagingEnabled=NO;
    scrollView.delegate=self;
    //scrollView.bounces=NO;
    [self.view addSubview:scrollView];
}
-(void)drawUI
{
     yy=44.0f;
     tagValue=0;
    
   // [self  setupAddress];
     NSArray *labelArray=[[NSArray alloc]initWithObjects:@"Address",@"Suite/Apt",@"City",@"Country",@"Postal/Zip",@"Province",nil];
    
    
//    NSArray *filledArray=[[NSArray alloc]initWithObjects:@"7 crescent place,",@"unit 2401",@"toronto",@"Canada",@"M4C5L7",@"ontario", nil];
//     int arrayIndex=0;
//     countryCode=@"CA";
//    provinceCode=@"ON";
    
    editTextField=[[NSMutableArray alloc]init];
    errorFieldArray=[[NSMutableArray alloc]init];
    saveTextFieldArray=[[NSMutableArray alloc]init];
    
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
      //  textField.text=[filledArray objectAtIndex:arrayIndex];
        textField.borderStyle=UITextBorderStyleRoundedRect;
        [textField setDelegate:self];
        [scrollView addSubview:textField];
        // arrayIndex++;
        yy+=frame.size.height+32;
        if(tagValue==0||tagValue==1 || tagValue==2 || tagValue==3 ||tagValue==4|| tagValue==5)//These are mendatory Field
        {
            [editTextField addObject:textField];
//            if(tagValue==4)
//            {
//                textField.keyboardType=UIKeyboardTypeNumberPad;
//            }
        }
        
        if(tagValue==3 || tagValue==5)
        {
            [textField setUserInteractionEnabled:YES];
            [textField setDelegate:nil];
            textField.userInteractionEnabled = YES;
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOnTextField:)];
            [recognizer setNumberOfTapsRequired:1];
            recognizer.delegate= self;
            [textField addGestureRecognizer:recognizer];
        }
        if(tagValue==3)
        {
            [textField setText:@"Canada"];
            countryCode=@"CA";
        }
        [saveTextFieldArray addObject:textField];
        tagValue++;
        NSLog(@"%f",yy);
    }
    [scrollView setContentSize:CGSizeMake(320, yy)];
    [self setupTextField];
    
}
-(void)setupTextField
{
    BillingInfo *billingInfo=[[Data sharedData]checkExistanceofBillingInfo];
    if(billingInfo)
    {
         [[editTextField objectAtIndex:0]setText:billingInfo.address];
         [[editTextField objectAtIndex:1]setText:billingInfo.suite];
         [[editTextField objectAtIndex:2]setText:billingInfo.city];
         [[editTextField objectAtIndex:3]setText:billingInfo.country];
          countryCode=billingInfo.countryCode;
         [[editTextField objectAtIndex:4]setText:billingInfo.postal];
         [[editTextField objectAtIndex:5]setText:billingInfo.province];
         provinceCode=billingInfo.provinceCode;
    }
    else
    {
        NSLog(@"First Time");
    }
}

#pragma mark  AlertViewDisplay
-(void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message delegate:(id) delegate
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
#pragma mark Validation and Error Sign
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
    int tagValue1=-1;
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
            tagValue1=textField.tag;
            [self showAlertViewWithTitle:@"Alert" Message:@"You Can't leave this empty" delegate:self];;
            break;
        }
        else if (textField.tag==4)
        {
          if([countryCode isEqualToString:@"CA"] || [countryCode isEqualToString:@"US"])
          {
              if(![[Data sharedData]postalZipValidation:countryCode withPostalZipCode:textField.text])
              {
                  [self addErrorField:CGPointMake(textField.center.x+textField.frame.size.width/2+5, textField.center.y)withtag:textField.tag];
                  tagValue1=textField.tag;
                   [self showAlertViewWithTitle:@"Alert" Message:@"Please Enter Valid PostalCode" delegate:self];
                  break;
              }

          }
      
       }
        
    }
//    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
//    NSLog(@"tag value=%i",addressView.tag);
//    if ([[addressView.text stringByTrimmingCharactersInSet: set] length] == 0)
//    {
//       // [addressView setText:nil];
//        [self addErrorField:CGPointMake(addressView.center.x+addressView.frame.size.width/2+5, addressView.center.y)withtag:addressView.tag];
//        tagValue1=addressView.tag;
//    }

    return tagValue1;
}
#pragma mark textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField=(UIView *)textField;
    [self removeErrorSign:textField];
    [self clearDropDownObject];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField=nil;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark textViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    activeField=(UIView *)textView;
    NSLog(@"Text view Did Begin Edting");
    if(errorFieldArray.count>0)
    {
        for(UILabel *label in errorFieldArray)
        {
            if(label.tag==textView.tag)
            {
                [label removeFromSuperview];
                [errorFieldArray removeObject:label];
                break;
            }
        }
        
    }

}

-(void)textViewDidEndEditing:(UITextView *)textView
{
      NSLog(@"Text view Did End Edting");
     activeField=nil;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
	if ( [ text isEqualToString: @"\n" ] )
    {
		[textView resignFirstResponder ];
		return NO;
	}
	return YES;
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
    connection.activity=[self showActivityIndicator:textField];
    [connection openUrl:stringUrl];
    [self showActivityIndicator:textField];
}

-(void)callBooking:(NSString *)searchType
{
    UrlConnection *connection=[[UrlConnection alloc]init];
    connection.delegate=self;
    connection.serviceName=AmgineBooking;
    [connection postData:[[LiveData getInstance]bookingDictionary] searchType:searchType];
    [self showLoaderView:YES withText:@"Processing...."];
    
}
#pragma mark LoaderViewDelegate
-(void)showLoaderView:(BOOL)show withText:(NSString *)text
{
    static UILabel *label;
    static UIActivityIndicatorView *activity1;
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
        
        activity1=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        activity1.center=CGPointMake(label.center.x, label.frame.origin.y+label.frame.size.height+10+activity1.frame.size.height/2);
        
        [activity1 startAnimating];
        [loaderView addSubview:activity1];
        [self.view addSubview:loaderView];
    }else
    {
        
        [label removeFromSuperview];
        [activity1 removeFromSuperview];
        [loaderView removeFromSuperview];
        label=nil;
        activity1=nil;
        loaderView=nil;
    }
}


-(void)connectionDidFinishLoadingData:(NSData *)data withService:(UrlConnection *)connection
{
    if([connection.serviceName isEqualToString:AmgineCountryCode])
    {
      NSArray *countryData=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
     [[NSUserDefaults standardUserDefaults]setObject:countryData forKey:@"countryData"];
     [[NSUserDefaults standardUserDefaults]synchronize];
        [self removeActivityIndicator:connection];
     [self customViewSetup:countryData textField:CountryField objectType:AmgineCountryCode title:@"Country" withsize:CGSizeMake(287, 420)];
        
      isTouchOnCountryTextField=NO;
    }
    else if([connection.serviceName isEqualToString:AmgineProvinceCode])
    {
         NSArray *countryData=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        [[NSUserDefaults standardUserDefaults]setObject:countryData forKey:@"provinceData"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSArray *filterArray=[[Data sharedData]getprovincAcctoCountryCode:countryCode withArray:countryData];
        if(filterArray.count>0)
        {
            [self customViewSetup:filterArray textField:provinceTextField objectType:AmgineProvinceCode title:@"Province Code" withsize:CGSizeMake(287, 420)];
        }
        else
        {
            [self customViewSetup:countryData textField:provinceTextField objectType:AmgineProvinceCode title:@"Province Code" withsize:CGSizeMake(287, 420)];
        }
        
        [self removeActivityIndicator:connection];
        
        isTouchOnProvinceTextField=NO;
    }
    else if ([connection.serviceName isEqualToString:AmgineBooking])
    {
        NSDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [self showLoaderView:NO withText:nil];
        NSLog(@"Dictionary=%@",dictionary);
        if(dictionary)
        {
            [LiveData getInstance].bookingConfirmationDictionary=dictionary;
            BookingConfirmationController *bookingConfirmation=[[BookingConfirmationController alloc]init];
            [self.navigationController pushViewController:bookingConfirmation animated:YES];
        }
        else
        {
            [self showAlertView:[NSString stringWithFormat:@"Booking Failed"]];

        }
       
        [self.navigationItem setHidesBackButton:NO];
        is_Book_Touch=YES;
    }
    
        
//        if(dictionary)
//        {
//             responseArray=[dictionary valueForKey:@"response"];
//            // for()
//             responseDictionary=[responseArray objectAtIndex:0];
//             tbc=[[responseDictionary objectForKey:@"tbc"]intValue];
//        }
//        
//        if(tbc==7)
//        {
//              [LiveData getInstance].bookingConfirmationDictionary=dictionary;
//              BookingConfirmationController *bookingConfirmation=[[BookingConfirmationController alloc]init];
//              [self.navigationController pushViewController:bookingConfirmation animated:YES];
//              [self.navigationItem setHidesBackButton:NO];
//              is_Book_Touch=YES;
//        }
//        else if (!dictionary)
//        {
//             [self showAlertView:[NSString stringWithFormat:@"Booking Failed"]];
//             self.navigationItem.hidesBackButton = NO;
//             is_Book_Touch=YES;
//        }
//        else if(dictionary)
//        {
//            
//             is_Book_Touch=YES;
//             NSDictionary *responseDictionary1=[responseDictionary objectForKey:@"response"];
//             NSString *msgString=[responseDictionary1 objectForKey:@"message"];
//              self.navigationItem.hidesBackButton = NO;
//             [self showAlertView:msgString];
//        }
//        else
//        {
//            
//        }
        
        
    
    
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    if(connection.activity)
    {
        [self removeActivityIndicator:connection];
    }
    [self showAlertView:errorMessage];
    if([connection.serviceName isEqualToString:AmgineCountryCode])
    {
         isTouchOnCountryTextField=NO;
    }
    else if ([connection.serviceName isEqualToString:AmgineProvinceCode])
    {
         isTouchOnProvinceTextField=NO;
    }
    else if ([connection.serviceName isEqualToString:AmgineBooking])
    {
        [self showLoaderView:NO withText:nil];
         is_Book_Touch=YES;
         self.navigationItem.hidesBackButton = NO;
    }
   
}

-(UIActivityIndicatorView *)showActivityIndicator:(UITextField *)textField
{
   UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.center=CGPointMake(textField.center.x, 16);
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
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    

}

#pragma mark CustomViewSetup
-(void)customViewSetup:(NSArray *)country_Data textField:(UITextField *)textField objectType:(NSString *)objectType title:(NSString *)title withsize:(CGSize)size
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
    dropDownListView.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    dropDownListView.delegate=self;
    dropDownListView.alpha=1.0f;
    [dropDownListView SetBackGroundDropDwon_R:240 G:240 B:240 alpha:0.80];
    dropDownListView.textField=textField;
    dropDownListView.objectType=objectType;
    [self.view addSubview:dropDownListView];
    [dropDownListViewArray addObject:dropDownListView];
}
#pragma mark customViewDelegate
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

-(void)touchOnParentView:(id)sender
{
    [self clearDropDownObject];
}


-(void)DropDownListViewDidCancel:(DropDownListView *)dropdownListView
{
    [dropdownListView.textField endEditing:YES];
    [self clearDropDownObject];
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
    activeField = textField;
    if(textField.tag==3)
    {
        
        if(!isTouchOnCountryTextField)
        {
            
            NSArray *countryArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"countryData"];
            if(countryArray)
            {
                [self customViewSetup:countryArray textField:textField objectType:AmgineCountryCode title:@"Country" withsize:CGSizeMake(287, 420)];
            }
            else
            {
                [self resignFirstResponder];
                isTouchOnCountryTextField=YES;
                [self openUrl:[NSString stringWithFormat:@"%@/%@",AmgineAccessUrl,@"static/AllCountries"] textField:textField objectType:AmgineCountryCode];
            }
        }
        
    }
    else if(textField.tag==5)
    {
        
        UITextField *countryTextField=[saveTextFieldArray objectAtIndex:3];
        NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
        NSLog(@"tag value=%@",countryTextField.text);
        if ([[countryTextField.text stringByTrimmingCharactersInSet: set] length] == 0)
        {
            [self showAlertViewWithTitle:@"Alert" Message:@"Select Country First" delegate:self];
            return;
        }

        if(!isTouchOnProvinceTextField)
        {
            NSArray *provinceArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"provinceData"];
            if(provinceArray)
            {
                NSArray *filterArray=[[Data sharedData]getprovincAcctoCountryCode:countryCode withArray:provinceArray];
                if(filterArray.count>0)
                {

                 [self customViewSetup:filterArray textField:textField objectType:AmgineProvinceCode title:@"Province" withsize:CGSizeMake(287, 420)];
                }
                else
                {
                    [self customViewSetup:provinceArray textField:textField objectType:AmgineProvinceCode title:@"Province" withsize:CGSizeMake(287, 420)];
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


    
}
#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //[textfield resignFirstResponder];
    //[self clearDropDownObject];
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   // [self clearDropDownObject];
    [self.view endEditing:YES];
}

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
