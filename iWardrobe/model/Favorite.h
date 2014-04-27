//
//  Favorite.h
//  iWardrobe
//
//  Created by Vito on 4/27/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Collocation, Item;

@interface Favorite : NSManagedObject

@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) NSSet *collocations;
@end

@interface Favorite (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

- (void)addCollocationsObject:(Collocation *)value;
- (void)removeCollocationsObject:(Collocation *)value;
- (void)addCollocations:(NSSet *)values;
- (void)removeCollocations:(NSSet *)values;

@end
