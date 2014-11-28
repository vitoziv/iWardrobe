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
        [tagIDs addObject:tag.objectID];
    }];
    [self.delegate chooseTagViewController:self didChooseTags:[tagIDs copy]];
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


@end
