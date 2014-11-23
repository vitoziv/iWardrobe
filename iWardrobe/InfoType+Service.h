//
//  InfoType+Service.h
//  iWardrobe
//
//  Created by Vito on 11/20/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "InfoType.h"

extern NSString *const kInfoTypeKey;
extern NSString *const kInfoContentKey;

@interface InfoType (Service)

+ (instancetype)insertWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)controllerForAllInfoTypesWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate;

@end
