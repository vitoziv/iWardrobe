//
//  IWEditInfoCell.h
//  iWardrobe
//
//  Created by Vito on 11/19/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IWEditInfoCell;

@protocol IWEditInfoCellDelegate <NSObject>

- (void)editInfoCellDidTapChooseType:(IWEditInfoCell *)cell;

- (void)editInfoCell:(IWEditInfoCell *)cell didChangeType:(NSString *)type;
- (void)editInfoCell:(IWEditInfoCell *)cell didChangeContent:(NSString *)content;

@end

@interface IWEditInfoCell : UITableViewCell

@property (weak, nonatomic) id<IWEditInfoCellDelegate> delegate;

- (void)configureWithData:(NSDictionary *)data delegate:(id<IWEditInfoCellDelegate>)delegate;
- (void)updateType:(NSString *)type;

@end
