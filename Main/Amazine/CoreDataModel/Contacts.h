//
//  Contacts.h
//  Amgine
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContactData;

@interface Contacts : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * country_Code;
@property (nonatomic, retain) NSString * date_of_birth;
@property (nonatomic, retain) NSDate * dob;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * frequent_flyer_program;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSString * mileage_Program;
@property (nonatomic, retain) NSString * phone_Home;
@property (nonatomic, retain) NSString * phone_Mobile;
@property (nonatomic, retain) NSString * postal_code;
@property (nonatomic, retain) NSString * provinceCode;
@property (nonatomic, retain) NSString * seat_preference;
@property (nonatomic, retain) NSString * select_insurance_Provider;
@property (nonatomic, retain) NSString * select_Package;
@property (nonatomic, retain) NSString * special_Meal_Requests;
@property (nonatomic, retain) NSString * special_Requirements;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * is_Smoking;
@property (nonatomic, retain) ContactData *contactData;

@end
