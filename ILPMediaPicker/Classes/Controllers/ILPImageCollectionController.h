//
//  ILPPhotoCollectionController.h
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

@protocol ILPImageCollectionDelegate;

/**
 *  The `ILPImageCollectionController` class is a subclass of `ILPMediaCollectionController` which initially loads saved images assets and allows user to take a new photo.
 */
@interface ILPImageCollectionController : ILPMediaCollectionController

/**
 *  The object that acts as a delegate of the image collection controller.
 */
@property (weak, nonatomic) id<ILPMediaCollectionDelegate, ILPImageCollectionDelegate> delegate;

@end

/**
 *  The `ILPImageCollectionDelegate` protocol defines the method that a delegate object should implement to be able to handle a new photo.
 */
@protocol ILPImageCollectionDelegate <ILPMediaCollectionDelegate>

@optional

/**
 *  Notifies the delegate that the new photo has been taken.
 *
 *  @param controller The `ILPImageCollectionController` object that is notifying the delegate.
 *  @param photo      The taken photo image.
 */
- (void)imageCollectionController:(ILPImageCollectionController *)controller didTakePhoto:(UIImage *)photo;

@end
