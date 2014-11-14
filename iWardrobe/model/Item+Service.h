//
//  Item+Service.h
//  iWardrobe
//
//  Created by Vito on 5/22/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "Item.h"

@interface Item (Service)

+ (instancetype)createItemWithImage:(UIImage *)image imageMetaData:(NSDictionary *)metaData inContext:(NSManagedObjectContext *)context;
+ (void)deleteItem:(Item *)item inContext:(NSManagedObjectContext *)context;

+ (NSArray *)itemsByTag:(Tag *)tag;
+ (NSArray *)allItems;

@end