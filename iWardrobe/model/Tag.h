//
//  Tag.h
//  iWardrobe
//
//  Created by Vito on 12/2/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item, Look;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *items;
@property (nonatomic, retain) NSOrderedSet *looks;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)insertObject:(Item *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(Item *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)values;
- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSOrderedSet *)values;
- (void)removeItems:(NSOrderedSet *)values;
- (void)insertObject:(Look *)value inLooksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLooksAtIndex:(NSUInteger)idx;
- (void)insertLooks:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLooksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLooksAtIndex:(NSUInteger)idx withObject:(Look *)value;
- (void)replaceLooksAtIndexes:(NSIndexSet *)indexes withLooks:(NSArray *)values;
- (void)addLooksObject:(Look *)value;
- (void)removeLooksObject:(Look *)value;
- (void)addLooks:(NSOrderedSet *)values;
- (void)removeLooks:(NSOrderedSet *)values;
@end
