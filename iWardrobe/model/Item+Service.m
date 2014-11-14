//
//  Item+Service.m
//  iWardrobe
//
//  Created by Vito on 5/22/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "Item+Service.h"
#import "IWStringGenerator.h"
#import "IWContextManager.h"

NSString *const IWTableItem = @"Item";

NSString *const IWItemId = @"itemId";
NSString *const IWItemBrand = @"brand";
NSString *const IWItemImagePath = @"imagePath";
NSString *const IWItemPrice = @"price";
NSString *const IWItemStatus = @"status";
NSString *const IWItemCreateDate = @"createDate";
NSString *const IWItemModifyDate = @"modifyDate";
NSString *const IWItemLooks = @"looks";
NSString *const IWItemLocations = @"locations";
NSString *const IWItemTags = @"tags";

@implementation Item (Service)

+ (NSArray *)itemsByTag:(Tag *)tag
{
    return [self itemsByTag:tag inContext:[IWContextManager mainContext]];
}

+ (NSArray *)allItems
{
    return [self allItemsInContext:[IWContextManager mainContext]];
}

+ (instancetype)createItemWithImage:(UIImage *)image imageMetaData:(NSDictionary *)metaData inContext:(NSManagedObjectContext *)context
{
    return [self createWithEntityName:IWTableItem image:image imageMetaData:metaData inContext:context];
}

+ (NSArray *)itemsByTag:(Tag *)tag inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:IWTableItem];
    request.predicate = [NSPredicate predicateWithFormat:@"tags contains[c] %@", tag];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches) {
        NSLog(@"Fetch items error: %@", error);
    }
    
    return matches;
}

+ (void)deleteItem:(Item *)item inContext:(NSManagedObjectContext *)context
{
    [context deleteObject:item];
}

+ (NSArray *)allItemsInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:IWTableItem];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:IWItemCreateDate ascending:NO];
    [request setSortDescriptors:@[sort]];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches) {
        NSLog(@"Fetch all items error: %@", error);
    }
    
    return matches;
}

@end
