//
//  ILPMediaNavigationController.m
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

#import "ILPMediaNavigationController.h"

@interface ILPMediaNavigationController ()

@property (nonatomic, strong) ILPMediaGroupCollectionController *groupCollectionController;
@property (nonatomic, strong) ILPMediaItemCollectionController *itemCollectionController;

@end

@implementation ILPMediaNavigationController

- (instancetype)initWithMediaType:(ILPMediaType)mediaType withDisplayMode:(ILPMediaDisplayMode)displayMode {
    _mediaType = mediaType;
    _displayMode = displayMode;
    ILPMediaCollectionController *rootCollectionController = displayMode == ILPMediaDisplayModeGroup ? self.groupCollectionController : self.itemCollectionController;
    
    self = [super initWithRootViewController:rootCollectionController];
    if (self) {
        
    }
    return self;
}

- (ILPMediaGroupCollectionController *)groupCollectionController {
    if (!_groupCollectionController) {
        self.itemCollectionController.navigationItem.leftBarButtonItem = nil;
        _groupCollectionController = [[ILPMediaGroupCollectionController alloc] initWithMediaType:_mediaType withSelectedGroupBlock:^(id<ILPMediaGroup> group) {
            [self.itemCollectionController setBaseGroup:group withCollectionUpdate:YES];
            [self pushViewController:self.itemCollectionController animated:YES];
        }];
    }
    return _groupCollectionController;
}

- (ILPMediaItemCollectionController *)itemCollectionController {
    if (!_itemCollectionController) {
        _itemCollectionController = [[ILPMediaItemCollectionController alloc] initWithMediaType:_mediaType];
        _itemCollectionController.clearSelectionOnAppear = YES;
    }
    return _itemCollectionController;
}

- (void)setSelectedAssetsBlock:(ILPMediaSelectedAssetsBlock)selectedAssetsBlock {
    _selectedAssetsBlock = selectedAssetsBlock;
    self.itemCollectionController.selectedAssetsBlock = selectedAssetsBlock;
}

@end
