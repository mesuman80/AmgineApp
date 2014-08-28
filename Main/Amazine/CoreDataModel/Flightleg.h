//
//  Flightleg.h
//  Amgine
//
//  Created by Amgine on 19/06/14.
//   
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Response;

@interface Flightleg : NSManagedObject

@property (nonatomic, retain) NSString * arrival;
@property (nonatomic, retain) NSString * arrivals;
@property (nonatomic, retain) NSString * carrier;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * cost;
@property (nonatomic, retain) NSString * departure;
@property (nonatomic, retain) NSString * departures;
@property (nonatomic, retain) NSString * destination;
@property (nonatomic, retain) NSString * equipment;
@property (nonatomic, retain) NSString * flightnumber;
@property (nonatomic, retain) NSString * flighttime;
@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSString * origin;
@property (nonatomic, retain) NSString * parentguid;
@property (nonatomic, retain) NSString * paxguid;
@property (nonatomic, retain) NSString * ref;
@property (nonatomic, retain) NSString * seq;
@property (nonatomic, retain) Response *response;

@end
