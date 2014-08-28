//
//  Flight.h
//  Amgine
//
//    on 21/08/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Response;

@interface Flight : NSManagedObject

@property (nonatomic, retain) NSString * arrival;
@property (nonatomic, retain) NSString * carrier;
@property (nonatomic, retain) NSString * cost;
@property (nonatomic, retain) NSString * departure;
@property (nonatomic, retain) NSString * destination;
@property (nonatomic, retain) NSString * equipment;
@property (nonatomic, retain) NSString * flightnumber;
@property (nonatomic, retain) NSString * flighttime;
@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSString * isalternative;
@property (nonatomic, retain) NSString * legs;
@property (nonatomic, retain) NSString * origin;
@property (nonatomic, retain) NSString * paxguid;
@property (nonatomic, retain) NSString * seatclass;
@property (nonatomic, retain) NSString * travelsector;
@property (nonatomic, retain) NSString * traveltime;
@property (nonatomic, retain) NSString * availableFlightId;
@property (nonatomic, retain) Response *response;

@end
