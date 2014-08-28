//
//  ProfileInfo.h
//  Amgine
//
//  Created by Amgine on 14/08/14.
//   .
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BasicProfile, ProfileEmergencyContact, ProfilePassportInfo, ProfilePayMentInfo;

@interface ProfileInfo : NSManagedObject

@property (nonatomic, retain) NSString * email_Id;
@property (nonatomic, retain) BasicProfile *relationBasicProfile;
@property (nonatomic, retain) ProfileEmergencyContact *relationProfileEmergency;
@property (nonatomic, retain) ProfilePayMentInfo *relationProfilePayment;
@property (nonatomic, retain) ProfilePassportInfo *relationProfilePassportInfo;

@end
