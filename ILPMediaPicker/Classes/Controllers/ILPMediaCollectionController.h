//
//  ILPMediaCollectionController.h
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

@import UIKit;
@import Foundation;

#import "ILPMediaPicker.h"
#import "ILPMediaLibrary.h"
#import "ILPMediaCollectionFlowLayot.h"
#import "ILPMediaPickerAddCell.h"
#import "ILPMediaPickerCell.h"
#import "ILPMediaCameraPicker.h"

static NSString * const kILPMediaPickerBundleName = @"ILPMediaPicker";

@protocol ILPMediaCollectionDelegate;

/**
 *  The `ILPMediaCollectionController` class is a subclass of `UICollectionViewController` whose collection view manages `ILPMediaPickerItemCell` cells with media items thumbnails. It also could have an intial cell with control to create a new media if there is a such possibility.
 *
 *  @warning The class is using Assets Library framework which is deprecated as of iOS 9.0.
 *
 *  @warning The class should be mainly used as a target for inheritance. It does not call loadAssetsByType: initially.
 *
 */
@interface ILPMediaCollectionController : UICollectionViewController

@property (nonatomic, strong) id<ILPMediaLibrary> mediaLibrary;
@property (nonatomic, strong) ILPMediaCameraPicker *cameraPicker;
- (instancetype)initWithMediaType:(ILPMediaType)mediaType;

- (instancetype)initWithType:(ILPMediaType)mediaType withCollectionViewLayout:(UICollectionViewLayout *)layout NS_DESIGNATED_INITIALIZER;

/**
 *  The placeholder image for an item cell before the thumbnail is loaded.
 */
@property (strong, nonatomic) UIImage *blankImage;

/**
 *  The background image of the a cell for adding new item.
 */
@property (strong, nonatomic) UIImage *addImage;

/**
 *  The flow layout object used to initialize the media collection controller.
 */
@property (readonly, nonatomic) ILPMediaCollectionFlowLayot *collectionViewLayout;

/**
 *  The image picker controller object used to present the media collection controller.
 */
@property (readonly, nonatomic) UIImagePickerController *imagePicker;

/**
 *  The object that acts as a delegate of the media collection controller.
 */
@property (weak, nonatomic) id<ILPMediaCollectionDelegate> delegate;

/**
 *  Returns the main subbundle of the class bundle defined by `kILPMediaPickerBundleName` name.
 *
 *  @return The `NSbundle` object.
 */
+ (NSBundle *)mainBundle;

/**
 *  Returns an image from the main bundle.
 *
 *  @param anImageName a name of the image to be loaded from the bundle.
 *
 *  @return The `UIImage` instance.
 */
+ (UIImage *)mainBundleImageNamed:(NSString *)anImageName;

/**
 *  Loads assets from asset library concerning to the specified type.
 *
 *  @param assetType The `ALAssetType` constant.
 */
//- (void)loadAssetsByType:(NSString *)assetType;

/**
 *  Loads assets from a given group.
 *
 *  @param anAssetGroup an `ALAssetGroup` instance.
 */
//- (void)loadAssetsByType:(NSString *)assetType fromGroup:(ase)anAssetGroup;

/**
 *  Adds asset object to collection view data source.
 *
 *  @param anAsset an `ALAsset/ALAssetGroup` objesct.
 */
//- (void)addAssetToData:(id)anAsset;

- (NSInteger)properDataIndexWithPath:(NSIndexPath *)path;

- (id)dataAssetForIndexPath:(NSIndexPath *)indexPath;

- (void)registerCellNibOrClass:(id)nibOrClass;

- (ILPMediaPickerCell *)reusedItemCellForIndexPath:(NSIndexPath *)indexPath;

- (void)willLoadItemCell:(ILPMediaPickerCell *)cell atIndexPath:(NSIndexPath *)indexPath;

//- (UIImage *)loadThumbnailFromImage:(UIImage *)image;

@end

/**
 *  The `ILPMediaCollectionDelegate` protocol defines a method that a delegate object should implement to be able to handle selected assets.
 */
@protocol ILPMediaCollectionDelegate <NSObject>

@optional

/**
 *  Notifies the delegate that the assets have been selected.
 *
 *  @param controller The `ILPMediaCollectionController` object that is notifying the delegate.
 *  @param items      The selected assets.
 */
//- (void)mediaCollectionController:(ILPMediaCollectionController *)controller didSelectItems:(NSArray<ALAsset *> *)items;

@end