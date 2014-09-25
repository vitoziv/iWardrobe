//
//  Item.h
//  iWardrobe
//
//  Created by Vito on 5/22/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageBaseData.h"

@class Location, Look, Tag;

@interface Item : ImageBaseData

@property (nonatomic, copy) NSString *brand;
@property (nonatomic, strong) NSDecimalNumber *price;
@property (nonatomic, strong) NSLocale *currencyLocale;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSSet *looks;

@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addLooksObject:(Look *)value;
- (void)removeLooksObject:(Look *)value;
- (void)addLooks:(NSSet *)values;
- (void)removeLooks:(NSSet *)values;

- (void)addLocationsObject:(Location *)value;
- (void)removeLocationsObject:(Location *)value;
- (void)addLocations:(NSSet *)values;
- (void)removeLocations:(NSSet *)values;

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
