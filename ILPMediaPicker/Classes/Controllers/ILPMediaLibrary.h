//
//  ILPMediaLibrary.h
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

@import Foundation;
@import UIKit;

#import "ILPMediaPicker.h"

@protocol ILPMediaAsset <NSObject>

- (ILPMediaType)mediaType;

- (void)loadImageWithSize:(CGSize)size withHandleBlock:(void(^)(UIImage *image))block;

- (id)baseAsset;

- (UIImage *)image;

- (NSString *)videoUrl;

@end

@interface ILPMediaAsset : NSObject <ILPMediaAsset>

@property (nonatomic) ILPMediaType mediaType;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *videoUrl;

@end

@protocol ILPMediaGroup <NSObject>

- (NSString *)name;

- (NSInteger)numberOfAsset;

- (void)loadPosterWithSize:(CGSize)size withHandleBlock:(void(^)(UIImage *image))block;

- (id)baseAssetGroup;

@end

@protocol ILPMediaLibrary <NSObject>

- (void)setMediaType:(ILPMediaType)mediaType;

- (void)loadGroupsWithBlock:(void(^)(NSArray<id<ILPMediaGroup>> *groups))block;

- (void)loadAssetsWithBlock:(void(^)(NSArray<id<ILPMediaAsset>> *assets))block;

- (NSInteger)numberOfAssets;

- (NSArray<id<ILPMediaAsset>> *)assets;

- (NSInteger)numberOfGroups;

- (NSArray<id<ILPMediaGroup>> *)groups;

- (void)setSelectedGroup:(id<ILPMediaGroup>)mediaGroup;

- (id<ILPMediaAsset>)assetAtIndex:(NSInteger)index;

@end