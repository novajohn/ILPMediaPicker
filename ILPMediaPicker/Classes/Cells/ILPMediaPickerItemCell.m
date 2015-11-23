//
//  ILPMediaPickerItemCell.m
//  ILPMediaPicker
//
//  Created by Evgeniy Novikov on 10/27/15.
//
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
