//
//  IWStringInfoCell.m
//  iWardrobe
//
//  Created by Vito on 11/25/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "IWStringInfoCell.h"
#import "Info.h"

@interface IWStringInfoCell () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (strong, nonatomic) Info *info;

@end

@implementation IWStringInfoCell

- (void)awakeFromNib {
    // Initialization code
    
    self.contentTextView.textContainer.widthTracksTextView = YES;
}

- (void)setTextString:(NSString *)string
{
    self.contentTextView.text = string;
    [self textViewDidChange:self.contentTextView];
}

- (void)configureWithInfo:(Info *)info
{
    self.info = info;
    self.titleLabel.text = info.title;
    [self setTextString:info.content];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    self.selectionStyle = editing ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleBlue;
    
    self.titleButton.userInteractionEnabled = editing;
    self.contentTextView.userInteractionEnabled = editing;
}

#pragma mark - Action

- (IBAction)titleHighLightAction:(id)sender {
    self.titleLabel.highlighted = YES;
}

- (IBAction)titleUnhighLightAction:(id)sender {
    self.titleLabel.highlighted = NO;
}

- (IBAction)tapTitleAction:(id)sender {
    self.titleLabel.highlighted = NO;
}

- (void)undo
{
    self.titleLabel.text = self.info.title;
    [self setTextString:self.info.content];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    self.info.content = textView.text;
    
    CGRect bounds = textView.bounds;
    
    // Calculate the minimum size to contain our text
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    
    // Minimum size is 50
    newSize.height = MAX(50, newSize.height);
    
    bounds.size = newSize;
    textView.bounds = bounds;
    
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    
    return (UITableView *)tableView;
}

@end
