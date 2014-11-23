//
//  ChooseInfoTypeViewController.m
//  iWardrobe
//
//  Created by Vito on 11/20/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "ChooseInfoTypeViewController.h"
#import "InfoType+Service.h"
#import "IWFRCTableViewDelegate.h"
#import "IWContextManager.h"

@interface ChooseInfoTypeViewController ()

@property (strong, nonatomic) NSArray *infoTypes;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) IWFRCTableViewDelegate *fetchedResultsControllerDelegate;

@property (weak, nonatomic) IBOutlet UITextField *addTypeTextField;

@end

@implementation ChooseInfoTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Fetch infotypes
    self.fetchedResultsControllerDelegate = [[IWFRCTableViewDelegate alloc] initWithTableView:self.tableView];
    self.fetchedResultsController = [InfoType controllerForAllInfoTypesWithDelegate:self.fetchedResultsControllerDelegate];
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // TODO: Error handle
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
}

- (IBAction)doneAction:(id)sender {
    [self.delegate chooseInfoTypeViewController:self didChoosedType:self.addTypeTextField.text];
    // TODO: save new custom info type
    [IWContextManager saveOnBackContext:^(NSManagedObjectContext *backgroundContext) {
        [InfoType insertWithName:self.addTypeTextField.text inContext:backgroundContext];
    }];
}

- (IBAction)cancelAction:(id)sender {
    [self.delegate chooseInfoTypeViewControllerDidCancel:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id  sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *InfoTypeCellIdentifier = @"InfoType";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InfoTypeCellIdentifier forIndexPath:indexPath];
    InfoType *infoType = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = infoType.type;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoType *infoType = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate chooseInfoTypeViewController:self didChoosedType:infoType.type];
}

@end
