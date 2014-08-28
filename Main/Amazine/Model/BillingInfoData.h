//
//  BillingInfoData.h
//  Amgine
//
//

#import <Foundation/Foundation.h>

@interface BillingInfoData : NSObject

+(BillingInfoData *)getData;
@property NSString *address;
@property NSString *suite;
@property NSString *city;
@property NSString *province;
@property NSString *postal;
@property NSString *country;

@end
BillingInfoData *billingDetailData;

