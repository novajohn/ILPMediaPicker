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

static NSString * const kILPMediaPickerItemCellNibName    = @"ILPMediaPickerItemCell";
static NSString * const kILPMediaPickerItemCellReusableId = @"ilpMediaPickerItemCell";
static NSString * const kILPMediaPickerAddCellNibName     = @"ILPMediaPickerAddCell";
static NSString * const kILPMediaPickerAddCellReusableId  = @"ilpMediaPickerAddCell";
static char * const kILPMediaPickerLoadingThumbnailsQueueLabel = "org.mediapicker.ilp.ThubmnailsLoadingQueee";

static NSString *const kILPMediaPickerDefaultTitle = @"Media Item Picker";

@interface ILPMediaCollectionController ()

@property (copy, nonatomic) NSMutableArray *assetsData;
@property (copy, nonatomic) NSMutableArray *selectedIndexPaths;

@property (copy, nonatomic) NSMutableDictionary *thumbnailsCache;

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

@end

@implementation ILPMediaCollectionController {
    dispatch_queue_t _thumbnailQueue;
    NSMutableSet<NSIndexPath *> *_loadingIndexPaths;
    NSIndexPath *_addingIndexPath;
    UIImagePickerController *_imagePicker;
    BOOL _showAddCell;
}

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
    return [self initWithCollectionViewLayout:[ILPMediaCollectionFlowLayot new]];
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        
        _selectedIndexPaths = [NSMutableArray array];
        _assetsData = [NSMutableArray array];
        _thumbnailsCache = [NSMutableDictionary dictionary];
        _loadingIndexPaths = [NSMutableSet set];
        
        _addingIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        self.collectionView.allowsMultipleSelection = YES;
        
        self.title  = kILPMediaPickerDefaultTitle;
        _itemsLimit = 0;
        _blankImage = nil;
        
        _showAddCell = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        
        _showAddCell = YES;
        
        [self registerCells];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                              target:self
                                                                                              action:@selector(barButtonItemDidTap:)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                               target:self
                                                                                               action:@selector(barButtonItemDidTap:)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAddNotification:) name:kILPMediaPickerAddCellDidTapNotification object:nil];
        
        
    }
    return  self;
}

- (UIImagePickerController *)imagePicker {
    if (_showAddCell && !_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.delegate = self;
        _showAddCell = YES;
    }
    return _imagePicker;
}

- (void)registerCells {
    
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    [self registerCellNibOrClass:[UINib nibWithNibName:kILPMediaPickerItemCellNibName bundle:bundle]];
    [self registerAddCellNibOrClass:[UINib nibWithNibName:kILPMediaPickerAddCellNibName bundle:bundle]];
}

- (void)registerCellNibOrClass:(id)nibOrClass {
    if ([nibOrClass isKindOfClass:UINib.class]) {
        [self.collectionView registerNib:nibOrClass forCellWithReuseIdentifier:kILPMediaPickerItemCellReusableId];
    }
    else if (nibOrClass == UICollectionViewCell.class) {
        [self.collectionView registerClass:nibOrClass forCellWithReuseIdentifier:nibOrClass];
    }
}

- (void)registerAddCellNibOrClass:(id)nibOrClass {
    if ([nibOrClass isKindOfClass:UINib.class]) {
        [self.collectionView registerNib:nibOrClass forCellWithReuseIdentifier:kILPMediaPickerAddCellReusableId];
    }
    else if ([nibOrClass isKindOfClass:UICollectionViewCell.class]) {
        [self.collectionView registerClass:nibOrClass forCellWithReuseIdentifier:nibOrClass];
    }
}

- (void)loadAssetsByType:(NSString *)assetType {
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                  usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                      [self loadAssetsByType:assetType fromGroup:group];
                                  }
                                failureBlock:nil];
}

- (void)loadAssetsByType:(NSString *)assetType fromGroup:(ALAssetsGroup *)anAssetGroup {
    [anAssetGroup enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset && [[asset valueForProperty:ALAssetPropertyType] isEqualToString:assetType]) {
            [self addAssetToData:asset];
        }
    }];
}

