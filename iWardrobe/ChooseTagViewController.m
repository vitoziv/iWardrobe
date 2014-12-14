//
//  ChooseTagController.m
//  iWardrobe
//
//  Created by Vito on 11/25/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "ChooseTagViewController.h"
#import "IWFRCTableViewDelegate.h"
#import "Tag+Service.h"
#import "IWContextManager.h"

@interface ChooseTagViewController ()

@property (strong, nonatomic) NSArray *infoTypes;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) IWFRCTableViewDelegate *fetchedResultsControllerDelegate;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;

@end

@implementation ChooseTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fetchedResultsControllerDelegate = [[IWFRCTableViewDelegate alloc] initWithTableView:self.tableView];
    self.fetchedResultsController = [Tag controllerForAllTags];
    self.fetchedResultsController.delegate = self.fetchedResultsControllerDelegate;
    
    NSError *error;
    // TODO: Tag 的排序问题，在添加后保持在第一个 cell，并且状态为 selected
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"fetch tags error: %@", error);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNewTagAction:(id)sender {
    // TODO: 保存要处理重复的 tag 名
    // TODO: 删除 add 按钮，在编辑 tag 时直接对现有 tag 进行过滤，如果找不到编辑的 tag 名称就在下方显示添加新的 tag
    NSString *tagName = self.tagTextField.text;
    [IWContextManager saveOnBackContext:^(NSManagedObjectContext *backgroundContext) {
        [Tag insertWithName:tagName inContext:backgroundContext];
    }];
    self.tagTextField.text = @"";
}

- (IBAction)doneAction:(id)sender {
    // TODO: 对 done 按钮进行验证，如果没有选择任何 tag，就把 done 按钮设置为 enable = no
    
    NSMutableArray *tagIDs = [NSMutableArray array];
    [self.tableView.indexPathsForSelectedRows enumerateObjectsUsingBlock:^(NSIndexPath *obj, NSUInteger idx, BOOL *stop) {
        Tag *tag = [self.fetchedResultsController objectAtIndexPath:obj];
        if (tag.objectID.isTemporaryID) {
            NSError *error;
            [self.fetchedResultsController.managedObjectContext obtainPermanentIDsForObjects:@[tag] error:&error];
            if (error) {
                NSLog(@"Obtain permanent tag id error:%@", error);
            } else {
                [tagIDs addObject:tag.objectID];
            }
        } else {
            [tagIDs addObject:tag.objectID];
        }
    }];
    
    [self.delegate chooseTagViewController:self didChooseTags:[tagIDs copy]];
}

- (IBAction)cancelAction:(id)sender {
    [self.delegate chooseTagViewControllerDidCancel:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id  sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TagCellIdentifier = @"TagCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TagCellIdentifier forIndexPath:indexPath];
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = tag.name;
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.oldTags.count > 0) {
        Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if ([self.oldTags containsObject:tag]) {
            NSMutableArray *mutaOldTags = [self.oldTags mutableCopy];
            [mutaOldTags removeObject:tag];
            self.oldTags = [mutaOldTags copy];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.oldTags.count > 0) {
        Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if ([self.oldTags containsObject:tag]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        } else {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
}

@end
