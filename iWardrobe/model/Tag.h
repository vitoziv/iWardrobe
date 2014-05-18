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

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *looks;
@property (nonatomic, retain) NSSet *items;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addLooksObject:(Look *)value;
- (void)removeLooksObject:(Look *)value;
- (void)addLooks:(NSSet *)values;
- (void)removeLooks:(NSSet *)values;

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
