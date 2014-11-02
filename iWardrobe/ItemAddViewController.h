//
//  ItemAddViewController.h
//  iWardrobe
//
//  Created by Vito on 11/2/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemAddViewControllerDelegate;

@interface ItemAddViewController : UIViewController

@property (strong, nonatomic) NSDictionary *imageMetaDataInfo;

@property (weak, nonatomic) id<ItemAddViewControllerDelegate> delegate;

@end

@protocol ItemAddViewControllerDelegate <NSObject>

- (void)itemAddViewControllerDidSave:(ItemAddViewController *)viewController;
- (void)itemAddViewControllerDidCancel:(ItemAddViewController *)viewController;

@end
