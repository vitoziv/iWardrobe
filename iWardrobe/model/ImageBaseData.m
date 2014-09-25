//
//  ImageBaseData.m
//  iWardrobe
//
//  Created by Vito on 9/13/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "ImageBaseData.h"
#import "IWStringGenerator.h"
#import "IWImageUtil.h"
#import "IWContextManager.h"

@implementation ImageBaseData

@dynamic uid;
@dynamic name;
@dynamic imageName;
@dynamic note;
@dynamic imageMetaData;
@dynamic createDate;
@dynamic modifyDate;
@dynamic tempImage;

@dynamic tags;
@dynamic locations;

+ (instancetype)createWithEntityName:(NSString *)name image:(UIImage *)image imageMetaData:(NSDictionary *)metaData
{
    ImageBaseData *imageData = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:[IWContextManager sharedContext]];
    
    NSDate *newDate = [NSDate new];
    imageData.uid = [IWStringGenerator uniqueIDWithDate:newDate];
    imageData.createDate = newDate;
    imageData.modifyDate = newDate;
    imageData.imageMetaData = metaData;
    imageData.tempImage = image;
    
    NSString *imageName = [IWImageUtil saveImage:image
                                      completion:^(NSError *error) {
                                          if (error) {
                                              // TODO: need delete
                                              NSLog(@"save look error: %@", error);
                                          } else {
                                              NSLog(@"Image saved! imageName: %@", imageData.imageName);
                                          }
                                      }];
    imageData.imageName = imageName;
    return imageData;
}

@end

@implementation ImageBaseData (IWAccessory)

- (UIImage *)image
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/%@", IWDocumentDirectory, self.imageName];
    if ([fileManager fileExistsAtPath:path]) {
        return [UIImage imageWithContentsOfFile:path];
    } else {
        return self.tempImage;
    }
}

@end
