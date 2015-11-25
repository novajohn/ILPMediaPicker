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

typedef NS_ENUM(NSInteger) {
    ILPMediaTypePhoto,
    ILPMediaTypeVideo
} ILPMediaType;

@protocol ILPMediaPickerDelegate;

@interface ILPMediaPickerController : UINavigationController <ILPImageCollectionDelegate, ILPVideoCollectionDelegate>

@property (nonatomic) ILPMediaType mediaType;

@property (nonatomic) CGFloat itemsLimit;
@property (nonatomic) CGFloat itemDeterminantSize;
@property (nonatomic) CGFloat itemSpacing;

@property (weak, nonatomic) id<UINavigationControllerDelegate, ILPMediaPickerDelegate> delegate;

+ (instancetype)imagePicker;

+ (instancetype)videoPicker;

@end

@protocol ILPMediaPickerDelegate <UINavigationControllerDelegate>

@optional

- (void)mediaPicker:(ILPMediaPickerController *)mediaPicker didPickItems:(NSArray *)items;

- (void)mediaPicker:(ILPMediaPickerController *)mediaPicker didTakePhoto:(UIImage *)photo;

- (void)mediaPicker:(ILPMediaPickerController *)mediaPicker didCaptureVideoWithURL:(NSURL *)videoUrl;

@end