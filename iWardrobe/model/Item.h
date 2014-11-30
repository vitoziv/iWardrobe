//
//  Item.h
//  iWardrobe
//
//  Created by Vito on 5/22/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageBaseData.h"

@class Look, Tag;

@interface Item : ImageBaseData

@property (nonatomic, strong) NSOrderedSet *looks;

@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addLooksObject:(Look *)value;
- (void)removeLooksObject:(Look *)value;
- (void)addLooks:(NSOrderedSet *)values;
- (void)removeLooks:(NSOrderedSet *)values;

- (void)addInfosObject:(Info *)value;
- (void)removeInfosObject:(Info *)value;
- (void)addInfos:(NSOrderedSet *)values;
- (void)removeInfos:(NSOrderedSet *)values;

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSOrderedSet *)values;
- (void)removeTags:(NSOrderedSet *)values;

@end
