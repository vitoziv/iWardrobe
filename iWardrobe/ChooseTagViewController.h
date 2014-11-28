//
//  ChooseTagController.h
//  iWardrobe
//
//  Created by Vito on 11/25/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseTagControllerDelegate;

@interface ChooseTagViewController : UITableViewController

@property (weak, nonatomic) id<ChooseTagControllerDelegate> delegate;

@end


@protocol ChooseTagControllerDelegate <NSObject>

- (void)chooseTagViewController:(ChooseTagViewController *)viewController didChooseTags:(NSArray *)tagIDs;

@end
