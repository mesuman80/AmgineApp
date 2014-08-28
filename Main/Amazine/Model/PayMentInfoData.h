//
//  PayMentInfoData.h
//  Amgine
//
//   on 05/08/14.
//   
//

#import <Foundation/Foundation.h>

@interface PayMentInfoData : NSObject
+(PayMentInfoData *)getPaymentData;
@property NSString *firstname;
@property NSString *lastName;
@property NSString *credit_Card_Type;
@property NSString *credit_Card_Number;
@property NSDate *ExpirationDate;
@property NSString *passengerName;

@end
PayMentInfoData *paymentDetailData;

