//
//  countryPickerView.h
//  Amgine
//


#import <UIKit/UIKit.h>

@interface countryPickerView : UIPickerView<UIPickerViewDataSource,UIPickerViewDelegate>
{
     UIPickerView *pickerView;
      NSArray *displayData;
}
- (id)initWithFrame:(CGRect)frame array:(NSArray *)array;
@end
