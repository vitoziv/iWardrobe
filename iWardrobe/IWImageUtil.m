//
//  IWImageUtil.m
//  iWardrobe
//
//  Created by Vito on 6/8/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "IWImageUtil.h"
#import "DFDateFormatterFactory.h"

@implementation IWImageUtil

+ (NSString *)saveImage:(UIImage *)image completion:(IWImageUtilSaveBlock)completion
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[DFDateFormatterFactory sharedFactory] dateFormatterWithFormat:@"yyyyMMdd-HHmmss.SSS"];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [formatter stringFromDate:date]];
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
