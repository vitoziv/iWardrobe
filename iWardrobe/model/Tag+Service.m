//
//  Tag+Service.m
//  iWardrobe
//
//  Created by Vito on 5/18/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "Tag+Service.h"
#import "NSFetchedResultsController+IWExtension.h"

NSString *const IWTableTag = @"Tag";
NSString *const IWTagName = @"name";
NSString *const IWTagId = @"tagId";

@implementation Tag (Service)

+ (NSString *)entityName
{
    return NSStringFromClass([self class]);
}

#pragma mark - Public

#pragma mark CURD

+ (Tag *)tagWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;
{
    Tag *tag = nil;
    NSError *error;
    NSArray *matches = [self fetchTagsWithName:name inContext:context error:&error];
    if (!matches || matches.count > 1) {
        // TODO: handle error
        NSLog(@"Tag Error: %@", error ? error : @"Too many tags with the same name.");
    } else if (matches.count == 0) {
        NSLog(@"Can not find a tag named: %@", name);
    } else {
        tag = [matches lastObject];
        tag.name = name;
    }
    
    return tag;
}

+ (Tag *)insertWithName:(NSString *)name inContext:(NSManagedObjectContext *)context
{
    Tag *tag = nil;
    NSError *error;
    NSArray *matches = [self fetchTagsWithName:name inContext:context error:&error];
    if (!matches || matches.count > 1) {
        // TODO: handle error
        NSLog( @"Tag Error: %@", error ? error : @"Too many tags with the same name.");
    } else if (matches.count == 0) {
        tag = [NSEntityDescription insertNewObjectForEntityForName:IWTableTag inManagedObjectContext:context];
        tag.name = name;
    } else {
        NSLog(@"Try to insert a new Tag, which already exist. Return the exist one.");
        tag = [matches lastObject];
        tag.name = name;
    }
    
    return tag;
}

+ (Tag *)updateWithTag:(Tag *)tag inContext:(NSManagedObjectContext *)context;
{
    Tag *newTag = (Tag *)[context objectWithID:tag.objectID];
    
    if (!newTag.isFault) {
        newTag.name = tag.name;
        newTag.looks = tag.looks;
        newTag.items = tag.items;
    } else {
        newTag = nil;
    }
    
    return newTag;
}

+ (void)deleteTag:(Tag *)tag inContext:(NSManagedObjectContext *)context
{
    [context deleteObject:tag];
}

+ (NSFetchedResultsController *)controllerForAllTags
{
    NSFetchedResultsController *fetchedResultsController = [NSFetchedResultsController controllerForEntityName:[self entityName] sortKey:@"name" fetchBatchSize:40];
    
    return fetchedResultsController;
}

#pragma mark Query

+ (NSArray *)tagListInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:IWTableTag];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Get tag list error: %@", error);
    }
    
    return matches;
}

#pragma mark - Private

+ (NSArray *)fetchTagsWithName:(NSString *)name inContext:(NSManagedObjectContext *)context error:(NSError **)error {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:IWTableTag];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSArray *matches = [context executeFetchRequest:request error:error];
    if (*error) {
        NSLog(@"fetch error: %@", *error);
    }
    return matches;
}

@end
