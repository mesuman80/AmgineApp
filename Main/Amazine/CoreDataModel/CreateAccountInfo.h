//
//  CreateAccountInfo.h
//  Amgine
//
//    on 25/08/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CreateAccountInfo : NSManagedObject

@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * ccFirstName;
@property (nonatomic, retain) NSString * ccLastName;
@property (nonatomic, retain) NSString * cctype;
@property (nonatomic, retain) NSString * cellPhone;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * confirmPassword;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * countryCode;
@property (nonatomic, retain) NSString * d_o_b;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * gtaUserProfileId;
@property (nonatomic, retain) NSString * homePhone;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSString * provinceCode;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * title;

@end
