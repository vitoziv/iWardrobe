//
//  IWStringGenerator.m
//  iWardrobe
//
//  Created by Vito on 9/6/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "IWStringGenerator.h"
#import "DFDateFormatterFactory.h"

@implementation IWStringGenerator

+ (NSString *)uniqueIDWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[DFDateFormatterFactory sharedFactory] dateFormatterWithFormat:@"yyyyMMddHHmmss.SSS"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    formatter.timeZone = timeZone;
    
    return [formatter stringFromDate:date];
}

@end
