//
//  IWImageUtil.h
//  iWardrobe
//
//  Created by Vito on 6/8/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ImageSizeType) {
    ImageSizeTypeSmall = 0,
    ImageSizeTypeNormal,
    ImageSizeTypeLarge
};

typedef void(^IWImageUtilSaveBlock)(NSError *error);

@interface IWImageUtil : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) CGSize imageSaveSize;

- (void)saveImageSizeWithType:(ImageSizeType)type;

/**
 ** retrun imageName
 **/
+ (NSString *)saveImage:(UIImage *)image completion:(IWImageUtilSaveBlock)completion;

@end
