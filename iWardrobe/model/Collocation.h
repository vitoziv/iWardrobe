//
//  Collocation.h
//  iWardrobe
//
//  Created by Vito on 4/27/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Favorite, Item;

@interface Collocation : NSManagedObject

@property (nonatomic, retain) NSString * collocationId;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSString * coverImageUrl;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSDate * modifyDate;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) Favorite *favorite;
@end

@interface Collocation (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
