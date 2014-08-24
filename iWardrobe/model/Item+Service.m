//
//  Item+Service.m
//  iWardrobe
//
//  Created by Vito on 5/22/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "Item+Service.h"

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

+ (Item *)insertItemInContext:(NSManagedObjectContext *)context
{
    Item *newItem = [NSEntityDescription insertNewObjectForEntityForName:IWTableItem inManagedObjectContext:context];
    newItem.itemId = @"Unique ID";
    
    NSDate *currentDate = [NSDate date];
    newItem.createDate = currentDate;
    newItem.modifyDate = currentDate;
    
    return newItem;
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

#pragma mark - Private

+ (NSArray *)fetchTagsWithName:(NSString *)name inContext:(NSManagedObjectContext *)context error:(NSError **)error {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:IWTableItem];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSArray *matches = [context executeFetchRequest:request error:error];
    if (error) {
        NSLog(@"fetch error: %@", *error);
    }
    return matches;
}

@end
