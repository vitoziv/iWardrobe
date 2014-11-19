//
//  IWEditInfoCell.h
//  iWardrobe
//
//  Created by Vito on 11/19/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kEditInfoTitleKey;
extern NSString *const kEditInfoContentKey;

@interface IWEditInfoCell : UITableViewCell

- (void)configureWithData:(NSDictionary *)data;

@end
