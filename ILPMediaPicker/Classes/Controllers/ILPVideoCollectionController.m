//
//  ILPVideoCollectionControllerViewController.m
//  ILPMediaPicker
//
//  Created by Evgeniy Novikov on 11/16/15.
//
//

#import "ILPVideoCollectionController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface ILPVideoCollectionController ()

@end

@implementation ILPVideoCollectionController

@synthesize delegate;
@synthesize imagePicker = _imagePicker;

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.title = @"Video Picker";
        self.blankImage = [UIImage imageNamed:@"blank_video"];
        self.addImage = [UIImage imageNamed:@"camcorder"];
        [self loadAssetsByType:ALAssetTypeVideo];
        
    }
    return self;
}

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = super.imagePicker;
        _imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    }
    return _imagePicker;
}

#pragma mark - ImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        if ([self.delegate respondsToSelector:@selector(videoCollectionController:didCaptureVideoWithUrl:)]) {
            NSURL *videoUrl = [info valueForKey:UIImagePickerControllerMediaURL];
            [self.delegate videoCollectionController:self didCaptureVideoWithUrl:videoUrl];
        }
    }
}

@end
