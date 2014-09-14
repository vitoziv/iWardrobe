//
//  IWItemCollectionViewCell.m
//  iWardrobe
//
//  Created by Vito on 6/8/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "IWItemCollectionViewCell.h"
#import "IWItemTagCollectionViewCell.h"
#import "Item.h"
#import "Tag.h"

@interface IWItemCollectionViewCell () <UICollectionViewDataSource>

@property (strong, nonatomic) NSArray *tags;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UICollectionView *tagCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagCollectionViewHeightConstraint;

@end

@implementation IWItemCollectionViewCell

- (void)configureWithItem:(Item *)item
{
    self.tags = [[item.tags allObjects] sortedArrayUsingComparator:^NSComparisonResult(Tag *obj1, Tag *obj2) {
        return obj1.items.count > obj2.items.count ? NSOrderedDescending : NSOrderedAscending;
    }];
    self.imageView.image = item.image;
}

- (void)layoutSubviews
{
    self.tagCollectionViewHeightConstraint.constant = self.tagCollectionView.contentSize.height + 1;
}

- (CGSize)cellSize
{
    return CGSizeMake(self.bounds.size.width, 180);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemTagCell";
    IWItemTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell configureWithTag:self.tags[indexPath.row]];
    return cell;
}

@end
