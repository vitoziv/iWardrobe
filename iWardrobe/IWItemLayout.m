//
//  IWItemLayout.m
//  iWardrobe
//
//  Created by Vito on 9/13/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "IWItemLayout.h"

@implementation IWItemLayout

- (void)commonInit
{
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.sectionInset = UIEdgeInsetsMake(60, 10, 20, 10);
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWIthItemSize:(CGSize)size
{
    self = [self init];
    if (self) {
        self.itemSize = size;
    }
    return self;
}

@end
