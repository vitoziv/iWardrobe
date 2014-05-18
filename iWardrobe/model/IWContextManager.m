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

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
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

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    
    
    return _managedObjectContext;
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
