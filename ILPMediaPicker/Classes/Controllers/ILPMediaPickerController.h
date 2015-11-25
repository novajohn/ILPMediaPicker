//
//  ILPMediaPickerController.h
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

#import <UIKit/UIKit.h>
#import "ILPImageCollectionController.h"
#import "ILPVideoCollectionController.h"

/**
 *  Constants that indicate a type of a `ILPMediaPickerController` instance.
 */
typedef NS_ENUM(NSInteger, ILPMediaType) {
    /**
     *  Indicates the instance to pick images and photos.
     */
    ILPMediaTypePhoto,
    /**
     *  Indicates the instance to pick videos.
     */
    ILPMediaTypeVideo
};

@protocol ILPMediaPickerDelegate;

/**
 *  The `ILPMediaPickerController` class is a subclass of `UINavigationController`. It allows to use and configure media assets collection controller wrapped with a navigation controller regarding to the chosen type.
 *
 *  @warning The picker is based on Assets Library framework which is deprecated as of iOS 9.0.
 */
@interface ILPMediaPickerController : UINavigationController <ILPImageCollectionDelegate, ILPVideoCollectionDelegate>

/**
 *----------------------------------------------
 *  @name Configuring a Media Picker Controller
 *----------------------------------------------
 */

/**
 *  The maximum number of items which could be selected.
 */
@property (nonatomic) NSInteger itemsLimit;

/**
 *  The maximum size of an item thumbnail. Here size means both width and height. Thumbnails are square.
 */
@property (nonatomic) CGFloat itemDeterminantSize;

/**
 *  The exact spacing value between thumbnails in a collection view. Applied both to items inter and line spacing.
 */
@property (nonatomic) CGFloat itemSpacing;

/**
 *  The object that acts as a delegate of the media picker controller.
 */
@property (weak, nonatomic) id<UINavigationControllerDelegate, ILPMediaPickerDelegate> delegate;

/**
 *----------------------------------------------
 *  @name Initializing a Media Picker Controller
 *----------------------------------------------
 */

/**
 *  Creates and returns a picker controller of `ILPMediaTypePhoto` type;
 *
 *  @return A `ILPMediaPickerController` instance.
 */
+ (instancetype)imagePicker;

/**
 *  Creates and returns a picker controller of `ILPMediaTypeVideo` type;
 *
 *  @return A `ILPMediaPickerController` instance.
 */
+ (instancetype)videoPicker;

@end

/**
 *  The `ILPMediaPickerDelegate` protocol defines methods that a delegate object should implement to be able to handle selected media items.
 */
@protocol ILPMediaPickerDelegate <UINavigationControllerDelegate>

@optional

/**
 *  Notifies the delegate that the media items have been selected.
 *
 *  @param mediaPicker The `UIIMagePickerController` object that is notifying the delegate.
 *  @param items       The array of selected items.
 */
- (void)mediaPicker:(ILPMediaPickerController *)mediaPicker didPickItems:(NSArray *)items;

/**
 *  Notifies the delegate that the new photo has been taken.
 *
 *  @param mediaPicker The `UIIMagePickerController` object that is notifying the delegate.
 *  @param photo       The image of the taken photo.
 */
- (void)mediaPicker:(ILPMediaPickerController *)mediaPicker didTakePhoto:(UIImage *)photo;

/**
 *  Notifies the delegate that the new video has been captured.
 *
 *  @param mediaPicker The `UIIMagePickerController` object that is notifying the delegate.
 *  @param videoUrl    The url for the new captured video.
 */
- (void)mediaPicker:(ILPMediaPickerController *)mediaPicker didCaptureVideoWithURL:(NSURL *)videoUrl;

@end