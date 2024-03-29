//
//  IWContextManager.h
//  iWardrobe
//
//  Created by Vito on 5/18/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IWContextManager : NSObject

+ (instancetype)sharedInstance;

+ (void)saveContext;

+ (NSManagedObjectContext *)rootContext;
+ (NSManagedObjectContext *)mainContext;

+ (void)saveOnBackContext:(void(^)(NSManagedObjectContext *backgroundContext))handler;

@end
