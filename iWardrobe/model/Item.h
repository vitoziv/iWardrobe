//
//  Item.h
//  iWardrobe
//
//  Created by Vito on 4/27/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Collocation, Favorite;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSDate * modifyDate;
@property (nonatomic, retain) NSSet *collocations;
@property (nonatomic, retain) Favorite *favorite;
@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addCollocationsObject:(Collocation *)value;
- (void)removeCollocationsObject:(Collocation *)value;
- (void)addCollocations:(NSSet *)values;
- (void)removeCollocations:(NSSet *)values;

@end
