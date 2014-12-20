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
ChooseTagControllerDelegate,
IWStringInfoCellDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *doneBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *cancelBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *backBarButtonItem;

@property (strong, nonatomic) NSArray *data;

@end

@implementation ItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self setupView];
    [self loadData];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    if (editing) {
        self.navigationItem.leftBarButtonItem = self.cancelBarButtonItem;
        self.navigationItem.rightBarButtonItem = self.doneBarButtonItem;
        self.item.managedObjectContext.undoManager = [NSUndoManager new];
        [self.item.managedObjectContext.undoManager beginUndoGrouping];
    } else {
        self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
        self.navigationItem.rightBarButtonItem = self.editBarButtonItem;
        self.item.managedObjectContext.undoManager = nil;
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

#pragma mark - Action

- (IBAction)editAction:(id)sender {
    [self setEditing:YES animated:YES];
}

- (void)doneAction:(UIBarButtonItem *)sender
{
    [self setEditing:NO animated:YES];
    [IWContextManager saveContext];
}

- (void)cancelAction:(UIBarButtonItem *)sender
{
    [self.item.managedObjectContext.undoManager endUndoGrouping];
    [self.item.managedObjectContext.undoManager undo];
    
    [self.tableView.visibleCells enumerateObjectsUsingBlock:^(UITableViewCell<IWUndoProtocol> *obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(undo)]) {
            [obj undo];
        }
    }];
    
    [self setEditing:NO animated:YES];
}

#pragma mark - Setup

- (void)setupView
{
    self.imageView.image = self.item.image;
    
    self.doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                           target:self
                                                                           action:@selector(doneAction:)];
    self.cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                             target:self
                                                                             action:@selector(cancelAction:)];
    self.backBarButtonItem = self.navigationItem.leftBarButtonItem;
}

- (void)loadData
{
    NSMutableString *tagString = [NSMutableString string];
    [self.item.tags enumerateObjectsUsingBlock:^(Tag *tag, NSUInteger idx, BOOL *stop) {
        [tagString appendString:[NSString stringWithFormat:@"%@  ", tag.name]];
    }];
    self.data = @[@{CellIdentifierKey: @"TagCell", SectionDataKey: @[[tagString copy]]},
                  @{CellIdentifierKey: @"StringInfoCell", SectionDataKey: self.item.infos}];
                  
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
        [(IWStringInfoCell *)cell setDelegate:self];
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

#pragma mark - IWStringInfoCellDelegate

- (void)stringInfoCellDidChangeSize:(IWStringInfoCell *)cell
{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark - ChooseTagControllerDelegate

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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)chooseTagViewControllerDidCancel:(ChooseTagViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
