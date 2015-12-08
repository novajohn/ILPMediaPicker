//
//  ILPALAssetsLibrary.m
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

#import "ILPALAssetsLibrary.h"
#import "ILPALCachingImageManager.h"

@interface ILPALAssetsLibrary()

@property (nonatomic) ILPMediaType mediaType;

@property (strong, nonatomic) ALAssetsLibrary *library;

@property (copy, nonatomic) NSMutableArray<ALAssetsGroup *> *groups;
@property (copy, nonatomic) NSMutableArray<ALAsset *> *assetsList;

@property (strong, nonatomic) ALAssetsGroup *selectedGroup;

@property (copy, nonatomic) NSString *assetType;

@end

@implementation ILPALAssetsLibrary

- (instancetype)init {
    self = [super init];
    if (self) {
        _library = [ALAssetsLibrary new];
        _groups = [NSMutableArray new];
        
        _groups = [NSMutableArray array];
        _assetsList = [NSMutableArray array];
        
    }
    return self;
}

- (void)setMediaType:(ILPMediaType)mediaType {
    _mediaType = mediaType;
    
    switch (mediaType) {
        case ILPMediaTypeAll:
            _assetType = ALAssetTypeUnknown;
            break;
        case ILPMediaTypeImage:
            _assetType = ALAssetTypePhoto;
            break;
        case ILPMediaTypeVideo:
            _assetType = ALAssetTypeVideo;
            break;
    }
}

- (void)loadAssetsWithBlock:(void (^)(NSArray<id<ILPMediaAsset>> *))block {
    [_library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                            usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                if (group && group.numberOfAssets > 0) {
                                    [self loadAssetsWithGroup:group];
                                }
                                
                                if (group == nil) {
                                    block(self.assets);
                                }
                            }
                          failureBlock:nil];
}

- (void)loadAssetsWithGroup:(ALAssetsGroup *)group {
    [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
        if (asset && (_mediaType == ILPMediaTypeAll || [[asset valueForProperty:ALAssetPropertyType] isEqualToString:_assetType])) {
            [_assetsList addObject: asset];
        }
    }];
}

- (void)loadGroups {

}

- (NSInteger)numberOfGroups {
    return _groups.count;
}

- (NSInteger)numberOfAssets {
    return _assetsList.count;
}

- (NSArray<id<ILPMediaAsset>> *)assets {
    return _assetsList;
}

- (NSMutableArray<ALAssetsGroup *> *)groups {
    return _groups;
}

@end

@implementation ALAsset (ILPMediaAsset)

- (void)loadImageWithSize:(CGSize)size withHandleBlock:(void (^)(UIImage *))block {
    ILPALCachingImageManager *imageManager = [ILPALCachingImageManager sharedManager];
    [imageManager requestImageForAsset:self
                            targetSize:size
                         resultHandler:^(UIImage *image) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                 block(image);
                             });
                         }];
}

@end

@implementation ALAssetsGroup (ILPMediaGroup)

- (NSString *)name {
    return [self valueForProperty:ALAssetsGroupPropertyName];
}

@end
