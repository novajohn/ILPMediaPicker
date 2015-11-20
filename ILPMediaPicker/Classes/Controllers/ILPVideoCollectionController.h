//
//  ILPVideoCollectionControllerViewController.h
//  ILPMediaPicker
//
//  Created by Evgeniy Novikov on 11/16/15.
//
//

#import "ILPMediaCollectionController.h"

@protocol ILPVideoCollectionDelegate;

@interface ILPVideoCollectionController : ILPMediaCollectionController

@property (nonatomic, weak) id<ILPMediaCollectionDelegate, ILPVideoCollectionDelegate> delegate;

@end

@protocol ILPVideoCollectionDelegate <ILPMediaCollectionDelegate>

@optional

- (void)videoCollectionController:(ILPVideoCollectionController *)controller didCaptureVideoWithUrl:(NSURL *)videoURL;

@end