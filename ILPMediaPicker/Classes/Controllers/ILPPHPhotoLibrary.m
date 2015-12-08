//
//  ILPPHPhotoLibrary.m
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

#import "ILPPHPhotoLibrary.h"

@interface ILPPHAssetCollection ()

@property (nonatomic, strong) PHAssetCollection *baseCollection;
@property (nonatomic) ILPMediaType mediaType;

@property (strong, nonatomic) PHFetchOptions *typeFetchOption;
@property (strong, nonatomic) PHFetchResult *assetsResult;

- (instancetype)initWithBaseAssetCollection:(PHAssetCollection *)assetCollection withMediaType:(ILPMediaType)mediaType;

@end

@implementation ILPPHAssetCollection

- (instancetype)initWithBaseAssetCollection:(PHAssetCollection *)assetCollection withMediaType:(ILPMediaType)mediaType {
    self = [super init];
    if (self) {
        _baseCollection = assetCollection;
        _mediaType = mediaType;
        
        _typeFetchOption = nil;
        
        if (_mediaType != ILPMediaTypeAll) {
            _typeFetchOption = [PHFetchOptions new];
            _typeFetchOption.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i", _mediaType];
        }
        
        _assetsResult = [PHAsset fetchAssetsInAssetCollection:self.baseCollection options:_typeFetchOption];
    }
    return self;
}

- (NSString *)name {
    return _baseCollection.localizedTitle;
}

- (void)loadPosterWithSize:(CGSize)size withHandleBlock:(void (^)(UIImage *))block {
    [_assetsResult.firstObject loadImageWithSize:size withHandleBlock:block];
}

- (NSInteger)numberOfAsset {
    return _assetsResult.count;
}

- (PHAssetCollection *)baseAsset {
    return _baseCollection;
}

@end

@interface ILPPHPhotoLibrary ()

@property (nonatomic) ILPMediaType mediaType;

@property (copy, nonatomic) NSMutableArray<ILPPHAssetCollection *> *assetCollections;
@property (copy, nonatomic) NSMutableArray<PHAsset *> *assetsList;

@property (strong, nonatomic) ILPPHAssetCollection *selectedCollection;

@property (nonatomic) PHAssetMediaType assetMediaType;
@property (strong, nonatomic) PHFetchOptions *typeFetchOption;

@end

@implementation ILPPHPhotoLibrary

- (instancetype)init {
    return [self initWithMediaType:ILPMediaTypeImage];
}

- (instancetype)initWithMediaType:(ILPMediaType)type {
    self = [super init];
    if (self) {
        _assetCollections = [NSMutableArray array];
        _assetsList = [NSMutableArray array];
        
        self.mediaType = type;
    }
    return self;
}

- (void)setMediaType:(ILPMediaType)mediaType {
    _mediaType = mediaType;
    
    switch (mediaType) {
        case ILPMediaTypeAll:
            self.assetMediaType = PHAssetMediaTypeUnknown;
            break;
        case ILPMediaTypeImage:
            self.assetMediaType = PHAssetMediaTypeImage;
            break;
        case ILPMediaTypeVideo:
            self.assetMediaType = PHAssetMediaTypeVideo;
            break;
    }
}

- (void)setAssetMediaType:(PHAssetMediaType)assetMediaType {
    if (assetMediaType == PHAssetMediaTypeUnknown) {
        self.typeFetchOption = nil;
    }
    else {
        self.typeFetchOption.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i", assetMediaType];
    }
    _assetMediaType = assetMediaType;
}

- (PHFetchOptions *)typeFetchOption {
    if (!_typeFetchOption) {
        _typeFetchOption = [PHFetchOptions new];
    }
    return _typeFetchOption;
}

- (void)loadGroupsWithBlock:(void (^)(NSArray<id<ILPMediaGroup>> *))block {
    [_assetCollections removeAllObjects];
    [self loadCollectionsWithType:PHAssetCollectionTypeAlbum];
    [self loadCollectionsWithType:PHAssetCollectionTypeSmartAlbum];
    
    if (block) {
        block(self.groups);
    }
}

- (void)loadAssetsWithBlock:(void (^)(NSArray<id<ILPMediaAsset>> *))block {
    [_assetsList removeAllObjects];
    
    PHFetchResult *assetsResult;
    if (_selectedCollection) {
        assetsResult = [PHAsset fetchAssetsInAssetCollection:[_selectedCollection baseAsset] options:self.typeFetchOption];
    }
    else {
        assetsResult = [PHAsset fetchAssetsWithMediaType:_assetMediaType options:nil];
    }
    
    [assetsResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        [_assetsList addObject:asset];
    }];
    
    if (block) {
        block(self.assets);
    }
}

- (void)loadCollectionsWithType:(PHAssetCollectionType)type {
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:type subtype:PHAssetCollectionSubtypeAny options:nil];
    [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
        PHFetchResult *assetsResult = [PHAsset fetchAssetsInAssetCollection:collection options:self.typeFetchOption];
        if (assetsResult.count) {
            ILPPHAssetCollection *assetCollection = [[ILPPHAssetCollection alloc] initWithBaseAssetCollection:collection withMediaType:self.mediaType];
            [_assetCollections addObject:assetCollection];
        }
    }];
}

- (NSInteger)numberOfAssets {
    return _assetsList.count;
}

- (NSInteger)numberOfGroups {
    return _assetCollections.count;
}

- (NSArray<id<ILPMediaAsset>> *)assets {
    return _assetsList;
}

- (NSArray<id<ILPMediaGroup>> *)groups {
    return _assetCollections;
}

- (id<ILPMediaAsset>)assetAtIndex:(NSInteger)index {
    return _assetsList[index];
}


- (void)setSelectedGroup:(id<ILPMediaGroup>)mediaGroup {
    _selectedCollection = mediaGroup;
}

@end

@implementation PHAsset (ILPMediaAsset)

- (void)loadImageWithSize:(CGSize)size withHandleBlock:(void (^)(UIImage *))block {
    PHImageManager *imageManager = [PHCachingImageManager defaultManager];
    [imageManager requestImageForAsset:self
                            targetSize:size
                           contentMode:PHImageContentModeAspectFill
                               options:nil
                         resultHandler:^(UIImage *image, NSDictionary *info) {
                             block(image);
                         }];
}

@end
