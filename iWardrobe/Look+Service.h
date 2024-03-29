//
//  Look+Service.h
//  iWardrobe
//
//  Created by Vito on 9/6/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "Look.h"

@interface Look (Service)

+ (instancetype)createLookWithImage:(UIImage *)image imageMetaData:(NSDictionary *)metaData inContext:(NSManagedObjectContext *)context;
+ (NSArray *)allLooksInContext:(NSManagedObjectContext *)context;

@end
