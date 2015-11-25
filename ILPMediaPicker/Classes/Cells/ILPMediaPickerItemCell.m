//
//  ILPMediaPickerItemCell.m
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

#import "ILPMediaPickerItemCell.h"
#import "ILPMediaCollectionController.h"

static NSString * const kILPMediaPickerCheckmarkImageName = @"checkmark";

@interface ILPMediaPickerItemCell ()

@property (weak, nonatomic) IBOutlet UIView *checkmarkView;
@property (weak, nonatomic) IBOutlet UIImageView *checkmarkImageView;

@end

@implementation ILPMediaPickerItemCell

- (void)awakeFromNib {
    _checkmarkView.hidden = YES;
    _checkmarkImageView.image = [ILPMediaCollectionController mainBundleImageNamed:kILPMediaPickerCheckmarkImageName];
}

- (void)setSelected:(BOOL)selected {
    super.selected = selected;
    
    _checkmarkView.hidden = !selected;
    _imageView.alpha = selected ? 0.65f : 1.0f;
}

@end
