//
//  Item.h
//  iWardrobe
//
//  Created by Vito on 5/22/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location, Look, Tag;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSDate * modifyDate;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSSet *looks;
@property (nonatomic, retain) NSSet *locations;
@property (nonatomic, retain) NSSet *tags;
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
