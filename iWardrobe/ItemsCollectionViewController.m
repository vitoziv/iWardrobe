//
//  ItemsCollectionViewController.m
//  iWardrobe
//
//  Created by Vito on 4/27/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "ItemsCollectionViewController.h"
#import "IWItemCollectionViewCell.h"
#import "Item+Service.h"
#import "IWContextManager.h"
#import "IWImageUtil.h"
#import "SVProgressHUD.h"

@interface ItemsCollectionViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@property (strong, nonatomic) NSArray *items;

@end

@implementation ItemsCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.items = [Item allItemsInContext:[IWContextManager sharedContext]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addAction:(id)sender {
    [self showImagePickerControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
}


- (void)showImagePickerControllerWithType:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = type;
    imagePickerController.delegate = self;
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:NULL];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ItemCell";
    IWItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    Item *item = self.items[indexPath.row];
    [cell configureWithItem:item];
    
    return cell;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:NULL];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [IWImageUtil saveImage:image toLocalCompletion:^(NSString *imagePath, NSError *error) {
        if (error) {
            NSLog(@"Save image error: %@", error);
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Save image failed", nil)];
        } else {
            // Save new item
            Item *newItem = [Item insertItemInContext:[IWContextManager sharedContext]];
            newItem.imagePath = imagePath;
            
            // Update collection view data
            self.items = [Item allItemsInContext:[IWContextManager sharedContext]];
            [self.collectionView reloadData];
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
