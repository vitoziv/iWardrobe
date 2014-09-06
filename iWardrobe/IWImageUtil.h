//
//  IWImageUtil.h
//  iWardrobe
//
//  Created by Vito on 6/8/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^IWImageUtilSaveBlock)(NSError *error);

@interface IWImageUtil : NSObject

/**
 ** retrun imageName
 **/
+ (NSString *)saveImage:(UIImage *)image completion:(IWImageUtilSaveBlock)completion;

@end
