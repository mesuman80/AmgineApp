//
//  DatePickerView.h
//  Amgine
//
//   on 04/08/14.
//   
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewDelegate <NSObject>

-(void)returnFromDatePickerView:(NSString *)string textField:(UITextField *)textField fromView:(UIView *)view;


@end
@interface DatePickerView : UIView
-(void)drawDatePicker;
@property id<DatePickerViewDelegate>delegate;
@property UITextField *textField;
@property UIDatePicker *datePicker;
@property NSDictionary *dictionary;
@property NSString *objectType;
@end
