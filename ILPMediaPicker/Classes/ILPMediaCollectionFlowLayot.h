//
//  ILPMediaCollectionFlowLayot.h
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

/**
 *  The `ILPMediaCollectionFlowLayot` is an initial flow layout for an `ILPMediaCollectionController`. It calculates the exact item size with regarding to the `itemDeterminantSize` and `itemSpacing` properties.
 */
@interface ILPMediaCollectionFlowLayot : UICollectionViewFlowLayout

/**
 *  The maximum size of an item thumbnail. Here size means both width and height. Thumbnails are square.
 */
@property (nonatomic) CGFloat itemDeterminantSize;

/**
 *  The exact spacing value between thumbnails in a collection view. Applied both to items inter and line spacing.
 */
@property (nonatomic) CGFloat itemSpacing;

@end
