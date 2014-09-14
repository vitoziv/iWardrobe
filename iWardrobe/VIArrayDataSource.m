//
//  VIArrayDataSource.m
//  VIReuseCollectionDemo
//
//  Created by Vito on 13-11-10.
//  Copyright (c) 2013年 Vito. All rights reserved.
//

#import "VIArrayDataSource.h"

@interface VIArrayDataSource ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) VITableViewCellConfigureBlock configureCellBlock;

@end

@implementation VIArrayDataSource

- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(VITableViewCellConfigureBlock)configureCellBlock {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _items = items;
    _cellIdentifier = cellIdentifier;
    _configureCellBlock = configureCellBlock;
    
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.items[indexPath.row];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];
    
    id item = [self itemAtIndexPath:indexPath];
    
    if (self.configureCellBlock) {
        self.configureCellBlock(cell, item);
    }
    
    return cell;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    if (self.configureCellBlock) {
        self.configureCellBlock(cell, item);
    }
    
    return cell;
}

@end
