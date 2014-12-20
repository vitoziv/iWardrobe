//
//  IWStringInfoCell.h
//  iWardrobe
//
//  Created by Vito on 11/25/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWUndoProtocol.h"

@class Info;
@protocol IWStringInfoCellDelegate;

@interface IWStringInfoCell : UITableViewCell <IWUndoProtocol>

@property (weak, nonatomic) id<IWStringInfoCellDelegate> delegate;

- (void)configureWithInfo:(Info *)info;

@end


@protocol IWStringInfoCellDelegate <NSObject>

- (void)stringInfoCellDidChangeSize:(IWStringInfoCell *)cell;

@end