//
//  Hotel.h
//  Amgine
//
//    on 21/08/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Response;

@interface Hotel : NSManagedObject

@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * address3;
@property (nonatomic, retain) NSString * amenities;
@property (nonatomic, retain) NSString * chain;
@property (nonatomic, retain) NSString * checkin;
@property (nonatomic, retain) NSString * checkout;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * citycode;
@property (nonatomic, retain) NSString * cost;
@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSString * hotelchain;
@property (nonatomic, retain) NSString * hotelcode;
@property (nonatomic, retain) NSString * hotelname;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * isalternative;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * locationdescription;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * maximumamount;
@property (nonatomic, retain) NSString * minimumamount;
@property (nonatomic, retain) NSString * paxguid;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * postalcode;
@property (nonatomic, retain) NSString * roomtype;
@property (nonatomic, retain) NSString * shortdescription;
@property (nonatomic, retain) NSString * starrating;
@property (nonatomic, retain) NSString * roomCode;
@property (nonatomic, retain) NSString * stateProvince;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) Response *response;

@end
