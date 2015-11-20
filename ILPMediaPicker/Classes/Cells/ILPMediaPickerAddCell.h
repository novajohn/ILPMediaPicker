//
//  ILPMediaPickerAddCell.h
//  ILPMediaPicker
//
//  Created by Evgeniy Novikov on 11/12/15.
//
//

#import <UIKit/UIKit.h>

static NSString * const kILPMediaPickerAddCellDidTapNotification = @"org.mediapicker.ilp.addcelldidtap";

@interface ILPMediaPickerAddCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
