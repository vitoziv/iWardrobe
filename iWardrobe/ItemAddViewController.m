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

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;

@end

@implementation ItemAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        UIImage *image = [IWImageResizer resizeImage:self.imageMetaDataInfo[UIImagePickerControllerOriginalImage]
                                     scaledToFitSize:[IWImageUtil sharedInstance].imageSaveSize.width];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.itemImageView.image = image;
        });
    });
}


- (IBAction)saveAction:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self fetchImageMetaDataCompletion:^(NSDictionary *metaData) {
        [IWContextManager saveOnBackContext:^(NSManagedObjectContext *backgroundContext) {
            Item *item = [Item createItemWithImage:self.itemImageView.image imageMetaData:metaData inContext:backgroundContext];
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
