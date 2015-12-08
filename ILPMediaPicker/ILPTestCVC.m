//
//  ILPTestCVC.m
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

#import "ILPTestCVC.h"
#import "ILPALAssetsLibrary.h"
#import "ILPPHPhotoLibrary.h"
#import "ILPCell.h"

@implementation ILPTestCVC {
    id<ILPMediaLibrary> _dataSource;
    NSArray<id<ILPMediaAsset>> *_assets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [ILPPHPhotoLibrary new];
    
    _dataSource = [ILPALAssetsLibrary new];
    //[_dataSource setMediaType:ILPMediaTypeImage];
    
    [_dataSource loadAssetsWithBlock:^(NSArray<id<ILPMediaAsset>> *assets) {
        NSLog(@"assets loaded %ld", [_dataSource numberOfAssets]);
        _assets = [_dataSource assets];
        [self.collectionView reloadData];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ILPCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rid" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    
    id<ILPMediaAsset> asset = _assets[indexPath.row];
    
    [asset loadImageWithSize:cell.imageView.bounds.size withHandleBlock:^(UIImage *image) {
        
        
      //  NSLog(@"image size: %@", NSStringFromCGSize(image.size));
        cell.imageView.image = image;
    }];
    
    return cell;
}

@end
