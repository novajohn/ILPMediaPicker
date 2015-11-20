//
//  ILPMediaCollectionFlowLayot.m
//  ILPMediaPicker
//
//  Created by Evgeniy Novikov on 11/4/15.
//
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