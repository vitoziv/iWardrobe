//
//  Tag+Service.h
//  iWardrobe
//
//  Created by Vito on 5/18/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "Tag.h"

extern NSString *const IWTableTag;
extern NSString *const IWTagName;

@interface Tag (Service)

+ (Tag *)insertWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;
+ (Tag *)tagWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;
+ (void)deleteTag:(Tag *)tag inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)controllerForAllTags;

+ (NSArray *)tagListInContext:(NSManagedObjectContext *)context;

@end
