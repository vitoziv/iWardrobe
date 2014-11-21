//
//  ItemAddViewController.m
//  iWardrobe
//
//  Created by Vito on 11/2/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "ItemAddViewController.h"
#import "IWImageResizer.h"
#import "IWImageConfigure.h"
#import "Item+Service.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "IWContextManager.h"
#import "SVProgressHUD.h"
#import "IWAddInfoCell.h"
#import "IWEditInfoCell.h"
#import "ChooseInfoTypeViewController.h"

static NSString *const kCellIdentifierKey = @"CellIdentifier";

@interface ItemAddViewController () <IWEditInfoCellDelegate, ChooseInfoTypeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;

@property (strong, nonatomic) NSMutableArray *datas;
@property (strong, nonatomic) NSMutableArray *infos;

@property (strong, nonatomic) IWEditInfoCell *editingCell;

@end

@implementation ItemAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        UIImage *image = [IWImageResizer resizeImage:self.imageMetaDataInfo[UIImagePickerControllerOriginalImage]
                                     scaledToFitSize:[IWImageConfigure sharedInstance].imageSaveSize.width];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.itemImageView.image = image;
        });
    });
    
    [self setupDatas];
}

- (IBAction)saveAction:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self fetchImageMetaDataCompletion:^(NSDictionary *metaData) {
        [IWContextManager saveOnBackContext:^(NSManagedObjectContext *backgroundContext) {
            Item *item = [Item insertItemWithImage:self.itemImageView.image imageMetaData:metaData inContext:backgroundContext];
            // TODO: Add Tags
            // TODO: Add info
        }];
        
        [SVProgressHUD dismiss];
        [self.delegate itemAddViewControllerDidSave:self];
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ChooseInfoType"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        ChooseInfoTypeViewController *viewController = (ChooseInfoTypeViewController *)[navigationController.viewControllers lastObject];
        viewController.delegate = self;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datas[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *data = self.datas[indexPath.section][indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:data[kCellIdentifierKey] forIndexPath:indexPath];
    if ([cell isKindOfClass:[IWEditInfoCell class]]) {
        IWEditInfoCell *editInfoCell = (IWEditInfoCell *)cell;
        [editInfoCell configureWithData:data delegate:self];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[IWAddInfoCell class]]) {
        [self.infos addObject:@{kCellIdentifierKey: @"EditInfo", kEditInfoTitleKey: @"", kEditInfoContentKey: [NSString stringWithFormat:@"%ld", self.infos.count + 1]}];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:(self.infos.count - 1) inSection:0];
        [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - IWEditInfoCellDelegate

- (void)editInfoCellDidTapChooseType:(IWEditInfoCell *)cell
{
    self.editingCell = cell;
    [self performSegueWithIdentifier:@"ChooseInfoType" sender:nil];
}

#pragma mark - ChooseInfoTypeViewControllerDelegate

- (void)chooseInfoTypeViewControllerDidCancel:(ChooseInfoTypeViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)chooseInfoTypeViewController:(ChooseInfoTypeViewController *)viewController didChoosedType:(NSString *)type
{
    [self.editingCell updateType:type];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setup

- (void)setupDatas
{
    self.datas = [NSMutableArray array];
    self.infos = [NSMutableArray array];
    [self.datas addObject:self.infos];
    [self.datas addObject:@[@{kCellIdentifierKey: @"AddInfo"}]];
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
