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
#import "ItemAddViewController.h"
#import "IWContextManager.h"

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
//@property (nonatomic, strong) NSArray *items;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSMutableArray *sectionChanges;
@property (strong, nonatomic) NSMutableArray *itemChanges;

@end

@implementation ItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setupDataCompletion:^{
//        [self.collectionView reloadData];
//    }];
//    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
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
    } else if ([segue.identifier isEqualToString:kSegueIdentifierShowItemAdd]) {
        ItemAddViewController *viewController = segue.destinationViewController;
        viewController.imageMetaDataInfo = sender;
        viewController.delegate = self;
    }
}

#pragma mark - Data

//- (void)setupDataCompletion:(void(^)(void))completion
//{
//    __block NSArray *items = nil;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//        items = [Item allItems];
//        
//        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            self.items = items;
//            if (completion) {
//                completion();
//            }
//        });
//    });
//}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSManagedObjectContext *managedObjectContext = [IWContextManager mainContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

#pragma mark - UICollcetionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return self.items.count;
    id  sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    IWItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
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
//    [self setupDataCompletion:^{
//        [self.collectionView performBatchUpdates:^{
//            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
//        } completion:nil];
//    }];
}

- (void)itemAddViewControllerDidCancel:(ItemAddViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - NSFetchResultControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    self.sectionChanges = [[NSMutableArray alloc] init];
    self.itemChanges = [[NSMutableArray alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    change[@(type)] = @(sectionIndex);
    [self.sectionChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
        default:
            break;
    }
    [self.itemChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionView performBatchUpdates:^{
        for (NSDictionary *change in self.sectionChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert:
                        [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                    case NSFetchedResultsChangeDelete:
                        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                    default:
                        break;
                }
            }];
        }
        for (NSDictionary *change in self.itemChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert:
                        [self.collectionView insertItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeDelete:
                        [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeUpdate:
                        [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeMove:
                        [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                        break;
                    default:
                        break;
                }
            }];
        }
    } completion:^(BOOL finished) {
        self.sectionChanges = nil;
        self.itemChanges = nil;
    }];
}
@end
