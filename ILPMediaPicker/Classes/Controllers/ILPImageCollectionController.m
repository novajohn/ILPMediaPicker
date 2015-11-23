//
//  ILPPhotoCollectionController.m
//  ILPMediaPicker
//
//  Created by Evgeniy Novikov on 11/6/15.
//
//

#import "ILPImageCollectionController.h"
#import "ILPMediaPicker.h"

static NSString * const kILPImagePickeBlankImageName = @"blank_image";
static NSString * const kILPImagePickerAddImageName  = @"camera";

@implementation ILPImageCollectionController

@synthesize delegate;
@synthesize imagePicker = _imagePicker;

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.title = @"Pick an image";
        self.blankImage = [self.class mainBundleImageNamed:kILPImagePickeBlankImageName];
        self.addImage   = [self.class mainBundleImageNamed:kILPImagePickerAddImageName];
        [self loadAssetsByType:ALAssetTypePhoto];
    }
    return self;
}

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = super.imagePicker;
        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    }
    return _imagePicker;
}

#pragma mark - ImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    if ([self.delegate respondsToSelector:@selector(imageCollectionController:didTakePhoto:)]) {
        [self.delegate imageCollectionController:self didTakePhoto:image];
    }
}

@end
