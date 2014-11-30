//
//  InfoType+Service.h
//  iWardrobe
//
//  Created by Vito on 11/20/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "InfoType.h"

extern NSString *const kInfoTitleKey;
extern NSString *const kInfoContentKey;

@interface InfoType (Service)

+ (instancetype)insertWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)controllerForAllInfoTypes;

@end
