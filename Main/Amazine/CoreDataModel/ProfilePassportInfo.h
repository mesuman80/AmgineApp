//
//  ProfilePassportInfo.h
//  Amgine
//
//  Created by Amgine on 14/08/14.
//   .
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProfileInfo;

@interface ProfilePassportInfo : NSManagedObject

@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * date_Of_issue;
@property (nonatomic, retain) NSString * expire_date;
@property (nonatomic, retain) NSString * passportNumber;
@property (nonatomic, retain) NSString * country_Code;
@property (nonatomic, retain) ProfileInfo *relationship;

@end
