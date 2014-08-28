//
//  Solution_Id.h
//  Amgine
//
//  Created by Amgine on 20/06/14.
//   
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Response;

@interface Solution_Id : NSManagedObject

@property (nonatomic, retain) NSString * solutionid;
@property (nonatomic, retain) NSOrderedSet *response;
@end

@interface Solution_Id (CoreDataGeneratedAccessors)

- (void)insertObject:(Response *)value inResponseAtIndex:(NSUInteger)idx;
- (void)removeObjectFromResponseAtIndex:(NSUInteger)idx;
- (void)insertResponse:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeResponseAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInResponseAtIndex:(NSUInteger)idx withObject:(Response *)value;
- (void)replaceResponseAtIndexes:(NSIndexSet *)indexes withResponse:(NSArray *)values;
- (void)addResponseObject:(Response *)value;
- (void)removeResponseObject:(Response *)value;
- (void)addResponse:(NSOrderedSet *)values;
- (void)removeResponse:(NSOrderedSet *)values;
@end
