//
//  UpdateClass.m
//  Amgine
//
//   on 31/07/14.
//   
//

#import "UpdateClass.h"

@implementation UpdateClass
@synthesize passengerStorageArray;
@synthesize isupDate;
+(UpdateClass *)getInstance
{
    if(!getUpdateInstanceClass)
    {
        getUpdateInstanceClass=[[UpdateClass alloc]init];
    }
    return getUpdateInstanceClass;
}

-(id)init
{
    if(self=[super init])
    {
        return self;
    }
    return nil;
}
@end
