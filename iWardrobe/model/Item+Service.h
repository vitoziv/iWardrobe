//
//  Item+Service.h
//  iWardrobe
//
//  Created by Vito on 5/22/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "Item.h"

@interface Item (Service)

+ (Item *)insertItemInContext:(NSManagedObjectContext *)context;
+ (void)deleteItem:(Item *)item inContext:(NSManagedObjectContext *)context;

+ (NSArray *)itemsByTag:(Tag *)tag inContext:(NSManagedObjectContext *)context;
+ (NSArray *)allItemsInContext:(NSManagedObjectContext *)context;

@end
