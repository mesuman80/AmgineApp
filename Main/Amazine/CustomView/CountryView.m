//
//  CountryScrollView.m
//  Amgine
//

#import "CountryView.h"

@implementation CountryView

@synthesize countryName;
@synthesize countryCode;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

-(void)displayCountryName:(NSString *)country_Name countryCode:(NSString *)country_Code
{
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
