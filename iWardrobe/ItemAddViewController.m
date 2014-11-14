//
//  ItemAddViewController.m
//  iWardrobe
//
//  Created by Vito on 11/2/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "ItemAddViewController.h"
#import "IWImageResizer.h"
#import "IWImageUtil.h"
#import "Item+Service.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "IWContextManager.h"
#import "SVProgressHUD.h"

@interface ItemAddViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *brandTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *tagsCollectionView;

@end

@implementation ItemAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        UIImage *image = [IWImageResizer resizeImage:self.imageMetaDataInfo[UIImagePickerControllerOriginalImage]
                                     scaledToFitSize:[IWImageUtil sharedInstance].imageSaveSize.width];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.itemImageView.image = image;
        });
    });
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

- (IBAction)saveAction:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self fetchImageMetaDataCompletion:^(NSDictionary *metaData) {
        [IWContextManager saveOnBackContext:^(NSManagedObjectContext *backgroundContext) {
            Item *item = [Item createItemWithImage:self.itemImageView.image imageMetaData:metaData inContext:backgroundContext];
            item.name = self.nameTextField.text;
            item.brand = self.brandTextField.text;
            item.price = [NSDecimalNumber decimalNumberWithString:self.priceTextField.text];
            // TODO: Add Tags
        }];
        
        [SVProgressHUD dismiss];
        [self.delegate itemAddViewControllerDidSave:self];
    }];
}

#pragma mark - Helper

- (void)fetchImageMetaDataCompletion:(void(^)(NSDictionary *metaData))completion
{
    NSDictionary *imageMetaData = self.imageMetaDataInfo[UIImagePickerControllerMediaMetadata];
    if (imageMetaData) {
        if (completion) {
            completion(imageMetaData);
        }
    } else {
        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:self.imageMetaDataInfo[UIImagePickerControllerReferenceURL]
             resultBlock:^(ALAsset *asset) {
                 dispatch_async(dispatch_get_main_queue(), ^(void) {
                     if (completion) {
                         completion(asset.defaultRepresentation.metadata);
                     }
                 });
             }
            failureBlock:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    if (completion) {
                        completion(nil);
                    }
                });
            }];
    }
}

@end
