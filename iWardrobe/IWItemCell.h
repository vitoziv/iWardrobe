//
//  IWItemCollectionViewCell.h
//  iWardrobe
//
//  Created by Vito on 6/8/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

@interface IWItemCell : UICollectionViewCell

- (void)configureWithItem:(Item *)item;

@end
