//
//  Look+Service.m
//  iWardrobe
//
//  Created by Vito on 9/6/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "Look+Service.h"
#import "IWStringGenerator.h"
#import "IWImageConfigure.h"
#import "IWContextManager.h"

NSString *const IWTableLook = @"Look";
NSString *const IWLookCreateDate = @"createDate";

@implementation Look (Service)

+ (instancetype)createLookWithImage:(UIImage *)image imageMetaData:(NSDictionary *)metaData inContext:(NSManagedObjectContext *)context
{
    if (!context) {
        context = [IWContextManager mainContext];
    }
    Look *look = [NSEntityDescription insertNewObjectForEntityForName:IWTableLook inManagedObjectContext:context];
    
    NSDate *newDate = [NSDate new];
    look.uid = [IWStringGenerator uniqueIDWithDate:newDate];
    look.createDate = newDate;
    look.modifyDate = newDate;
    look.tempImage = image;
    
    NSString *imageName = [IWImageConfigure saveImage:image
                                           completion:^(NSError *error) {
                                               if (error) {
                                                   // TODO: need delete
                                                   NSLog(@"save look error: %@", error);
                                               } else {
                                                   NSLog(@"Image saved! imageName: %@", look.imageName);
                                               }
                                           }];
    look.imageName = imageName;
    
    return look;
}

+ (NSArray *)allLooksInContext:(NSManagedObjectContext *)context
{
    if (!context) {
        context = [IWContextManager mainContext];
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:IWTableLook];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:IWLookCreateDate ascending:NO];
    request.sortDescriptors = @[sort];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Get look list error: %@", error);
    }
    
    return result;
}

@end
