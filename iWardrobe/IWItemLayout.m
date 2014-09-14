//
//  IWItemLayout.m
//  iWardrobe
//
//  Created by Vito on 9/13/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "IWItemLayout.h"

@implementation IWItemLayout

- (void)iwCommonInit
{
    self.sectionInset = UIEdgeInsetsMake(60, 10, 20, 10);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self iwCommonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self iwCommonInit];
    }
    
    return self;
}


@end
