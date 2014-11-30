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

@property (nonatomic, strong) NSSet *looks;

@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addLooksObject:(Look *)value;
- (void)removeLooksObject:(Look *)value;
- (void)addLooks:(NSSet *)values;
- (void)removeLooks:(NSSet *)values;

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
