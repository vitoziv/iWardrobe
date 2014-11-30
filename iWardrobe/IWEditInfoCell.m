//
//  IWEditInfoCell.m
//  iWardrobe
//
//  Created by Vito on 11/19/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "IWEditInfoCell.h"
#import "InfoType+Service.h"

@interface IWEditInfoCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;


@end

@implementation IWEditInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithData:(NSDictionary *)data delegate:(id<IWEditInfoCellDelegate>)delegate
{
    NSString *title = data[kInfoTitleKey];
    NSString *content = data[kInfoContentKey];
    
    if (title.length > 0) {
        [self.titleButton setTitle:title forState:UIControlStateNormal];
    }
    self.contentTextField.text = content;
    self.delegate = delegate;
}

- (void)updateType:(NSString *)type
{
    [self.titleButton setTitle:type forState:UIControlStateNormal];
    [self.delegate editInfoCell:self didChangeType:type];
}

- (IBAction)chooseTypeAction:(id)sender {
    [self.delegate editInfoCellDidTapChooseType:self];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.delegate editInfoCell:self didChangeContent:textField.text];
}

@end
