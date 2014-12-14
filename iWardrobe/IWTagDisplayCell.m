//
//  IWTagDisplayCell.m
//  iWardrobe
//
//  Created by Vito on 12/14/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "IWTagDisplayCell.h"

@implementation IWTagDisplayCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
//    [super setEditing:editing animated:animated];
    
    self.accessoryType = editing ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    self.selectionStyle = editing ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
}

@end
