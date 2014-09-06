//
//  Look+IW_Service.m
//  iWardrobe
//
//  Created by Vito on 9/6/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "Look+IW_Service.h"
#import "IWStringGenerator.h"

NSString *const IWTableLook = @"Look";

@implementation Look (IW_Service)

+ (instancetype)newLookWithImage:(UIImage *)image inContext:(NSManagedObjectContext *)context
{
    Look *look = [NSEntityDescription insertNewObjectForEntityForName:IWTableLook inManagedObjectContext:context];
    
    NSDate *newDate = [NSDate new];
    look.lookId = [IWStringGenerator uniqueIDWithDate:newDate];
    look.createDate = newDate;
    look.modifyDate = newDate;
    
    return look;
}

+ (NSArray *)allLooksInContext:(NSManagedObjectContext *)context
{
    return nil;
}

@end
