//
//  Response.h
//  Amgine
//
//  Created by Amgine on 20/06/14.
//   
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Flight, Flightleg, Hotel, Passenger, Solution_Id;

@interface Response : NSManagedObject

@property (nonatomic, retain) NSString * eventname;
@property (nonatomic, retain) NSString * index;
@property (nonatomic, retain) NSString * tbc;
@property (nonatomic, retain) NSOrderedSet *flight;
@property (nonatomic, retain) NSOrderedSet *flightleg;
@property (nonatomic, retain) NSOrderedSet *hotel;
@property (nonatomic, retain) NSOrderedSet *passenger;
@property (nonatomic, retain) Solution_Id *solution;
@end

@interface Response (CoreDataGeneratedAccessors)

- (void)insertObject:(Flight *)value inFlightAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFlightAtIndex:(NSUInteger)idx;
- (void)insertFlight:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFlightAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFlightAtIndex:(NSUInteger)idx withObject:(Flight *)value;
- (void)replaceFlightAtIndexes:(NSIndexSet *)indexes withFlight:(NSArray *)values;
- (void)addFlightObject:(Flight *)value;
- (void)removeFlightObject:(Flight *)value;
- (void)addFlight:(NSOrderedSet *)values;
- (void)removeFlight:(NSOrderedSet *)values;
- (void)insertObject:(Flightleg *)value inFlightlegAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFlightlegAtIndex:(NSUInteger)idx;
- (void)insertFlightleg:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFlightlegAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFlightlegAtIndex:(NSUInteger)idx withObject:(Flightleg *)value;
- (void)replaceFlightlegAtIndexes:(NSIndexSet *)indexes withFlightleg:(NSArray *)values;
- (void)addFlightlegObject:(Flightleg *)value;
- (void)removeFlightlegObject:(Flightleg *)value;
- (void)addFlightleg:(NSOrderedSet *)values;
- (void)removeFlightleg:(NSOrderedSet *)values;
- (void)insertObject:(Hotel *)value inHotelAtIndex:(NSUInteger)idx;
- (void)removeObjectFromHotelAtIndex:(NSUInteger)idx;
- (void)insertHotel:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeHotelAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInHotelAtIndex:(NSUInteger)idx withObject:(Hotel *)value;
- (void)replaceHotelAtIndexes:(NSIndexSet *)indexes withHotel:(NSArray *)values;
- (void)addHotelObject:(Hotel *)value;
- (void)removeHotelObject:(Hotel *)value;
- (void)addHotel:(NSOrderedSet *)values;
- (void)removeHotel:(NSOrderedSet *)values;
- (void)insertObject:(Passenger *)value inPassengerAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPassengerAtIndex:(NSUInteger)idx;
- (void)insertPassenger:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePassengerAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPassengerAtIndex:(NSUInteger)idx withObject:(Passenger *)value;
- (void)replacePassengerAtIndexes:(NSIndexSet *)indexes withPassenger:(NSArray *)values;
- (void)addPassengerObject:(Passenger *)value;
- (void)removePassengerObject:(Passenger *)value;
- (void)addPassenger:(NSOrderedSet *)values;
- (void)removePassenger:(NSOrderedSet *)values;
@end
