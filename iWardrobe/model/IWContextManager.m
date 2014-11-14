//
//  IWContextManager.m
//  iWardrobe
//
//  Created by Vito on 5/18/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "IWContextManager.h"
#import <CoreData/CoreData.h>

static NSString *const kModelStorePath = @"/WardrobeModel.sqlite";

@interface IWContextManager ()

@property (nonatomic, strong) NSManagedObjectContext *rootContext;
@property (nonatomic, strong) NSManagedObjectContext *mainContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation IWContextManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred;
    static id instance = nil;
    dispatch_once(&pred, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


+ (NSManagedObjectContext *)rootContext
{
    return [[self sharedInstance] rootContext];
}

+ (NSManagedObjectContext *)mainContext
{
    return [[self sharedInstance] mainContext];
}

+ (void)saveOnBackContext:(void(^)(NSManagedObjectContext *backgroundContext))handler
{
    NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    backgroundContext.parentContext = self.mainContext;
    
    [backgroundContext performBlock:^{
        if (handler) {
            handler(backgroundContext);
        }
        
        NSError *bgSaveError;
        // push to parent
        if (![backgroundContext save:&bgSaveError]) {
            NSLog(@"background save error: %@", bgSaveError);
        } else {
            NSLog(@"push to main context successed");
        }
        
        [self saveContext];
    }];
}

+ (void)saveContext
{
    NSManagedObjectContext *mainContext = [self mainContext];
    
    if (mainContext) {
        [mainContext performBlock:^{
            NSError *error;
            if (mainContext.hasChanges && ![mainContext save:&error]) {
                NSLog(@"save to main context error %@", error);
            } else {
                NSLog(@"push to root context successed");
            }
            
            NSManagedObjectContext *rootContext = [self rootContext];
            if (rootContext) {
                [rootContext performBlock:^{
                    NSError *rootError;
                    if (![rootContext save:&rootError]) {
                        NSLog(@"save root context error: %@", rootError);
                    } else {
                        NSLog(@"save to persistent store successed");
                    }
                }];
            }
        }];
    }
}

- (NSManagedObjectContext *)rootContext
{
    if (_rootContext) {
        return _rootContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator) {
        _rootContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _rootContext.persistentStoreCoordinator = coordinator;
    }
    
    
    return _rootContext;
}

- (NSManagedObjectContext *)mainContext
{
    if (_mainContext) {
        return  _mainContext;
    }
    
    _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _mainContext.parentContext = self.rootContext;
    
    return _mainContext;
}

- (NSManagedObjectContext *)backgroundContext
{
    NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    backgroundContext.parentContext = self.mainContext;
    
    return backgroundContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSString *path = [IWDocumentDirectory stringByAppendingString:kModelStorePath];
    NSURL *storeUrl = [NSURL fileURLWithPath:path isDirectory:NO];
    
    NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                              configuration:nil
                                                        URL:storeUrl
                                                    options:nil
                                                      error:&error];
    if (error) {
        NSLog(@"Create persistentStoreCoordinator unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"WardrobeModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    
    return _managedObjectModel;
}

@end
