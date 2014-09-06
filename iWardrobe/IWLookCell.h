//
//  IWLookCell.h
//  iWardrobe
//
//  Created by Vito on 9/6/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Look;

@interface IWLookCell : UICollectionViewCell

- (void)configureWithData:(Look *)look;

@end
