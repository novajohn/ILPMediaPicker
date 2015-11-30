//
//  ILPAlbumCollectionController.m
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

#import "ILPAlbumCollectionController.h"
#import "ILPMediaPickerAlbumCell.h"

@implementation ILPAlbumCollectionController {
    ALAssetsLibrary *_assetsLibrary;
}

- (void)loadAssetsByType:(NSString *)assetType {
    
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                  usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                      if (group && group.numberOfAssets) {
                                          [self addAssetToData:group];
                                      }
                                  }
                                failureBlock:nil];
}

- (void)registerCellNibOrClass:(id)nibOrClass {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    [super registerCellNibOrClass:[UINib nibWithNibName:@"ILPMediaPickerAlbumCell" bundle:bundle]];
}

- (void)willLoadItemCell:(ILPMediaPickerAlbumCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ALAssetsGroup *group = [self dataAssetForIndexPath:indexPath];
    
    UIImage *posterImage = [UIImage imageWithCGImage:group.posterImage];
    NSLog(@"poster size: %@", NSStringFromCGSize(posterImage.size));
    
    
    cell.imageView.image = posterImage;
    cell.titleLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    cell.amountTitle.text = [NSString stringWithFormat:@"%ld", (long)group.numberOfAssets];
}

@end
