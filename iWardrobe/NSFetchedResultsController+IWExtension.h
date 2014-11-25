//
//  NSFetchedResultsController+IWExtension.h
//  iWardrobe
//
//  Created by Vito on 11/25/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchedResultsController (IWExtension)
+ (instancetype)controllerForEntityName:(NSString *)entityName sortKey:(NSString *)sortKey fetchBatchSize:(NSInteger)batchSize;
@end
