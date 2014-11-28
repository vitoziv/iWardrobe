//
//  IWTagCell.m
//  iWardrobe
//
//  Created by Vito on 11/28/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "IWTagCell.h"

@implementation IWTagCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

@end
