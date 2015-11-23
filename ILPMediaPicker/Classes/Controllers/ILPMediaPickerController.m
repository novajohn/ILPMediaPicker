//
//  ILPMediaPickerController.m
//  ILPMediaPicker
//
//  Created by Evgeniy Novikov on 10/22/15.
//
//

#import "ILPMediaPickerController.h"
#import "ILPMediaPickerItemCell.h"

static CGFloat const kILPMediaPickerItemDeterminantSizeDefault = 200.0f;
static CGFloat const kILPMediaPickerItemSpacingDefault         = 5.0f;

@interface ILPMediaPickerController ()

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
    _collectionController = aType == ILPMediaTypePhoto ? [ILPImageCollectionController new] : [ILPVideoCollectionController new];
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

- (void)setItemsLimit:(CGFloat)limit {
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

