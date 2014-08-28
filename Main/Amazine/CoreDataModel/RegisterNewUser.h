//
//  RegisterNewUser.h
//  Amgine
//
//    on 22/08/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RegisterNewUser : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * token;

@end
