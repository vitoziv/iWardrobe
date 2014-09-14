//
//  ItemTagCollectionViewCell.m
//  iWardrobe
//
//  Created by Vito on 9/13/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "IWItemTagCollectionViewCell.h"
#import "Tag.h"

@interface IWItemTagCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end

@implementation IWItemTagCollectionViewCell

- (void)configureWithTag:(Tag *)tag
{
    self.tagLabel.text = tag.name;
}

@end
