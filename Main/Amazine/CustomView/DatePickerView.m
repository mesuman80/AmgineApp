//
//  DatePickerView.m
//  Amgine
//
//   on 04/08/14.
//   
//

#import "DatePickerView.h"
#import "Data.h"
#import "Constants.h"

@implementation DatePickerView
{
    
    NSString *selectedDate;
    int maxYear;
    int month;
    int day;
    int minYear;
   // int yearBackValue;
}
@synthesize delegate;
@synthesize datePicker;
@synthesize textField;
@synthesize  dictionary;
@synthesize objectType;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addDoneOrCancelButton];
       // [self drawDatePicker];
    }
    return self;
}
-(void)addDoneOrCancelButton
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 320, 40)];
    [containerView setBackgroundColor:[UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:1]];
    [self addSubview:containerView];

    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, 8, 63, 27);
    [cancel setTitle:@"cancel" forState:UIControlStateNormal];
    cancel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    cancel.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancel setTintColor:[Data sharedData].buttonColor];
    [cancel setTitleColor:[Data sharedData].buttonColor forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents: UIControlEventTouchDown];
    
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	doneButton.frame = CGRectMake(containerView.frame.size.width - 65, 8, 63, 27);
    doneButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setTitleColor:[Data sharedData].buttonColor forState:UIControlStateNormal];
    
	[doneButton addTarget:self action:@selector(done:) forControlEvents: UIControlEventTouchUpInside];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [containerView addSubview:cancel];
    [containerView addSubview:doneButton];
    
}


-(void)cancel:(id)sender
{
    if(delegate)
    {
        [delegate returnFromDatePickerView:nil textField:textField fromView:self];
    }

    [self removeFromSuperview];
}
-(void)done:(id)sender
{
    if(selectedDate)
    {
       textField.text=selectedDate;
    }
    else
    {
       
    }
    NSLog(@"Value of text=%@",textField.text);
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    NSLog(@"tag value=%i",textField.tag);
    if ([[textField.text stringByTrimmingCharactersInSet: set] length] == 0)
    {
         [self showAlertView:@"You must select Date"];
         return;
    }
    if(delegate)
    {
       // textField.text=selectedDate;
        [delegate returnFromDatePickerView:selectedDate textField:textField fromView:self];
    }
    [self removeFromSuperview];
}
-(void)drawDatePicker
{
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 41, 100, 100)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setBackgroundColor:[UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:1]];
    datePicker.hidden = NO;
   // datePicker.date = [NSDate date];
    [datePicker addTarget:self action:@selector(dateChanged:)
     forControlEvents:UIControlEventValueChanged];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    maxYear=[[dictionary objectForKey:@"maxYear"]intValue];
    month=[[dictionary objectForKey:@"month"]intValue];
    day=[[dictionary objectForKey:@"day"]intValue];
    minYear=[[dictionary objectForKey:@"minYear"]intValue];
    
    [comps setYear:maxYear];
    [comps setDay:day];
    
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:minYear];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [datePicker setMaximumDate:maxDate];
    [datePicker setMinimumDate:minDate];
    
//    yearBackValue=[[dictionary objectForKey:@"setDate"]intValue];
//    [comps setYear:yearBackValue];
//    NSDate *yearBack = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
//    [datePicker setDate:yearBack];
     [self addSubview:datePicker];
    
    [self setDateOnChange];
    
}
- (void)dateChanged:(id)sender
{
   
    [self setDateOnChange];
    
}
-(void)setDateOnChange
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *strdate = [dateFormatter stringFromDate:datePicker.date];
    selectedDate=strdate;
    NSLog(@"value of Selected date=%@",datePicker.date);

}

-(void)showAlertView:(NSString *)message
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
