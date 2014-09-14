//
//  IWItemCollectionViewCell.m
//  iWardrobe
//
//  Created by Vito on 6/8/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "IWItemCollectionViewCell.h"
#import "Item.h"
#import "Tag.h"

@interface IWItemCollectionViewCell ()

@property (strong, nonatomic) NSArray *tags;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

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
    self.contentView.frame = self.bounds;
}

@end
