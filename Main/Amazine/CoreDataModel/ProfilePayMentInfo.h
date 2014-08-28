//
//  ProfilePayMentInfo.h
//  Amgine
//
//  Created by Amgine on 14/08/14.
//   .
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProfileInfo;

@interface ProfilePayMentInfo : NSManagedObject

@property (nonatomic, retain) NSString * addCard;
@property (nonatomic, retain) NSString * cardType;
@property (nonatomic, retain) NSString * name_on_Card;
@property (nonatomic, retain) NSString * card_Number;
@property (nonatomic, retain) NSString * expire_date;
@property (nonatomic, retain) NSString * cvv;
@property (nonatomic, retain) ProfileInfo *relationship;

@end
