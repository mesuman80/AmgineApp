//
//  Passenger.h
//  Amgine
//
//  Created by Amgine on 23/07/14.
//   
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FlightID, HotelId, Response;

@interface Passenger : NSManagedObject

@property (nonatomic, retain) NSString * index;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * paxguid;
@property (nonatomic, retain) Response *response;
@property (nonatomic, retain) NSOrderedSet *flightIdArray;
@property (nonatomic, retain) NSOrderedSet *hotelIdArray;
@end

@interface Passenger (CoreDataGeneratedAccessors)

- (void)insertObject:(FlightID *)value inFlightIdArrayAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFlightIdArrayAtIndex:(NSUInteger)idx;
- (void)insertFlightIdArray:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFlightIdArrayAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFlightIdArrayAtIndex:(NSUInteger)idx withObject:(FlightID *)value;
- (void)replaceFlightIdArrayAtIndexes:(NSIndexSet *)indexes withFlightIdArray:(NSArray *)values;
- (void)addFlightIdArrayObject:(FlightID *)value;
- (void)removeFlightIdArrayObject:(FlightID *)value;
- (void)addFlightIdArray:(NSOrderedSet *)values;
- (void)removeFlightIdArray:(NSOrderedSet *)values;
- (void)insertObject:(HotelId *)value inHotelIdArrayAtIndex:(NSUInteger)idx;
- (void)removeObjectFromHotelIdArrayAtIndex:(NSUInteger)idx;
- (void)insertHotelIdArray:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeHotelIdArrayAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInHotelIdArrayAtIndex:(NSUInteger)idx withObject:(HotelId *)value;
- (void)replaceHotelIdArrayAtIndexes:(NSIndexSet *)indexes withHotelIdArray:(NSArray *)values;
- (void)addHotelIdArrayObject:(HotelId *)value;
- (void)removeHotelIdArrayObject:(HotelId *)value;
- (void)addHotelIdArray:(NSOrderedSet *)values;
- (void)removeHotelIdArray:(NSOrderedSet *)values;
@end
