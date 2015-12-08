//
//  ViewController.m
//  ILPMediaPicker
//
//  Created by Evgeniy Novikov on 10/22/15.
//
//

#import "ViewController.h"
#import "ILPMediaCollectionController.h"
#import "ILPALAssetsLibrary.h"
#import "ILPPHPhotoLibrary.h"

#import "ILPMediaItemCollectionController.h"
#import "ILPMediaGroupCollectionController.h"
#import "ILPMediaNavigationController.h"

static NSString * const kImagePickerTitle = @"Pick/Take An Image(s)";
static NSString * const kVideoPickerTitle = @"Pick/Capture A Video(s)";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *imagePickButton;
@property (weak, nonatomic) IBOutlet UIButton *videoPickButton;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray<UIImageView *> *imageViews;

@property (nonatomic, strong) ILPMediaNavigationController *nc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  //  ILPALAssetsLibrary *assetLibrary = [ILPALAssetsLibrary new];
    //id<ILPMediaLibrary> mediaLibrary = [ILPPHPhotoLibrary new];
    
   // NSLog(@"goodgroupscount: %ld", (long)[mediaLibrary numberOfGroups]);
    
    
    
    //[_imagePickButton setTitle:kImagePickerTitle forState:UIControlStateNormal];
    //[_videoPickButton setTitle:kVideoPickerTitle forState:UIControlStateNormal];
}

- (UINavigationController *)nc {
    if (!_nc) {
        _nc = [[ILPMediaNavigationController alloc] initWithMediaType:ILPMediaTypeImage withDisplayMode:ILPMediaDisplayModeGroup];
        _nc.selectedAssetsBlock = ^(NSArray<ILPMediaAsset *> *assets) {
            NSLog(@"number %@", @(assets.count));
           // UIImage *image = assets[0].image;
            self.imageViews[0].contentMode = UIViewContentModeScaleAspectFill;
            self.imageViews[0].image = assets[0].image;
        };
    }
    return _nc;
}

#pragma mark - Actions

- (IBAction)imagePickButtonDidTap:(UIButton *)sender {

    //ILPMediaGroupCollectionController *gcc = [[ILPMediaGroupCollectionController alloc] initWithMediaType:ILPMediaTypeImage];
    
    [self presentViewController:self.nc animated:YES completion:nil];
}

- (IBAction)videoPickButtonDidTap:(UIButton *)sender {
    
}

@end
