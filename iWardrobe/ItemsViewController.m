//
//  ItemsViewController.m
//  iWardrobe
//
//  Created by Vito on 9/13/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "ItemsViewController.h"
#import "IWItemCell.h"
#import "Item+Service.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SVProgressHUD.h"
#import "IWItemLayout.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "ItemDetailViewController.h"
#import "ItemAddViewController.h"
#import "IWContextManager.h"
#import "IWFRCCollectionViewDelegate.h"

static NSString *kSegueIdentifierShowItemDetail = @"ShowItemDetail";
static NSString *kSegueIdentifierShowItemAdd = @"ShowItemAdd";

@interface ItemsViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
CHTCollectionViewDelegateWaterfallLayout,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
ItemAddViewControllerDelegate,
NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

// Datas
@property (strong, nonatomic) IWFRCCollectionViewDelegate *fetchedResultsControllerDelegate;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fetchedResultsControllerDelegate = [[IWFRCCollectionViewDelegate alloc] initWithCollectionView:self.collectionView];
    self.fetchedResultsController = [Item controllerForAllItemsWithDelegate:self.fetchedResultsControllerDelegate];
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // TODO: Error handle
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}


- (IBAction)backToItem:(UIStoryboardSegue*)sender
{

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueIdentifierShowItemDetail]) {
        ItemDetailViewController *viewController = segue.destinationViewController;
        viewController.item = sender;
    } else if ([segue.identifier isEqualToString:kSegueIdentifierShowItemAdd]) {
        ItemAddViewController *viewController = [[(UINavigationController *)segue.destinationViewController viewControllers] lastObject];
        viewController.imageMetaDataInfo = sender;
        viewController.delegate = self;
    }
}

#pragma mark - UICollcetionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id  sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    IWItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureWithItem:item];
    
    return cell;
}

#pragma mark - UICollectionViewDelgate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:kSegueIdentifierShowItemDetail sender:item];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:kSegueIdentifierShowItemAdd sender:info];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - ItemAddViewControllerDelegate

- (void)itemAddViewControllerDidSave:(ItemAddViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemAddViewControllerDidCancel:(ItemAddViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
