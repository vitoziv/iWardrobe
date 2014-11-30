//
//  Info+Service.h
//  iWardrobe
//
//  Created by Vito on 11/30/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "Info.h"

@interface Info (Service)

+ (instancetype)insertWithTitle:(NSString *)title content:(NSString *)content inContext:(NSManagedObjectContext *)context;

@end
