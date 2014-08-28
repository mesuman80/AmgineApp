//
//  ContactData.h
//  Amgine
//
//  Created by Amgine on 27/06/14.
//   
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contacts;

@interface ContactData : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *contacts;
@end

@interface ContactData (CoreDataGeneratedAccessors)

- (void)insertObject:(Contacts *)value inContactsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromContactsAtIndex:(NSUInteger)idx;
- (void)insertContacts:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeContactsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInContactsAtIndex:(NSUInteger)idx withObject:(Contacts *)value;
- (void)replaceContactsAtIndexes:(NSIndexSet *)indexes withContacts:(NSArray *)values;
- (void)addContactsObject:(Contacts *)value;
- (void)removeContactsObject:(Contacts *)value;
- (void)addContacts:(NSOrderedSet *)values;
- (void)removeContacts:(NSOrderedSet *)values;
@end
