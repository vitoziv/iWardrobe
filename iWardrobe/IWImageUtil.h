//
//  IWImageUtil.h
//  iWardrobe
//
//  Created by Vito on 6/8/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IWImageUtil : NSObject

+ (void)saveImage:(UIImage *)image toLocalCompletion:(void(^)(NSString *imageName, NSError *error))completion;

@end
