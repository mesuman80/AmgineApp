//
//  BillingInfo.h
//  Amgine
//
// on 16/08/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BillingInfo : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * suite;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * postal;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSString * provinceCode;
@property (nonatomic, retain) NSString * countryCode;

@end
