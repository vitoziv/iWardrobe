//
//  Info+Service.m
//  iWardrobe
//
//  Created by Vito on 11/30/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "Info+Service.h"

@implementation Info (Service)

+ (instancetype)insertWithTitle:(NSString *)title content:(NSString *)content inContext:(NSManagedObjectContext *)context
{
    Info *info = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    info.title = title;
    info.content = content;
    return info;
}

+ (NSString *)entityName
{
    return NSStringFromClass(self);
}

@end
