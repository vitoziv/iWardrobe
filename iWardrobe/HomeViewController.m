//
//  HomeViewController.m
//  iWardrobe
//
//  Created by Vito on 9/13/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)backToHome:(UIStoryboardSegue*)sender
{
    NSLog(@"back to home");
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
