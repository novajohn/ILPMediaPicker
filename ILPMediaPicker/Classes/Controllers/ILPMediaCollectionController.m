//
//  ILPMediaCollectionController.m
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


#import "ILPMediaCollectionController.h"
#import "ILPMediaLibrary.h"
#import "ILPPHPhotoLibrary.h"
#import "ILPALAssetsLibrary.h"

static NSString * const kILPMediaPickerCellNibName           = @"ILPMediaPickerCell";
static NSString * const kILPMediaPickerCellReuseIdentifier   = @"ilpMediaPickerCell";
static NSString * const kILPMediaPickerAddCellNibName        = @"ILPMediaPickerAddCell";
static NSString * const kILPMediaPickerAddCellReuseInetifier = @"ilpMediaPickerAddCell";

static NSString *const kILPMediaPickerDefaultTitle = @"Media Item Picker";

@interface ILPMediaCollectionController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) ILPMediaType mediaType;

@property (nonatomic, strong) UIBarButtonItem *cancelBarButton;

@end

@implementation ILPMediaCollectionController

@dynamic collectionViewLayout;
@dynamic delegate;

+ (NSBundle *)mainBundle {
    static NSBundle *mainBundle = nil;
    if (!mainBundle) {
        NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [classBundle URLForResource:kILPMediaPickerBundleName withExtension:@"bundle"];
        mainBundle = [NSBundle bundleWithURL:url];
    }
    return mainBundle;
}

+ (UIImage *)mainBundleImageNamed:(NSString *)anImageName {
    UIImage *image = [UIImage imageNamed:anImageName inBundle:[self mainBundle] compatibleWithTraitCollection:nil];
    return image;
}

- (instancetype)init {
    return [self initWithMediaType:ILPMediaTypeAll];
}

- (instancetype)initWithMediaType:(ILPMediaType)mediaType {
    return [self initWithMediaType:mediaType withSelectedAssetsBlock:nil];
}

- (instancetype)initWithMediaType:(ILPMediaType)mediaType withSelectedAssetsBlock:(ILPMediaSelectedAssetsBlock)block {
    self = [super initWithCollectionViewLayout:[ILPMediaCollectionFlowLayot new]];
    if (self) {
        self.title  = kILPMediaPickerDefaultTitle;
        
        _mediaType = mediaType;
        
        _mediaLibrary = [ILPPHPhotoLibrary new];
        [_mediaLibrary setMediaType:mediaType];
        
        _selectedAssetsBlock = block;
        
        switch (mediaType) {
            case ILPMediaTypeImage:
                _blankImage = [self.class mainBundleImageNamed:@"blank_image"];
                _addImage = [self.class mainBundleImageNamed:@"camera"];
                break;
            case ILPMediaTypeVideo:
                _blankImage = [self.class mainBundleImageNamed:@"blank_video"];
                _addImage = [self.class mainBundleImageNamed:@"camcorder"];
                break;
            default:
                _blankImage = [self.class mainBundleImageNamed:@"blank_media_item"];
                _addImage = [self.class mainBundleImageNamed:@"add_icon"];
                break;
        }
        
        self.navigationItem.leftBarButtonItem = self.cancelBarButton;
        
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        [self registerCellNibOrClass:[UINib nibWithNibName:kILPMediaPickerCellNibName bundle:bundle]];
        [self registerAddCellNibOrClass:[UINib nibWithNibName:kILPMediaPickerAddCellNibName bundle:bundle]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAddNotification:) name:kILPMediaPickerAddCellDidTapNotification object:nil];
        
    }
    return self;
    
}

- (ILPMediaCameraPicker *)cameraPicker {
    if (!_cameraPicker) {
        _cameraPicker = [[ILPMediaCameraPicker alloc] initWithType:_mediaType];
        _cameraPicker.delegate = self;
    }
    return _cameraPicker;
}

