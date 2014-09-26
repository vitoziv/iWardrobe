//
//  ItemDetailViewController.m
//  iWardrobe
//
//  Created by Vito on 9/14/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "Item.h"

@interface ItemDetailViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *tagsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *looksCollectionView;

@end

@implementation ItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupUI];
    [self setupData];
}

- (void)setupUI
{
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraint:rightConstraint];
}

- (void)setupData
{
    self.imageView.image = self.item.image;
    self.itemNameLabel.text = self.item.name;
    self.brandLabel.text = self.item.brand;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.item.currencyLocale];
    self.priceLabel.text = [numberFormatter stringFromNumber:self.item.price];
}

#pragma mark - UICollectionViewDataSource



@end
