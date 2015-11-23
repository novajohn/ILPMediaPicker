//
//  ILPMediaCollectionController.h
//  ILPMediaPicker
//
//  Created by Evgeniy Novikov on 11/4/15.
//
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ILPMediaCollectionFlowLayot.h"

static NSString * const kILPMediaPickerBundleName = @"ILPMediaPicker";

@protocol ILPMediaCollectionDelegate;

@interface ILPMediaCollectionController : UICollectionViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) NSInteger itemsLimit;

@property (strong, nonatomic) UIImage *blankImage;
@property (strong, nonatomic) UIImage *addImage;

@property (readonly, nonatomic) ILPMediaCollectionFlowLayot *collectionViewLayout;

@property (readonly, nonatomic) UIImagePickerController *imagePicker;

@property (weak, nonatomic) id<ILPMediaCollectionDelegate> delegate;

+ (NSBundle *)mainBundle;

+ (UIImage *)mainBundleImageNamed:(NSString *)anImageName;

- (void)registerCells;

- (void)registerCellNibOrClass:(id)nibOrClass;

- (void)loadAssetsByType:(NSString *)assetType;

@end

@protocol ILPMediaCollectionDelegate <NSObject>

@optional

- (void)mediaCollectionController:(ILPMediaCollectionController *)controller didSelectItems:(NSArray<ALAsset *> *)items;

@end