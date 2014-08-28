//
//  PaymentInfo.h
//  Amgine
//
//   on 08/08/14.
//   
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PaymentInfo : NSManagedObject

@property (nonatomic, retain) NSString * credit_Card_Type;
@property (nonatomic, retain) NSString * credit_Type_Number;
@property (nonatomic, retain) NSString * first_Name;
@property (nonatomic, retain) NSString * last_Name;
@property (nonatomic, retain) NSString * cvv;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSString * month;
@property (nonatomic, retain) NSString * provinceName;
@property (nonatomic, retain) NSString * provinceCode;

@end
