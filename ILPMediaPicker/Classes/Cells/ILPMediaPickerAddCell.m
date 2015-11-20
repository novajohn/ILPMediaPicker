//
//  ILPMediaPickerAddCell.m
//  ILPMediaPicker
//
//  Created by Evgeniy Novikov on 11/12/15.
//
//

#import "ILPMediaPickerAddCell.h"

@implementation ILPMediaPickerAddCell {
    UITapGestureRecognizer *_tapRecognizer;
}

- (void)awakeFromNib {
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:_tapRecognizer];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender == _tapRecognizer) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kILPMediaPickerAddCellDidTapNotification object:nil];
    }
}

@end
