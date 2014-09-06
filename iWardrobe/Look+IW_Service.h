//
//  Look+IW_Service.h
//  iWardrobe
//
//  Created by Vito on 9/6/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "Look.h"

@interface Look (IW_Service)

+ (instancetype)newLookWithImage:(UIImage *)image inContext:(NSManagedObjectContext *)context;
+ (NSArray *)allLooksInContext:(NSManagedObjectContext *)context;

@end
