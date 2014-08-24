//
//  AddViewController.m
//  iWardrobe
//
//  Created by Vito on 4/27/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "AddViewController.h"
#import "SVProgressHUD.h"

@interface AddViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation AddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showImagePickerControllerWithType:(UIImagePickerControllerSourceType)type {
    if ([UIImagePickerController isSourceTypeAvailable:type]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerController.sourceType = type;
        imagePickerController.delegate = self;
        
        self.imagePickerController = imagePickerController;
        [self presentViewController:self.imagePickerController animated:YES completion:NULL];
        [self showViewController:self.imagePickerController sender:self];
    } else {
        switch (type) {
            case UIImagePickerControllerSourceTypeCamera:
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Camera is unavailable!", nil)];
                break;
            case UIImagePickerControllerSourceTypePhotoLibrary:
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Photo library is unavailable!", nil)];
                break;
            case UIImagePickerControllerSourceTypeSavedPhotosAlbum:
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Photos album is unavailable!", nil)];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Actions

- (IBAction)cameraAction:(id)sender {
    [self showImagePickerControllerWithType:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)photoAlbumAction:(id)sender {
    [self showImagePickerControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:NULL];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self.imageView setImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
