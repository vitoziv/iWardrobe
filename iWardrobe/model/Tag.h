//
//  Tag.h
//  iWardrobe
//
//  Created by Vito on 5/18/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item, Look;

@interface Tag : NSManagedObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) NSOrderedSet *looks;
@property (nonatomic, strong) NSOrderedSet *items;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addLooksObject:(Look *)value;
- (void)removeLooksObject:(Look *)value;
- (void)addLooks:(NSOrderedSet *)values;
- (void)removeLooks:(NSOrderedSet *)values;

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSOrderedSet *)values;
- (void)removeItems:(NSOrderedSet *)values;

@end
