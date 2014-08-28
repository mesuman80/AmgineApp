//
//  BillingInfoData.m
//  Amgine
//

#import "BillingInfoData.h"

@implementation BillingInfoData

+(BillingInfoData *)getData
{
    if(!billingDetailData)
    {
        billingDetailData=[[BillingInfoData alloc]init];
    }
    return billingDetailData;
}

-(id)init
{
    if(self=[super init])
    {
        
    }
    return self;
}

@end
