//
//  BasicProfile.h
//  Amgine
//
//  Created by Amgine on 14/08/14.
//   .
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProfileInfo;

@interface BasicProfile : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSString * date_of_Birth;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * incomeRange;
@property (nonatomic, retain) NSString * maritalStatus;
@property (nonatomic, retain) NSString * children;
@property (nonatomic, retain) NSString * bussinessTripPerYear;
@property (nonatomic, retain) NSString * leisureTripPerYear;
@property (nonatomic, retain) NSString * more_price_of_time_sensitive;
@property (nonatomic, retain) NSString * far_in_advance_book_Travel;
@property (nonatomic, retain) NSString * provinceCode;
@property (nonatomic, retain) NSString * countryCode;
@property (nonatomic, retain) ProfileInfo *relationship;

@end
