//
//  ChooseInfoTypeViewController.h
//  iWardrobe
//
//  Created by Vito on 11/20/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChooseInfoTypeViewController;

@protocol ChooseInfoTypeViewControllerDelegate <NSObject>

- (void)chooseInfoTypeViewControllerDidCancel:(ChooseInfoTypeViewController *)viewController;
- (void)chooseInfoTypeViewController:(ChooseInfoTypeViewController *)viewController didChoosedType:(NSString *)type;

@end

@interface ChooseInfoTypeViewController : UITableViewController

@property (weak, nonatomic) id<ChooseInfoTypeViewControllerDelegate> delegate;


@end
