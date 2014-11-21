//
//  IWFRCTableViewDelegate.h
//  iWardrobe
//
//  Created by Vito on 11/21/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface IWFRCTableViewDelegate : NSObject <NSFetchedResultsControllerDelegate>

- (instancetype)initWithTableView:(UITableView *)tableView;

@end