- (UIBarButtonItem *)cancelBarButton {
    if (!_cancelBarButton) {
        _cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                            style:UIBarButtonItemStyleBordered
                                                           target:self
                                                           action:@selector(handleBarButtonTap:)];
    }
    return _cancelBarButton;
}

- (void)registerCellNibOrClass:(id)nibOrClass {
    [self registerNibOrClass:nibOrClass withReuseIdentifier:kILPMediaPickerCellReuseIdentifier];
}

- (void)registerAddCellNibOrClass:(id)nibOrClass {
    [self registerNibOrClass:nibOrClass withReuseIdentifier:kILPMediaPickerAddCellReuseInetifier];
}

- (void)registerNibOrClass:(id)nibOrClass withReuseIdentifier:(NSString *)identifier {
    if ([nibOrClass isKindOfClass:UINib.class]) {
        [self.collectionView registerNib:nibOrClass forCellWithReuseIdentifier:identifier];
    }
    else if ([nibOrClass isKindOfClass:UICollectionViewCell.class]) {
        [self.collectionView registerClass:nibOrClass forCellWithReuseIdentifier:identifier];
    }
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfAssets = [_mediaLibrary numberOfAssets];
    return self.cameraPicker.isAvailable ? numberOfAssets + 1 : numberOfAssets;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cameraPicker.isAvailable && indexPath.row == 0) {
        ILPMediaPickerAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kILPMediaPickerAddCellReuseInetifier forIndexPath:indexPath];
        cell.imageView.image = _addImage;
        return cell;
    }
    
    ILPMediaPickerCell *cell = [self reusedItemCellForIndexPath:indexPath];
    
    [self willLoadItemCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)willLoadItemCell:(ILPMediaPickerCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    id<ILPMediaAsset> asset = [self dataAssetForIndexPath:indexPath];
    
    [self setCellBlankImage:cell];

    [asset loadImageWithSize:cell.bounds.size
             withHandleBlock:^(UIImage *image) {
                 [self setImage:image forCell:cell];
             }];
}

- (ILPMediaPickerCell *)reusedItemCellForIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:kILPMediaPickerCellReuseIdentifier forIndexPath:indexPath];
}

- (id<ILPMediaAsset>)dataAssetForIndexPath:(NSIndexPath *)indexPath {
    NSInteger assetIndex = [self properDataIndexWithPath:indexPath];
    return [_mediaLibrary assetAtIndex:assetIndex];
}

- (NSInteger)properDataIndexWithPath:(NSIndexPath *)path {
   return self.cameraPicker.isAvailable ? path.row - 1: path.row;
}

- (void)setCellBlankImage:(ILPMediaPickerCell *)cell {
    [self setImage:_blankImage forCell:cell];
}

- (void)setImage:(UIImage *)image forCell:(ILPMediaPickerCell *)cell {
    cell.imageView.contentMode = image == _blankImage ? UIViewContentModeCenter : UIViewContentModeScaleAspectFill;
    cell.imageView.image = image;
}

#pragma mark - Image Picker controller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    ILPMediaAsset *mediaAsset = [ILPMediaAsset new];
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        mediaAsset.mediaType = ILPMediaTypeImage;
        mediaAsset.image = info[UIImagePickerControllerOriginalImage];
    }
    else {
        mediaAsset.mediaType = ILPMediaTypeVideo;
        mediaAsset.videoUrl = info[UIImagePickerControllerMediaURL];
    }
    
    [self.cameraPicker dismissViewControllerAnimated:YES completion:nil];
    
    if (_selectedAssetsBlock) {
        _selectedAssetsBlock(@[mediaAsset]);
    }
}

#pragma mark - Camera use

- (void)handleAddNotification:(NSNotification *)notificaion {
    [self.navigationController presentViewController:self.cameraPicker animated:YES completion:nil];
}

#pragma mark - Actions

- (void)handleBarButtonTap:(UIBarButtonItem *)button {
    if (button == _cancelBarButton) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kILPMediaPickerAddCellDidTapNotification object:nil];
}

@end
