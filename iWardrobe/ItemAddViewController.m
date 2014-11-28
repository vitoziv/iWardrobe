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

static NSString *const kCellIdentifierKey = @"CellIdentifier";

@interface ItemAddViewController () <IWEditInfoCellDelegate, ChooseInfoTypeViewControllerDelegate, ChooseTagControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;

@property (strong, nonatomic) NSMutableArray *datas;
@property (strong, nonatomic) NSMutableArray *infos;

@property (strong, nonatomic) NSArray *tags; // Tag list

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
        [self.infos removeLastObject];
        item.infos = self.infos;
        [self.tags enumerateObjectsUsingBlock:^(NSManagedObjectID *objectID, NSUInteger idx, BOOL *stop) {
            NSError *error;
            Tag *tag = (Tag *)[backgroundContext existingObjectWithID:objectID error:&error];
            if (!error) {
                [item addTagsObject:tag];
            } else {
                // TODO: Handle error
                NSLog(@"Get Tag from objectID: %@ error: %@", objectID, error);
            }
        }];
    }];
    
    [SVProgressHUD dismiss];
    [self.delegate itemAddViewControllerDidSave:self];
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
    return [self.datas[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *data = self.datas[indexPath.section][indexPath.row];
    UITableViewCell *cell;
    if (data[kCellIdentifierKey]) {
        cell = [tableView dequeueReusableCellWithIdentifier:data[kCellIdentifierKey] forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"EditInfo" forIndexPath:indexPath];
        IWEditInfoCell *editInfoCell = (IWEditInfoCell *)cell;
        [editInfoCell configureWithData:data delegate:self];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[IWAddInfoCell class]]) {
        NSDictionary *info = @{kInfoTypeKey: @"", kInfoContentKey: [NSString stringWithFormat:@"%ld", self.infos.count + 1]};
        [self.infos insertObject:info atIndex:self.infos.count - 1];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:(self.infos.count - 2) inSection:indexPath.section];
        [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    } else if ([cell isKindOfClass:[IWChooseTagCell class]]) {
        NSLog(@"choose tag");
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
    info[kInfoTypeKey] = type;
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

- (void)chooseTagViewController:(ChooseTagViewController *)viewController didChooseTags:(NSArray *)tags
{
    self.tags = tags;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setup

- (void)setupDatas
{
    self.datas = [NSMutableArray array];
    self.infos = [NSMutableArray array];
    [self.datas addObject:@[@{kCellIdentifierKey: @"ChooseTag"}]];
    [self.infos addObject:@{kCellIdentifierKey: @"AddInfo"}];
    [self.datas addObject:self.infos];
}


@end
