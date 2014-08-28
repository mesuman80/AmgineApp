//
//  CountryScrollView.h
//  Amgine
//

#import <UIKit/UIKit.h>

@interface CountryView : UIView
-(void)displayCountryName:(NSString *)country_Name countryCode:(NSString *)country_Code;
@property NSString *countryName;
@property NSString *countryCode;
@end
