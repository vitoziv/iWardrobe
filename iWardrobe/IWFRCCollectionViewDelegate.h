//
//  IWFRCDelegate.h
//  iWardrobe
//
//  Created by Vito on 11/17/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface IWFRCCollectionViewDelegate : NSObject <NSFetchedResultsControllerDelegate>
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;
@end
