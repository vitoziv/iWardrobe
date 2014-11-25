//
//  ItemDetailViewController.m
//  iWardrobe
//
//  Created by Vito on 9/14/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "Item.h"
#import "IWStringInfoCell.h"

@interface ItemDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setupData];
}

- (void)setupData
{
    self.imageView.image = self.item.image;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.item.infos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *StringInfoCellIdentifier = @"StringInfoCell";
    IWStringInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:StringInfoCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *info = self.item.infos[indexPath.row];
    [cell configureWithInfo:info];
    
    return cell;
}

@end
