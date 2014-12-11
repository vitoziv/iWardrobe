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

static NSString *const CellIdentifierKey = @"CellIdentifier";
static NSString *const SectionDataKey = @"SectionData";

@interface ItemDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) NSArray *data;

@end

@implementation ItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setupView];
    [self setupData];
}

- (void)setupView
{
    self.imageView.image = self.item.image;
}

- (void)setupData
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

@end
