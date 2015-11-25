//
//  ILPVideoCollectionControllerViewController.m
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

#import "ILPVideoCollectionController.h"
#import <MobileCoreServices/UTCoreTypes.h>

static NSString * const kILPVideoPickerBlankImageName = @"blank_video";
static NSString * const kILPVideoPickerAddImageName   = @"camcorder";

@implementation ILPVideoCollectionController

@synthesize delegate;
@synthesize imagePicker = _imagePicker;

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.title = @"Video Picker";
        self.blankImage = [self.class mainBundleImageNamed:kILPVideoPickerBlankImageName];
        self.addImage   = [self.class mainBundleImageNamed:kILPVideoPickerAddImageName];
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
