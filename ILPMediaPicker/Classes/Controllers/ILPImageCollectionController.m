//
//  ILPPhotoCollectionController.m
//  ILPMediaPicker
//
//  Copyright © 2015 Evgeniy Novikov
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "ILPImageCollectionController.h"

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
