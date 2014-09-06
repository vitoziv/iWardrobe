//
//  Look.h
//  iWardrobe
//
//  Created by Vito on 5/22/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item, Location, Tag;

@interface Look : NSManagedObject

@property (nonatomic, retain) NSString * lookId;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSDictionary *imageMetaData;
@property (nonatomic, retain) UIImage * tempImage;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSDate * modifyDate;
@property (nonatomic, retain) NSSet *itemLocations;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) NSSet *tags;
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
