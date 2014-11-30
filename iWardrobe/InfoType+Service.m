//
//  InfoType+Service.m
//  iWardrobe
//
//  Created by Vito on 11/20/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "InfoType+Service.h"
#import "NSFetchedResultsController+IWExtension.h"

NSString *const kInfoTitleKey = @"title";
NSString *const kInfoContentKey = @"content";

@implementation InfoType (Service)

+ (instancetype)insertWithName:(NSString *)name inContext:(NSManagedObjectContext *)context
{
    InfoType *infoType = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    
    infoType.type = name;
    
    return infoType;
}

+ (NSString *)entityName
{
    return @"InfoType";
}

+ (NSFetchedResultsController *)controllerForAllInfoTypes
{
    NSFetchedResultsController *fetchedResultsController = [NSFetchedResultsController controllerForEntityName:[self entityName] sortKey:@"type" fetchBatchSize:40];

    return fetchedResultsController;
}

@end
