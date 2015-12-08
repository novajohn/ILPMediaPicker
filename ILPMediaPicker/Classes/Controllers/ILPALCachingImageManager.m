//
//  ILPALCachingImageManager.m
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

#import "ILPALCachingImageManager.h"

typedef void(^ILPMediaPickerImageBlock)(UIImage *image);

@interface ILPALImageAssetOperation : NSOperation

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic) CGSize size;
@property (nonatomic, copy) ILPMediaPickerImageBlock block;

- (instancetype)initWithAsset:(ALAsset *)asset withSize:(CGSize)size withCompleteBlock:(ILPMediaPickerImageBlock)block;

@end

@implementation ILPALImageAssetOperation

- (instancetype)initWithAsset:(ALAsset *)asset withSize:(CGSize)size withCompleteBlock:(ILPMediaPickerImageBlock)block {
    self = [super init];
    if (self) {
        _asset = asset;
        _size  = size;
        _block = block;
    }
    return self;
}

- (void)main {
    if (_block) {
        UIImage *assetImage = [self imageAsset];
        _block(assetImage);
    }
}

- (UIImage *)imageAsset {
    
    UIImage *assetImage;
    CGRect thumbRect = CGRectMake(0, 0, _size.width, _size.height);
    CGImageRef imageRef = _asset.defaultRepresentation.fullScreenImage;
    
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
    
    UIGraphicsBeginImageContext(thumbRect.size);
    [[UIImage imageWithCGImage:imageRef] drawInRect:thumbRect];
    assetImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(imageRef);
    
    return assetImage;
}

@end

@interface ILPALCachingImageManager ()

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSCache *cache;

@end

@implementation ILPALCachingImageManager

+ (instancetype)sharedManager {
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [self new];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _cache = [NSCache new];
        _queue = [NSOperationQueue new];
        _queue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)requestImageForAsset:(ALAsset *)asset targetSize:(CGSize)size resultHandler:(void(^)(UIImage *image))block {
    NSString *absoluteUrl = [[asset valueForProperty:ALAssetPropertyAssetURL] absoluteString];
    NSString *cacheKey = [NSString stringWithFormat:@"%@%fx%f", absoluteUrl, size.width, size.height];
    UIImage *resultImage = [_cache objectForKey:cacheKey];
    
    if (resultImage) {
        if (block) {
            block(resultImage);
        }
        return;
    }
    
    ILPALImageAssetOperation *imageAssetOperation = [[ILPALImageAssetOperation alloc] initWithAsset:asset withSize:size withCompleteBlock:^(UIImage *image) {
        [self.cache setObject:image forKey:cacheKey];
        if (block) {
            block(image);
        }
    }];
    
    [self.queue addOperation:imageAssetOperation];
}

@end
