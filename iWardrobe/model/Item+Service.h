//
//  Item+Service.h
//  iWardrobe
//
//  Created by Vito on 5/22/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "Item.h"

@interface Item (Service)

+ (instancetype)createLookWithImage:(UIImage *)image imageMetaData:(NSDictionary *)metaData;
+ (void)deleteItem:(Item *)item;

+ (NSArray *)itemsByTag:(Tag *)tag;
+ (NSArray *)allItems;

@end