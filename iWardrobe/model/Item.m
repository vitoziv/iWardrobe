//
//  Item.m
//  iWardrobe
//
//  Created by Vito on 5/22/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "Item.h"

@implementation Item

@dynamic looks;


- (void)addTagsObject:(Tag *)value
{
    NSMutableOrderedSet *tags = [NSMutableOrderedSet orderedSetWithOrderedSet:self.tags];
    [tags addObject:value];
    self.tags = tags;
}

@end
