//
//  ILPMediaPickerController.h
//  ILPMediaPicker
//
//  Created by Evgeniy Novikov on 10/22/15.
//
//

#import <UIKit/UIKit.h>
#import "ILPImageCollectionController.h"
#import "ILPVideoCollectionController.h"

typedef NS_ENUM(NSInteger) {
    ILPMediaTypePhoto,
    ILPMediaTypeVideo
} ILPMediaType;

@protocol ILPMediaPickerDelegate;

@interface ILPMediaPickerController : UINavigationController <ILPImageCollectionDelegate, ILPVideoCollectionDelegate>

@property (nonatomic) ILPMediaType mediaType;

@property (nonatomic) CGFloat itemsLimit;
@property (nonatomic) CGFloat itemDeterminantSize;
@property (nonatomic) CGFloat itemSpacing;

@property (weak, nonatomic) id<UINavigationControllerDelegate, ILPMediaPickerDelegate> delegate;

+ (instancetype)imagePicker;

+ (instancetype)videoPicker;

@end

@protocol ILPMediaPickerDelegate <UINavigationControllerDelegate>

@optional

- (void)mediaPicker:(ILPMediaPickerController *)mediaPicker didPickItems:(NSArray *)items;

- (void)mediaPicker:(ILPMediaPickerController *)mediaPicker didTakePhoto:(UIImage *)photo;

- (void)mediaPicker:(ILPMediaPickerController *)mediaPicker didCaptureVideoWithURL:(NSURL *)videoUrl;

@end