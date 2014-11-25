//
//  NSFetchedResultsController+IWExtension.m
//  iWardrobe
//
//  Created by Vito on 11/25/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "NSFetchedResultsController+IWExtension.h"
#import "IWContextManager.h"

@implementation NSFetchedResultsController (IWExtension)

+ (instancetype)controllerForEntityName:(NSString *)entityName sortKey:(NSString *)sortKey fetchBatchSize:(NSInteger)batchSize
{
    NSManagedObjectContext *managedObjectContext = [IWContextManager mainContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:batchSize];
    
    NSFetchedResultsController *fetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:[NSString stringWithFormat:@"%@-list", entityName]];
    
    
    return fetchedResultsController;
}

@end
