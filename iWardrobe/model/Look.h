//
//  Look.h
//  iWardrobe
//
//  Created by Vito on 5/22/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageBaseData.h"

@class Item, Location, Tag;

@interface Look : ImageBaseData

@property (nonatomic, retain) NSSet *items;

@end

@interface Look (CoreDataGeneratedAccessors)

- (void)addItemLocationsObject:(Location *)value;
- (void)removeItemLocationsObject:(Location *)value;
- (void)addItemLocations:(NSSet *)values;
- (void)removeItemLocations:(NSSet *)values;

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