- (void)addAssetToData:(id)anAsset {
    [_assetsData insertObject:anAsset atIndex:0];
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _showAddCell ? _assetsData.count + 1 : _assetsData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_showAddCell && indexPath.row == _addingIndexPath.row) {
        ILPMediaPickerAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kILPMediaPickerAddCellReusableId forIndexPath:indexPath];
        cell.imageView.image = _addImage;
        return cell;
    }
    
    ILPMediaPickerItemCell *cell = [self reusedItemCellForIndexPath:indexPath];
    [self willLoadItemCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)willLoadItemCell:(ILPMediaPickerItemCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ALAsset *asset = [self dataAssetForIndexPath:indexPath];
    NSString *assetUrl = asset.defaultRepresentation.url.absoluteString;
    UIImage *thumbnail = _thumbnailsCache[assetUrl];
    
    if (thumbnail) {
        [self setImage:thumbnail forCell:cell];
        return;
    }
    
    if ([_loadingIndexPaths containsObject:indexPath]) {
        [self setCellBlankImage:cell];
        return;
    }
    
    if (!_thumbnailQueue) {
        _thumbnailQueue = dispatch_queue_create(kILPMediaPickerLoadingThumbnailsQueueLabel, NULL);
    }
    
    [_loadingIndexPaths addObject:indexPath];
    [self setCellBlankImage:cell];
    dispatch_async(_thumbnailQueue, ^{
        if ([_loadingIndexPaths containsObject:indexPath]) {
            UIImage *thumbnail = [self loadThumbnailFromImage:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
            _thumbnailsCache[assetUrl] = thumbnail;
            [_loadingIndexPaths removeObject:indexPath];
            dispatch_async(dispatch_get_main_queue(), ^{
                ILPMediaPickerItemCell *_cell = (ILPMediaPickerItemCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                [self setImage:thumbnail forCell:_cell];
            });
            
        }
        
    });
}

- (ILPMediaPickerItemCell *)reusedItemCellForIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:kILPMediaPickerItemCellReusableId forIndexPath:indexPath];
}

- (ALAsset *)dataAssetForIndexPath:(NSIndexPath *)indexPath {
    NSInteger dataIndex = _showAddCell ? indexPath.row - 1: indexPath.row;
    return _assetsData[dataIndex];
}

- (void)setCellBlankImage:(ILPMediaPickerItemCell *)cell {
    [self setImage:_blankImage forCell:cell];
}

- (void)setImage:(UIImage *)image forCell:(ILPMediaPickerItemCell *)cell {
    cell.imageView.contentMode = image == _blankImage ? UIViewContentModeCenter : UIViewContentModeScaleAspectFill;
    cell.imageView.image = image;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [_loadingIndexPaths removeObject:indexPath];
}

- (UIImage *)loadThumbnailFromImage:(UIImage *)image {
    UIImage *thumbnail;
    CGRect thumbRect = CGRectMake(0, 0, self.collectionViewLayout.itemDeterminantSize, self.collectionViewLayout.itemDeterminantSize);
    CGImageRef imageRef = image.CGImage;
    
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    
    CGSize cropSize;
    CGFloat offsetX = 0, offsetY = 0;
    CGFloat originalRatio = imageSize.width / imageSize.height;
    CGFloat thumbRatio    = thumbRect.size.width / thumbRect.size.height;
    
    if (originalRatio >= thumbRatio) {
        cropSize.height = imageSize.height;
        cropSize.width  = cropSize.height * thumbRatio;
        offsetX = (imageSize.width - cropSize.width) / 2;
    }
    else {
        cropSize.width = imageSize.width;
        cropSize.height = cropSize.width / thumbRatio;
        offsetY = (imageSize.height - cropSize.height) / 2;
    }
    
    
    CGRect cropRect = CGRectMake(offsetX, offsetY, cropSize.width, cropSize.height);
    imageRef = CGImageCreateWithImageInRect(imageRef, cropRect);
    
    // resize the image
    UIGraphicsBeginImageContext(thumbRect.size);
    [[UIImage imageWithCGImage:imageRef] drawInRect:thumbRect];
    thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // release CGImageRef to avoid memory leaks
    CGImageRelease(imageRef);
    
    return thumbnail;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [_selectedIndexPaths addObject:indexPath];
    
    if (_selectedIndexPaths.count > 0 && !self.navigationItem.rightBarButtonItem.enabled) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_selectedIndexPaths removeObject:indexPath];
    
    if (_selectedIndexPaths.count == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == _addingIndexPath) {
        return YES;
    }
    
    ILPMediaPickerItemCell *cell = (ILPMediaPickerItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    return (!_itemsLimit || _selectedIndexPaths.count < _itemsLimit) && cell.imageView.contentMode == UIViewContentModeScaleAspectFill;
}

#pragma mark - Camera use

- (void)handleAddNotification:(NSNotification *)notificaion {
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - Button Actions

- (void)barButtonItemDidTap:(UIBarButtonItem *)buttonItem {
    if (buttonItem == self.navigationItem.rightBarButtonItem) {
        NSMutableArray<ALAsset *> *assets = [NSMutableArray array];
        for (NSIndexPath *indexPath in _selectedIndexPaths) {
            [assets addObject:[self dataAssetForIndexPath:indexPath]];
        }
        if ([self.delegate respondsToSelector:@selector(mediaCollectionController:didSelectItems:)]) {
            [self.delegate mediaCollectionController:self didSelectItems:assets];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kILPMediaPickerAddCellDidTapNotification object:nil];
}

@end
