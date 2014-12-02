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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.contentTextField];
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

#pragma mark - Notification

- (void)contentDidChange:(NSNotification *)notification
{
    [self.delegate editInfoCell:self didChangeContent:self.contentTextField.text];
}

@end
