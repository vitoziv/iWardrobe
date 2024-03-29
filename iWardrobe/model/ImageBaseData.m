//
//  ImageBaseData.m
//  iWardrobe
//
//  Created by Vito on 9/13/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "ImageBaseData.h"
#import "IWStringGenerator.h"
#import "IWImageConfigure.h"
#import "IWContextManager.h"

@implementation ImageBaseData

@dynamic uid;
@dynamic imageName;
@dynamic createDate;
@dynamic modifyDate;
@dynamic tempImage;
@dynamic infos;

@dynamic tags;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    NSDate *newDate = [NSDate new];
    self.createDate = newDate;
    self.modifyDate = newDate;
}

+ (instancetype)insertWithEntityName:(NSString *)name image:(UIImage *)image inContext:(NSManagedObjectContext *)context
{
    ImageBaseData *imageData = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:context];
    
    imageData.uid = [[NSProcessInfo processInfo] globallyUniqueString];
    imageData.tempImage = image;
    NSString *imageName = [IWImageConfigure saveImage:image
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
