//
//  InfoType+Service.m
//  iWardrobe
//
//  Created by Vito on 11/20/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "InfoType+Service.h"
#import "IWContextManager.h"

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

+ (NSFetchedResultsController *)controllerForAllInfoTypesWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate
{
    NSManagedObjectContext *managedObjectContext = [IWContextManager mainContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:[InfoType entityName] inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:40];
    
    NSFetchedResultsController *fetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:@"infoTypes"];
    
    fetchedResultsController.delegate = delegate;

    return fetchedResultsController;
}

@end
