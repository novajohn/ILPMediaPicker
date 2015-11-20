//
//  ILPPhotoCollectionController.h
//  ILPMediaPicker
//
//  Created by Evgeniy Novikov on 11/6/15.
//
//

#import "ILPMediaCollectionController.h"

@protocol ILPImageCollectionDelegate;

@interface ILPImageCollectionController : ILPMediaCollectionController

@property (weak, nonatomic) id<ILPMediaCollectionDelegate, ILPImageCollectionDelegate> delegate;

@end

@protocol ILPImageCollectionDelegate <ILPMediaCollectionDelegate>

@optional

- (void)imageCollectionController:(ILPImageCollectionController *)controller didTakePhoto:(UIImage *)photo;

@end
