//
//  Look+IW_Accessory.m
//  iWardrobe
//
//  Created by Vito on 9/6/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "Look+IW_Accessory.h"

@implementation Look (IW_Accessory)

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
