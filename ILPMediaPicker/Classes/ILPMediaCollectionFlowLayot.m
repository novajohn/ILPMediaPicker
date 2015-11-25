//
//  ILPMediaCollectionFlowLayot.m
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

#import "ILPMediaCollectionFlowLayot.h"

@implementation ILPMediaCollectionFlowLayot

#pragma mark - Accessors

- (void)setItemSpacing:(CGFloat)spacing {
    self.minimumLineSpacing = spacing;
    self.minimumInteritemSpacing = spacing;
    _itemSpacing = spacing;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    CGSize itemSize, collectionSize = self.collectionView.frame.size;
    NSInteger itemsColumns = ceil(collectionSize.width / _itemDeterminantSize);
    
    itemSize.width  = collectionSize.width - self.collectionView.contentInset.left - self.sectionInset.left - self.sectionInset.right - self.collectionView.contentInset.right - _itemSpacing * (itemsColumns - 1);
    itemSize.width /= itemsColumns;
    
    itemSize.width = floorf(itemSize.width);
    
    itemSize.height = itemSize.width;
    
    self.itemSize = itemSize;
}

@end