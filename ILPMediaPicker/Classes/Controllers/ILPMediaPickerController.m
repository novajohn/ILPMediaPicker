//
//  ILPMediaPickerController.m
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

#import "ILPMediaPickerController.h"
#import "ILPMediaPickerItemCell.h"
#import "ILPAlbumCollectionController.h"

static CGFloat const kILPMediaPickerItemDeterminantSizeDefault = 200.0f;
static CGFloat const kILPMediaPickerItemSpacingDefault         = 5.0f;

@interface ILPMediaPickerController ()

@property (nonatomic) ILPMediaType mediaType;
@property (strong, nonatomic) ILPMediaCollectionController *collectionController;

@end

@implementation ILPMediaPickerController

@dynamic delegate;

+ (instancetype)imagePicker {
    return [[self alloc] initWithMediaType:ILPMediaTypePhoto];
}

+ (instancetype)videoPicker {
    return [[self alloc] initWithMediaType:ILPMediaTypeVideo];
}

#pragma mark - Initializator

- (instancetype)init {
    return [self initWithMediaType:ILPMediaTypePhoto];
}

//Designated initializer
- (instancetype)initWithMediaType:(ILPMediaType)aType {
    //_collectionController = aType == ILPMediaTypePhoto ? [ILPImageCollectionController new] : [ILPVideoCollectionController new];
    _collectionController = [ILPAlbumCollectionController new];
    
    _collectionController.delegate = self;
    self = [super initWithRootViewController:_collectionController];
    if (self) {
        self.itemDeterminantSize = kILPMediaPickerItemDeterminantSizeDefault;
        self.itemSpacing = kILPMediaPickerItemSpacingDefault;
    }
    return self;
}

#pragma mark - Accessors

- (void)setTitle:(NSString *)title {
    super.title = title;
    _collectionController.title = title;
}

- (void)setItemsLimit:(NSInteger)limit {
    _collectionController.itemsLimit = limit;
    _itemsLimit = limit;
}

- (void)setItemDeterminantSize:(CGFloat)size {
    _collectionController.collectionViewLayout.itemDeterminantSize = size;
    _itemDeterminantSize = size;
}

- (void)setItemSpacing:(CGFloat)spacing {
    _collectionController.collectionViewLayout.itemSpacing = spacing;
    _itemSpacing = spacing;
}

#pragma mark - ILPMediaCollectionDelegate

- (void)mediaCollectionController:(ILPMediaCollectionController *)controller didSelectItems:(NSArray<ALAsset *> *)items {
    if (_collectionController == controller) {
        if ([self.delegate respondsToSelector:@selector(mediaPicker:didPickItems:)]) {
            [self.delegate mediaPicker:self didPickItems:items];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ILPImageCollectionDelegate

- (void)imageCollectionController:(ILPImageCollectionController *)controller didTakePhoto:(UIImage *)photo {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (_collectionController == controller) {
        if ([self.delegate respondsToSelector:@selector(mediaPicker:didTakePhoto:)]) {
            [self.delegate mediaPicker:self didTakePhoto:photo];
        }
    }
}

#pragma mark - ILPVideoCollectionDelegate

- (void)videoCollectionController:(ILPVideoCollectionController *)controller didCaptureVideoWithUrl:(NSURL *)videoURL{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (_collectionController == controller && [self.delegate respondsToSelector:@selector(mediaPicker:didCaptureVideoWithURL:)]) {
        [self.delegate mediaPicker:self didCaptureVideoWithURL:videoURL];
    }
}

@end

