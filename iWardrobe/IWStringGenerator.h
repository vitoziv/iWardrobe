//
//  IWStringGenerator.h
//  iWardrobe
//
//  Created by Vito on 9/6/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IWStringGenerator : NSObject

/**
 ** Use UTC date to generate a uniqueID
 **/
+ (NSString *)uniqueIDWithDate:(NSDate *)date;

@end
