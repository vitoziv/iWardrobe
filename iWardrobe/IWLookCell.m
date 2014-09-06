//
//  IWLookCell.m
//  iWardrobe
//
//  Created by Vito on 9/6/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "IWLookCell.h"
#import "Look+IW_Accessory.h"

@interface IWLookCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation IWLookCell

- (void)configureWithData:(Look *)look
{
    [self.indicatorView startAnimating];
    __block UIImage *image;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        image = look.image;
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.imageView.image = image;
            [self.indicatorView stopAnimating];
        });
    });
}

@end
