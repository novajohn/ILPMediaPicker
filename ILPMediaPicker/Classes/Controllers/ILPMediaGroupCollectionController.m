//
//  ILPMediaGroupCollectionController.m
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

#import "ILPMediaGroupCollectionController.h"
#import "ILPMediaPickerGroupCell.h"

@interface ILPMediaCollectionController ()

@end

@implementation ILPMediaGroupCollectionController

- (instancetype)initWithMediaType:(ILPMediaType)mediaType {
    return [self initWithMediaType:mediaType withSelectedGroupBlock:nil];
}

- (instancetype)initWithMediaType:(ILPMediaType)mediaType withSelectedGroupBlock:(ILPMediaSelectedGroupBlock)selectedBlock {
    self = [super initWithMediaType:mediaType];
    if (self) {
        _selectedGroupBlock = selectedBlock;
        
        self.collectionView.allowsMultipleSelection = NO;
        
        [self.mediaLibrary loadGroupsWithBlock:^(NSArray<id<ILPMediaGroup>> *groups) {
            [self.collectionView reloadData];
        }];
    }
    return self;
}

- (void)registerCellNibOrClass:(id)nibOrClass {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    [super registerCellNibOrClass:[UINib nibWithNibName:@"ILPMediaPickerGroupCell" bundle:bundle]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfAssets = [self.mediaLibrary numberOfGroups];
    return self.cameraPicker.isAvailable ? numberOfAssets + 1 : numberOfAssets;
}

- (void)willLoadItemCell:(ILPMediaPickerGroupCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSInteger groupIndex = [self properDataIndexWithPath:indexPath];
    id<ILPMediaGroup> assetGroup = [self.mediaLibrary groups][groupIndex];
    
    cell.titleLabel.text = [assetGroup name];
    cell.amountTitle.text = [NSString stringWithFormat:@"%@", @([assetGroup numberOfAsset])];
    [assetGroup loadPosterWithSize:cell.bounds.size withHandleBlock:^(UIImage *image) {
        cell.imageView.image = image;
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedGroupBlock) {
        NSInteger groupIndex = [self properDataIndexWithPath:indexPath];
        id<ILPMediaGroup> assetGroup = [self.mediaLibrary groups][groupIndex];
        _selectedGroupBlock(assetGroup);
    }
}

@end
