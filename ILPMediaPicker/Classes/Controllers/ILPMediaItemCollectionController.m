//
//  ILPMediaItemCollectionController.m
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

#import "ILPMediaItemCollectionController.h"

@interface ILPMediaItemCollectionController ()

@property (nonatomic, copy) NSMutableArray<id<ILPMediaAsset>> *selectedAssets;

@property (nonatomic, copy) UIBarButtonItem *doneBarButton;

@end

@implementation ILPMediaItemCollectionController

- (instancetype)initWithMediaType:(ILPMediaType)mediaType {
    return [self initWithMediaType:mediaType withSelectedAssetsBlock:nil];
}

- (instancetype)initWithMediaType:(ILPMediaType)mediaType withSelectedAssetsBlock:(ILPMediaSelectedAssetsBlock)block {
    self = [super initWithMediaType:mediaType];
    if (self) {
        _selectedAssetsBlock = block;
        _selectedItemsLimit = 0;
        _selectedAssets = [NSMutableArray array];
        
        _clearSelectionOnAppear = NO;
        
        self.collectionView.allowsMultipleSelection = YES;
        
        self.navigationItem.rightBarButtonItem = self.doneBarButton;
        
        [self refreshDataSource];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    if (_clearSelectionOnAppear && _selectedAssets.count) {
        [self deselectAll];
    }
}

- (UIBarButtonItem *)doneBarButton {
    if (!_doneBarButton) {
        _doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                            style:UIBarButtonItemStyleBordered
                                                           target:self
                                                           action:@selector(handleDoneBarButtonTap:)];
        _doneBarButton.enabled = NO;
    }
    return _doneBarButton;
}

- (void)registerCellNibOrClass:(id)nibOrClass {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    [super registerCellNibOrClass:[UINib nibWithNibName:@"ILPMediaPickerItemCell" bundle:bundle]];
}

- (void)setBaseGroup:(id<ILPMediaGroup>)baseGroup {
    [self setBaseGroup:baseGroup withCollectionUpdate:NO];
}

- (void)setBaseGroup:(id<ILPMediaGroup>)baseGroup withCollectionUpdate:(BOOL)update {
    _baseGroup = baseGroup;
    [self.mediaLibrary setSelectedGroup:baseGroup];
    
    if (update) {
        self.title = [baseGroup name];
        [self refreshDataSource];
    }
}

- (void)refreshDataSource {
    [self.mediaLibrary loadAssetsWithBlock:^(NSArray<id<ILPMediaAsset>> *assets) {
        [self.collectionView reloadData];
    }];
}

#pragma mark - Collection View datasource/delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return _selectedItemsLimit == 0 ? : _selectedAssets.count < _selectedItemsLimit;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id<ILPMediaAsset> asset = [self dataAssetForIndexPath:indexPath];
    [_selectedAssets addObject:asset];
    _doneBarButton.enabled = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    id<ILPMediaAsset> asset = [self dataAssetForIndexPath:indexPath];
    [_selectedAssets removeObject:asset];
    _doneBarButton.enabled = _selectedAssets.count > 0;
}

- (void)deselectAll {
    for (int i = 0; i <= [self.collectionView numberOfItemsInSection:0]; i++) {
        NSIndexPath *indexPathToDeselect = [NSIndexPath indexPathForRow:i inSection:0];
        [self.collectionView deselectItemAtIndexPath:indexPathToDeselect animated:NO];
    }
    [_selectedAssets removeAllObjects];
    _doneBarButton.enabled = NO;
}

#pragma mark - Actions

- (void)handleDoneBarButtonTap:(UIBarButtonItem *)button {
    if (button == _doneBarButton) {
        if (_selectedAssetsBlock) {
            _selectedAssetsBlock(_selectedAssets);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
