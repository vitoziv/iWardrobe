//
//  IWAssetThumbnailer.m
//  iWardrobe
//
//  Created by Vito on 6/23/14.
//  Copyright (c) 2014 Sumi Interactive. All rights reserved.
//

#import "IWImageResizer.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>

@implementation IWImageResizer

// Helper methods for thumbnailForAsset:maxPixelSize:
static size_t getAssetBytesCallback(void *info, void *buffer, off_t position, size_t count) {
    ALAssetRepresentation *rep = (__bridge id)info;
    
    NSError *error = nil;
    size_t countRead = [rep getBytes:(uint8_t *)buffer fromOffset:position length:count error:&error];
    
    if (countRead == 0 && error) {
        // We have no way of passing this info back to the caller, so we log it, at least.
        NSLog(@"thumbnailForAsset:maxPixelSize: got an error reading an asset: %@", error);
    }
    
    return countRead;
}

static void releaseAssetCallback(void *info) {
    // The info here is an ALAssetRepresentation which we CFRetain in thumbnailForAsset:maxPixelSize:.
    // This release balances that retain.
    CFRelease(info);
}

// Returns a UIImage for the given asset, with size length at most the passed size.
// The resulting UIImage will be already rotated to UIImageOrientationUp, so its CGImageRef
// can be used directly without additional rotation handling.
// This is done synchronously, so you should call this method on a background queue/thread.
+ (UIImage *)thumbnailForAsset:(ALAsset *)asset maxPixelSize:(CGFloat)size {
    NSParameterAssert(asset != nil);
    NSParameterAssert(size > 0);
    
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    
    CGDataProviderDirectCallbacks callbacks = {
        .version = 0,
        .getBytePointer = NULL,
        .releaseBytePointer = NULL,
        .getBytesAtPosition = getAssetBytesCallback,
        .releaseInfo = releaseAssetCallback,
    };
    
    CGDataProviderRef provider = CGDataProviderCreateDirect((void *)CFBridgingRetain(rep), [rep size], &callbacks);
    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);
    
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef) @{
                                                                                                      (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                                                                      (NSString *)kCGImageSourceThumbnailMaxPixelSize : @(size),
                                                                                                      (NSString *)kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                                                                      });
    CFRelease(source);
    CFRelease(provider);
    
    if (!imageRef) {
        return nil;
    }
    
    UIImage *toReturn = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    
    return toReturn;
}


+ (void)thumbnailForAsset:(ALAsset *)asset maxPixelSize:(CGFloat)size competion:(void(^)(UIImage *image))completion
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        UIImage *image = [self thumbnailForAsset:asset maxPixelSize:size];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(image);
            }
        });
    });
}

+ (void)thumbnailForAssetURL:(NSURL *)url maxPixelSize:(CGFloat)size completion:(void(^)(UIImage *image, NSError *error))completion
{
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        UIImage *image = [self thumbnailForAsset:asset maxPixelSize:size];
        if (completion) {completion(image, nil);};
    } failureBlock:^(NSError *err) {
        if (completion) {completion(nil, err);};
    }];
}

+ (UIImage *)resizeImage:(UIImage *)image scaledToFitSize:(CGFloat)max
{
    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    if (!imageSource)
        return nil;
    
    CFDictionaryRef options = (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                         (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailWithTransform,
                                                         (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailFromImageIfAbsent,
                                                         (id)[NSNumber numberWithFloat:max], (id)kCGImageSourceThumbnailMaxPixelSize,
                                                         nil];
    CGImageRef imgRef = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options);
    
    UIImage* scaled = [UIImage imageWithCGImage:imgRef];
    
    CGImageRelease(imgRef);
    CFRelease(imageSource);
    
    return scaled;
}

@end
