//
//  Look.h
//  iWardrobe
//
//  Created by Vito on 5/22/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageBaseData.h"

@class Item, Info, Tag;

@interface Look : ImageBaseData

@property (nonatomic, strong) NSOrderedSet *items;

@end

@interface Look (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSOrderedSet *)values;
- (void)removeItems:(NSOrderedSet *)values;

- (void)addInfosObject:(Info *)value;
- (void)removeInfosObject:(Info *)value;
- (void)addInfos:(NSOrderedSet *)values;
- (void)removeInfos:(NSOrderedSet *)values;

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSOrderedSet *)values;
- (void)removeTags:(NSOrderedSet *)values;

@end
