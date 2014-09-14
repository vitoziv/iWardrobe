//
//  ItemTagCollectionViewCell.h
//  iWardrobe
//
//  Created by Vito on 9/13/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tag;

@interface IWItemTagCollectionViewCell : UICollectionViewCell
- (void)configureWithTag:(Tag *)tag;
@end
