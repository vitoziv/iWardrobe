//
//  IWImageUtil.m
//  iWardrobe
//
//  Created by Vito on 6/8/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "IWImageUtil.h"
#import "DFDateFormatterFactory.h"

static NSString *const kImageSaveSizeKey = @"kImageSaveSizeKey";

@interface IWImageUtil ()

@property (nonatomic) CGSize imageSaveSize;

@end

@implementation IWImageUtil

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred;
    static IWImageUtil *instance = nil;
    dispatch_once(&pred, ^{
        instance = [[self alloc] init];
        NSString *sizeString = [[NSUserDefaults standardUserDefaults] objectForKey:kImageSaveSizeKey];
        if (sizeString) {
            instance.imageSaveSize = CGSizeFromString(sizeString);
        } else {
            instance.imageSaveSize = CGSizeMake(1600, 1600);
            [instance saveImageSizeWithType:ImageSizeTypeNormal];
        }
    });
    return instance;
}

- (void)saveImageSizeWithType:(ImageSizeType)type
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    switch (type) {
        case ImageSizeTypeSmall:
            [userDefault setObject:NSStringFromCGSize(CGSizeMake(1024, 1024)) forKey:kImageSaveSizeKey];
            break;
        case ImageSizeTypeNormal:
            [userDefault setObject:NSStringFromCGSize(CGSizeMake(1600, 1600)) forKey:kImageSaveSizeKey];
            break;
        case ImageSizeTypeLarge:
            [userDefault setObject:NSStringFromCGSize(CGSizeMake(2048, 2048)) forKey:kImageSaveSizeKey];
            break;
            
        default:
            break;
    }
}

+ (NSString *)saveImage:(UIImage *)image completion:(IWImageUtilSaveBlock)completion
{
    NSString *imageName = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *path = [IWDocumentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", imageName]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSError *error;
        [UIImageJPEGRepresentation(image, 0.8) writeToFile:path options:NSDataWritingAtomic error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (completion) {
                completion(error);
            }
        });
    });
    
    return imageName;
}

@end
