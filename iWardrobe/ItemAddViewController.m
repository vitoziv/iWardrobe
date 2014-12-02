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
#import "InfoType+Service.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "IWContextManager.h"
#import "SVProgressHUD.h"
#import "IWAddInfoCell.h"
#import "IWEditInfoCell.h"
#import "IWChooseTagCell.h"
#import "ChooseInfoTypeViewController.h"
#import "ChooseTagViewController.h"
#import "Tag+Service.h"
#import "Info+Service.h"

static NSString *const kCellIdentifierKey = @"CellIdentifier";

@interface ItemAddViewController () <IWEditInfoCellDelegate, ChooseInfoTypeViewControllerDelegate, ChooseTagControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;

@property (strong, nonatomic) NSArray *datas;
@property (strong, nonatomic) NSMutableArray *infos;

@property (strong, nonatomic) NSArray *tagIDs; // Tags' objectID list

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

- (IBAction)backToItemAdd:(UIStoryboardSegue*)sender
{
    
}

- (IBAction)saveAction:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    [IWContextManager saveOnBackContext:^(NSManagedObjectContext *backgroundContext) {
        Item *item = [Item insertItemWithImage:self.itemImageView.image inContext:backgroundContext];
        
        // Create infos
        [self.infos enumerateObjectsUsingBlock:^(NSDictionary *infoDic, NSUInteger idx, BOOL *stop) {
            NSString *title = infoDic[kInfoTitleKey];
            NSString *content = infoDic[kInfoContentKey];
            
            Info *info = [Info insertWithTitle:title content:content inContext:backgroundContext];
            info.whichItem = item;
        }];
        
        // Create Tags
        [self.tagIDs enumerateObjectsUsingBlock:^(NSManagedObjectID *objectID, NSUInteger idx, BOOL *stop) {
            NSError *error;
            Tag *tag = (Tag *)[backgroundContext existingObjectWithID:objectID error:&error];
            if (!error) {
                [item addTagsObject:tag];
            } else {
                // TODO: Handle error
                NSLog(@"Get Tag from objectID: %@ error: %@", objectID, error);
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [SVProgressHUD dismiss];
            [self.delegate itemAddViewControllerDidSave:self];
        });
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ChooseInfoType"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        ChooseInfoTypeViewController *viewController = (ChooseInfoTypeViewController *)[navigationController.viewControllers lastObject];
        viewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"ChooseTag"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        ChooseTagViewController *viewController = (ChooseTagViewController *)[navigationController.viewControllers lastObject];
        viewController.delegate = self;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datas[section] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        // Tag cell
        if (indexPath.row < self.tagIDs.count) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"TagCell" forIndexPath:indexPath];
            NSManagedObjectID *tagID = self.tagIDs[indexPath.row];
            NSError *error;
            Tag *tag = (Tag *)[[IWContextManager mainContext] existingObjectWithID:tagID error:&error];
            if (error) {
                return nil;
            } else {
                cell.textLabel.text = tag.name;
            }
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseTag" forIndexPath:indexPath];
        }
    } else {
        if (indexPath.row < self.infos.count) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"EditInfo" forIndexPath:indexPath];
            IWEditInfoCell *editInfoCell = (IWEditInfoCell *)cell;
            [editInfoCell configureWithData:self.infos[indexPath.row] delegate:self];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"AddInfo" forIndexPath:indexPath];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[IWAddInfoCell class]]) {
        NSDictionary *info = @{kInfoTitleKey: @"", kInfoContentKey: [NSString stringWithFormat:@"%ld", self.infos.count]};
        [self.infos insertObject:info atIndex:self.infos.count];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.infos.count - 1 inSection:indexPath.section];
        [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    } else if ([cell isKindOfClass:[IWChooseTagCell class]]) {
        [self performSegueWithIdentifier:@"ChooseTag" sender:nil];
    }
}

#pragma mark - IWEditInfoCellDelegate

- (void)editInfoCellDidTapChooseType:(IWEditInfoCell *)cell
{
    self.editingCell = cell;
    [self performSegueWithIdentifier:@"ChooseInfoType" sender:nil];
}

- (void)editInfoCell:(IWEditInfoCell *)cell didChangeType:(NSString *)type
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *info = [self.infos[indexPath.row] mutableCopy];
    info[kInfoTitleKey] = type;
    self.infos[indexPath.row] = [info copy];
}

- (void)editInfoCell:(IWEditInfoCell *)cell didChangeContent:(NSString *)content
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *info = [self.infos[indexPath.row] mutableCopy];
    info[kInfoContentKey] = content;
    self.infos[indexPath.row] = [info copy];
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

#pragma mark - ChooseTagControllerDelegate

- (void)chooseTagViewController:(ChooseTagViewController *)viewController didChooseTags:(NSArray *)tagIDs
{
    self.tagIDs = tagIDs;
    self.datas = @[tagIDs, self.infos];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setup

- (void)setupDatas
{
    self.infos = [NSMutableArray array];
    self.tagIDs = [NSArray array];
    self.datas = @[self.tagIDs, self.infos];
}

@end
