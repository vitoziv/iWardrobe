//
//  IWStringInfoCell.m
//  iWardrobe
//
//  Created by Vito on 11/25/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "IWStringInfoCell.h"
#import "Info.h"

@interface IWStringInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation IWStringInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithInfo:(Info *)info
{
    self.titleLabel.text = info.title;
    self.contentLabel.text = info.content;
}

@end
