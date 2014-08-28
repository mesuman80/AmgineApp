//
//  PayMentInfoData.m
//  Amgine
//
//   on 05/08/14.
//   
//

#import "PayMentInfoData.h"

@implementation PayMentInfoData
+(PayMentInfoData *)getPaymentData
{
    if(!paymentDetailData)
    {
        paymentDetailData=[[PayMentInfoData alloc]init];
    }
    return paymentDetailData;
}
-(id)init
{
    if(self=[super init])
    {
        
    }
    return self;
}
@end
