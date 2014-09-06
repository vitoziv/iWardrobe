//
//  LooksViewController.m
//  iWardrobe
//
//  Created by Vito on 9/6/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "LooksViewController.h"
#import "SVProgressHUD.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Look+IW_Service.h"
#import "IWLookCell.h"

@interface LooksViewController ()
<UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSArray *looksData;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation LooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block NSArray *datas;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        datas = [Look allLooksInContext:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.looksData = datas;
            [self.collectionView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
        // TODO: Save image
        Look * look = [Look saveLookWithImage:image imageMetaData:imageMetaData inContext:nil];
        NSMutableArray *looksData = [NSMutableArray arrayWithObject:look];
        [looksData addObjectsFromArray:self.looksData];
        self.looksData = looksData;
        
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

#pragma mark - Collection View

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.looksData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *CellIdentifier = @"Look Cell";
    IWLookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell configureWithData:self.looksData[indexPath.item]];
    
    return cell;
}

@end
