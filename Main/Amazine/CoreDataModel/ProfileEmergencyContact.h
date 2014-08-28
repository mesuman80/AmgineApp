//
//  ProfileEmergencyContact.h
//  Amgine
//
//  Created by Amgine on 14/08/14.
//   .
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProfileInfo;

@interface ProfileEmergencyContact : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSString * date_of_birth;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * provinceCode;
@property (nonatomic, retain) NSString * countryCode;
@property (nonatomic, retain) ProfileInfo *relationship;

@end
