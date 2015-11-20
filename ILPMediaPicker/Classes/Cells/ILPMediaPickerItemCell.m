//
//  ILPMediaPickerItemCell.m
//  ILPMediaPicker
//
//  Created by Evgeniy Novikov on 10/27/15.
//
//

#import "ILPMediaPickerItemCell.h"

@interface ILPMediaPickerItemCell ()

@property (weak, nonatomic) IBOutlet UIView *checkmarkView;

@end

@implementation ILPMediaPickerItemCell

- (void)awakeFromNib {
    _checkmarkView.hidden = YES;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
     
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    super.selected = selected;
    
    _checkmarkView.hidden = !selected;
    _imageView.alpha = selected ? 0.65f : 1.0f;
}

@end
