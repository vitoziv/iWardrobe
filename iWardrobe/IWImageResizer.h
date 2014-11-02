//
//  IWAssetThumbnailer.h
//  iWardrobe
//
//  Created by Vito on 6/23/14.
//  Copyright (c) 2014 Sumi Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAsset;

@interface IWImageResizer : NSObject

+ (UIImage *)thumbnailForAsset:(ALAsset *)asset maxPixelSize:(CGFloat)size;
+ (void)thumbnailForAsset:(ALAsset *)asset maxPixelSize:(CGFloat)size competion:(void(^)(UIImage *image))completion;
+ (void)thumbnailForAssetURL:(NSURL *)url maxPixelSize:(CGFloat)size completion:(void(^)(UIImage *image, NSError *error))completion;

+ (UIImage *)resizeImage:(UIImage *)image scaledToFitSize:(CGFloat)max;

@end
