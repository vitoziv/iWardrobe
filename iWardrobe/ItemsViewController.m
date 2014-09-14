//
//  ItemsViewController.m
//  iWardrobe
//
//  Created by Vito on 9/13/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "ItemsViewController.h"
#import "IWItemCollectionViewCell.h"
#import "Item+Service.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SVProgressHUD.h"
#import "IWItemLayout.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "ItemDetailViewController.h"

static NSString *kSegueIdentifierShowItemDetail = @"ShowItemDetail";

@interface ItemsViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
CHTCollectionViewDelegateWaterfallLayout,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *items;


@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation ItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDataCompletion:nil];
}


- (IBAction)backToItem:(UIStoryboardSegue*)sender
{
    NSLog(@"back to item");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueIdentifierShowItemDetail]) {
        ItemDetailViewController *viewController = segue.destinationViewController;
        viewController.item = sender;
    }
}

#pragma mark - Data

- (void)setupDataCompletion:(void(^)(void))completion
{
    __block NSArray *items = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        items = [Item allItems];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.items = items;
            [self.collectionView reloadData];
            if (completion) {
                completion();
            }
        });
    });
}

#pragma mark - UICollcetionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    IWItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    Item *item = self.items[indexPath.row];
    [cell configureWithItem:item];
    
    return cell;
}

#pragma mark - UICollectionViewDelgate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = self.items[indexPath.row];
    [self performSegueWithIdentifier:kSegueIdentifierShowItemDetail sender:item];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = self.items[indexPath.row];
    return item.image.size;
}


#pragma mark - Add

- (IBAction)addAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Add a look", @"Add a look photo from photolibrary or take a photo") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhotoAction =
    [UIAlertAction actionWithTitle:NSLocalizedString(@"Take Photo", nil)
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action) {
                               [self showImagePickerControllerWithType:UIImagePickerControllerSourceTypeCamera];
                           }];
    [alert addAction:takePhotoAction];
    
    UIAlertAction *photoLibraryAction =
    [UIAlertAction actionWithTitle:NSLocalizedString(@"Photo Library", nil)
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action) {
                               [self showImagePickerControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
                           }];
    [alert addAction:photoLibraryAction];
    
    UIAlertAction *cancelAction =
    [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                             style:UIAlertActionStyleCancel
                           handler:nil];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showImagePickerControllerWithType:(UIImagePickerControllerSourceType)type {
    if ([UIImagePickerController isSourceTypeAvailable:type]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerController.sourceType = type;
        imagePickerController.delegate = self;
        
        self.imagePickerController = imagePickerController;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        switch (type) {
            case UIImagePickerControllerSourceTypeCamera:
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Camera is unavailable!", nil)];
                break;
            case UIImagePickerControllerSourceTypePhotoLibrary:
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Photo library is unavailable!", nil)];
                break;
            case UIImagePickerControllerSourceTypeSavedPhotosAlbum:
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Photos album is unavailable!", nil)];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    void(^finishBlock)(NSDictionary *imageMetaData) = ^(NSDictionary *imageMetaData) {
        NSLog(@"finished");
        Item * item = [Item createLookWithImage:image imageMetaData:imageMetaData];
        NSMutableArray *items = [NSMutableArray arrayWithObject:item];
        [items addObjectsFromArray:self.items];
        self.items = items;
        
        // TODO: Refresh collection view, add item to collection view
        [self.collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
        } completion:nil];
    };
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        finishBlock(info[UIImagePickerControllerMediaMetadata]);
    } else {
        ALAssetsLibrary * lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL]
             resultBlock:^(ALAsset *asset) {
                 finishBlock(asset.defaultRepresentation.metadata);
             }
            failureBlock:nil];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
