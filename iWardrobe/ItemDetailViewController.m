//
//  ItemDetailViewController.m
//  iWardrobe
//
//  Created by Vito on 9/14/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "Item.h"
#import "Info.h"
#import "Tag.h"
#import "IWStringInfoCell.h"
#import "ChooseTagViewController.h"
#import "IWContextManager.h"

static NSString *const CellIdentifierKey = @"CellIdentifier";
static NSString *const SectionDataKey = @"SectionData";

@interface ItemDetailViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate,
ChooseTagControllerDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) NSArray *data;

@end

@implementation ItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self setupView];
    [self loadData];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    
    if (!editing) {
        // TODO: 保存改变
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ItemDetialEditTag"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        ChooseTagViewController *viewController = (ChooseTagViewController *)[navigationController.viewControllers lastObject];
        viewController.delegate = self;
        viewController.oldTags = [self.item.tags array];
    }
}

#pragma mark - Setup

- (void)setupView
{
    self.imageView.image = self.item.image;
}

- (void)loadData
{
    NSMutableString *tagString = [NSMutableString string];
    [self.item.tags enumerateObjectsUsingBlock:^(Tag *tag, NSUInteger idx, BOOL *stop) {
        [tagString appendString:[NSString stringWithFormat:@"%@  ", tag.name]];
    }];
    self.data = @[@{CellIdentifierKey: @"TagCell", SectionDataKey: @[[tagString copy]]}, @{CellIdentifierKey: @"StringInfoCell", SectionDataKey: self.item.infos}];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data[section][SectionDataKey] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = self.data[indexPath.section][CellIdentifierKey];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if ([CellIdentifier isEqualToString:@"TagCell"]) {
        NSString *tagString = [self.data[indexPath.section][SectionDataKey] lastObject];
        cell.textLabel.text = tagString;
    } else if ([CellIdentifier isEqualToString:@"StringInfoCell"]) {
        Info *info = self.data[indexPath.section][SectionDataKey][indexPath.row];
        [(IWStringInfoCell *)cell configureWithInfo:info];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selectionStyle == UITableViewCellSelectionStyleNone) {
        return nil;
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = self.data[indexPath.section][CellIdentifierKey];
    
    if ([CellIdentifier isEqualToString:@"TagCell"]) {
        [self performSegueWithIdentifier:@"ItemDetialEditTag" sender:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = self.data[indexPath.section][CellIdentifierKey];

    if ([CellIdentifier isEqualToString:@"TagCell"]) {
        return UITableViewCellEditingStyleNone;
    } else if ([CellIdentifier isEqualToString:@"StringInfoCell"]) {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

#pragma mark - 

- (void)chooseTagViewController:(ChooseTagViewController *)viewController didChooseTags:(NSArray *)tagIDs
{
    NSMutableOrderedSet *tags = [NSMutableOrderedSet orderedSet];
    [tagIDs enumerateObjectsUsingBlock:^(NSManagedObjectID *tagID, NSUInteger idx, BOOL *stop) {
        Tag *tag = (Tag *)[[IWContextManager mainContext] objectWithID:tagID];
        [tags addObject:tag];
    }];
    [self.item setTags:tags];
    [self loadData];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseTagViewControllerDidCancel:(ChooseTagViewController *)viewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
