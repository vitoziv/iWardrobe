//
//  VIArrayDataSource.h
//  VIReuseCollectionDemo
//
//  Created by Vito on 13-11-10.
//  Copyright (c) 2013年 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^VITableViewCellConfigureBlock)(id cell, id item);

@interface VIArrayDataSource : NSObject <UITableViewDataSource, UICollectionViewDataSource>

- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(VITableViewCellConfigureBlock)configureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
