//
//  countryPickerView.m
//  Amgine
//


#import "countryPickerView.h"

@implementation countryPickerView
{
    
    
}

- (id)initWithFrame:(CGRect)frame array:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        pickerView=[[UIPickerView alloc]initWithFrame:frame];
        displayData=array;
        NSLog(@"Display Data =%@,%i",[displayData objectAtIndex:0],displayData.count);
        [pickerView setDelegate:self];
        [pickerView setDataSource:self];
        [self addSubview:pickerView];
        
    }
    return self;
}
#pragma mark PickerViewSpecificFunction
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return displayData.count;
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dictionary=[displayData objectAtIndex:row];
    NSLog(@"value of Tittle:%@",[dictionary objectForKey:@"name"]);
    return [dictionary objectForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
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
