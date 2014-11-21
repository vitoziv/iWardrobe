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

@class IWEditInfoCell;

@protocol IWEditInfoCellDelegate <NSObject>

- (void)editInfoCellDidTapChooseType:(IWEditInfoCell *)cell;

@end

@interface IWEditInfoCell : UITableViewCell

@property (weak, nonatomic) id<IWEditInfoCellDelegate> delegate;

- (void)configureWithData:(NSDictionary *)data delegate:(id<IWEditInfoCellDelegate>)delegate;
- (void)updateType:(NSString *)type;

@end
