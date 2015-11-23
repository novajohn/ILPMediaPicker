//
//  ViewController.m
//  ILPMediaPicker
//
//  Created by Evgeniy Novikov on 10/22/15.
//
//

#import "ViewController.h"
#import "ILPMediaPickerController.h"

static NSString * const kImagePickerTitle = @"Pick/Take An Image(s)";
static NSString * const kVideoPickerTitle = @"Pick/Capture A Video(s)";

@interface ViewController () <ILPMediaPickerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *imagePickButton;
@property (weak, nonatomic) IBOutlet UIButton *videoPickButton;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

@end

@implementation ViewController {
    ILPMediaPickerController *_imageMediaPicker, *_videoMediaPicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_imagePickButton setTitle:kImagePickerTitle forState:UIControlStateNormal];
    [_videoPickButton setTitle:kVideoPickerTitle forState:UIControlStateNormal];
}

#pragma mark - Actions

- (IBAction)imagePickButtonDidTap:(UIButton *)sender {
    //if (!_imageMediaPicker) {
        _imageMediaPicker = [ILPMediaPickerController imagePicker];
        _imageMediaPicker.title = kImagePickerTitle;
        _imageMediaPicker.itemsLimit = 3;
        _imageMediaPicker.delegate = self;
    //}
    [self presentViewController:_imageMediaPicker animated:YES completion:nil];
}

- (IBAction)videoPickButtonDidTap:(UIButton *)sender {
    if (!_videoMediaPicker) {
        _videoMediaPicker = [ILPMediaPickerController videoPicker];
        _videoMediaPicker.title = kVideoPickerTitle;
        _videoMediaPicker.delegate = self;
    }
    [self presentViewController:_videoMediaPicker animated:YES completion:nil];
}

#pragma mark - ILPMediaPickerDelegate

- (void)mediaPicker:(ILPMediaPickerController *)mediaPicker didTakePhoto:(UIImage *)photo {
   
}

- (void)mediaPicker:(ILPMediaPickerController *)mediaPicker didPickItems:(NSArray *)items {
    for (int i = 0; i < _imageViews.count; i++) {
        UIImageView *imageView = self.imageViews[i];
        ALAsset *asset = items[i];
        imageView.image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.opaque = NO;
    }
}

- (void)mediaPicker:(ILPMediaPickerController *)mediaPicker didCaptureVideoWithURL:(NSURL *)videoUrl {
    NSLog(@"catpured video url: %@", videoUrl);
}

@end
