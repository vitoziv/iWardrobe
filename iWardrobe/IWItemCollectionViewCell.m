//
//  IWItemCollectionViewCell.m
//  iWardrobe
//
//  Created by Vito on 6/8/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "IWItemCollectionViewCell.h"
#import "Item.h"

@interface IWItemCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation IWItemCollectionViewCell

- (void)configureWithItem:(Item *)item
{
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", IWDocumentDirectory, item.imagePath];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    self.imageView.image = image;
}

@end
