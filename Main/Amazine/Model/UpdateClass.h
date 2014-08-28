//
//  UpdateClass.h
//  Amgine
//
//   on 31/07/14.
//   
//

#import <Foundation/Foundation.h>

@interface UpdateClass : NSObject
+(UpdateClass *)getInstance;
@property NSMutableArray *passengerStorageArray;
@property BOOL isupDate;
@end
UpdateClass *getUpdateInstanceClass;