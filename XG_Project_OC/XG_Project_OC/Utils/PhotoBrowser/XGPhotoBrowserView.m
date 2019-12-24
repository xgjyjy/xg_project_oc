//
//  XGPhotoBrowserView.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/22.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGPhotoBrowserView.h"
#import "XGPhotoBrowserCell.h"
#import "LxGridViewFlowLayout.h"
#import <TZImagePickerController/UIView+Layout.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import <TZImagePickerController/TZImageManager.h>

@interface XGPhotoBrowserView ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,XGPhotoBrowserCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/// 相册的容器
@property (nonatomic, strong) UICollectionView *collectionView;

/// 布局容器
@property (nonatomic, strong) LxGridViewFlowLayout *flowLayout;

/// 系统相册vc
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

/// 用户选择的图片的Assets
@property (nonatomic, strong) NSMutableArray *selectedAssets;

/// 用户选择的图片的数组
@property (nonatomic, strong) NSMutableArray *selectedPhotos;

/// 存放用户选择的图片model的数组
@property (nonatomic, strong) NSMutableArray *imageModelArray;

/// 剩余可选照片的个数
@property (nonatomic, assign) NSInteger remainingChoicesCount;

/// 上次拍照的照片的asset
@property (nonatomic, strong) id lastAsset;

/// 相机的location
@property (nonatomic, strong) CLLocation *location;

/// 照片的宽度
@property (nonatomic, assign) NSInteger photoWidth;

@end

@implementation XGPhotoBrowserView

#pragma mark - LifeCycle

- (void)dealloc{
    XLog(@"当前界面销毁了%@",self);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
        [self layoutPageSubviews];
    }
    return self;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    tzImagePickerVc.sortAscendingByModificationDate = YES;
    [tzImagePickerVc showProgressHUD];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        /** 获取用户选择的照片和asset */
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(PHAsset *asset, NSError *error) {
            [tzImagePickerVc hideProgressHUD];
            if (error) {
                NSLog(@"图片保存失败 %@",error);
            } else {
                TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                [self.selectedAssets addObject:assetModel.asset];
                /** 照片拍摄的图片是原图尺寸,所以要缩放图片 */
                UIImage *newImage = image;
                newImage = [[TZImageManager manager] scaleImage:newImage toSize:CGSizeMake(818, 1104)];
                [self.selectedPhotos addObject:newImage];
                [self reloadDataSoure:XGFileFromTypeTakingPictures];
            }
        }];
    }
}

/** 用户取消了选择照片 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - XGPhotoBrowserCellDelegate

- (void)deleteButtonClick:(UIButton *)sender currentRow:(NSInteger)row {
    if (row >= self.imageModelArray.count) return;
    
    [self.selectedAssets removeObjectAtIndex:row];/** 删除对应的asset */
    [self.selectedPhotos removeObjectAtIndex:row];/** 删除对应的图片 */
    [self.imageModelArray removeObjectAtIndex:row];/** 删除对应的model */
    self.remainingChoicesCount = self.maxCount - 1;
    [self reloadCollectionView];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.imageModelArray.count && indexPath.item < self.maxCount) {/** 点击了 + 图标 */
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhoto];
        }];
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pushTZImagePickerController];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [actionSheet addAction:cameraAction];
        [actionSheet addAction:albumAction];
        [actionSheet addAction:cancelAction];
        [self.superController presentViewController:actionSheet animated:YES completion:nil];
    } else {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:self.selectedAssets selectedPhotos:self.selectedPhotos index:indexPath.item];
        imagePickerVc.maxImagesCount = self.maxCount;
        imagePickerVc.allowPickingGif = NO;
        imagePickerVc.allowPickingOriginalPhoto = YES;
        imagePickerVc.allowPickingMultipleVideo = NO;
        imagePickerVc.showSelectedIndex = NO;
        imagePickerVc.isSelectOriginalPhoto = YES;
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.superController presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageModelArray.count >= self.maxCount ? self.imageModelArray.count : self.imageModelArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XGPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XGPhotoBrowserCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.currentRow = indexPath.item;
    /** 如果不是上传中,就给最后一个item添加+图标 */
    if (indexPath.item == self.imageModelArray.count && indexPath.item < self.maxCount) {
        cell.addImage = [UIImage imageNamed:@"public_addphoto_image"];
    } else if (self.imageModelArray.count > 0) {/** 显示照片的缩略图 */
        XGPhotoBrowserModel *model = [self.imageModelArray safeValue:indexPath.item];
        cell.model = model;
    }
    return cell;
}

#pragma mark - LxGridViewDataSource (以下三个方法为长按排序相关代码)

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < self.imageModelArray.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < self.imageModelArray.count && destinationIndexPath.item < self.imageModelArray.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (self.imageModelArray.count == 0) return;
    [self configPhotoDatas:self.selectedPhotos index:sourceIndexPath.item newIndex:destinationIndexPath.item];
    [self configPhotoDatas:self.selectedAssets index:sourceIndexPath.item newIndex:destinationIndexPath.item];
    [self configPhotoDatas:self.imageModelArray index:sourceIndexPath.item newIndex:destinationIndexPath.item];
    [self reloadCollectionView];
}

#pragma mark - TargetAction

#pragma mark - PublicMethods

#pragma mark - PrivateMethods

- (void)reloadCollectionView {
    [self.collectionView reloadData];
    NSInteger rowCount = (self.imageModelArray.count % self.columnCount == 0 && self.imageModelArray.count == self.maxCount)
    ? self.imageModelArray.count / self.columnCount :
    (int)self.imageModelArray.count / self.columnCount + 1;
    CGFloat height = self.photoMargin * (rowCount - 1) + rowCount * self.photoWidth + self.contentInsets.top + self.contentInsets.bottom;
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    if ([self.delegate respondsToSelector:@selector(xg_photoBrowserView:didSelectPhotos:urls:)]) {
        [self.delegate xg_photoBrowserView:self didSelectPhotos:self.selectedPhotos urls:nil];
    }
}

- (void)reloadDataSoure:(XGFileFromType)fromType {
    if (self.selectedAssets.count == 0) return;
    [self.imageModelArray removeAllObjects];
    for (UIImage *image in self.selectedPhotos) {
        XGPhotoBrowserModel *model = [[XGPhotoBrowserModel alloc] init];
        model.image = image;
        model.fromType = fromType;
        [self.imageModelArray addObject:model];
    }
    [self reloadCollectionView];
}

- (void)configPhotoDatas:(NSMutableArray *)datas index:(NSInteger)index newIndex:(NSInteger)newIndex {
    if (datas.count == 0 || index < 0) return ;
    if (index >= datas.count) return ;
    id obj = [datas safeValue:index];
    if (obj) {
        [datas removeObjectAtIndex:index];
        [datas insertObject:obj atIndex:newIndex];
    }
}

- (void)pushTZImagePickerController {
    if (self.maxCount <= 0) {
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCount columnNumber:self.columnCount delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.allowTakePicture = NO;/** 在内部不显示拍照按钮 */
    imagePickerVc.allowTakeVideo = NO;/** 在内部不显示拍视频按 */
    imagePickerVc.allowPickingOriginalPhoto = NO;/** 隐藏原图按钮 */
    imagePickerVc.allowPickingVideo = NO;/** 用户将不能选择视频 */
    imagePickerVc.showSelectedIndex = YES;/** 会显示照片的选中序号 */
    imagePickerVc.sortAscendingByModificationDate = YES;/** 照片排列按修改时间升序 */
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.showPhotoCannotSelectLayer = YES;/** 当照片选择张数达到maxImagesCount时，其它照片会显示颜色为cannotSelectLayerColor的浮层 */
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    imagePickerVc.selectedAssets = self.selectedAssets;/** 目前已经选中的图片数组 */
    /** 通过block或者代理，来得到用户选择的照片 */
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self.selectedAssets removeAllObjects];
        [self.selectedPhotos removeAllObjects];
        [self.selectedAssets addObjectsFromArray:assets];
        [self.selectedPhotos addObjectsFromArray:photos];
        [self reloadDataSoure:photos.count > 0 ? XGFileFromTypeMultipleAlbum : XGFileFromTypeSingleAlbum];
    }];
    [self.superController presentViewController:imagePickerVc animated:YES completion:nil];
}

/** 获取相机或相册的权限 */
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        /** 无相机权限 做一个友好的提示 */
        UIAlertController *actionAlert = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *setupAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [actionAlert addAction:setupAction];
        [actionAlert addAction:cancelAction];
        [self.superController presentViewController:actionAlert animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        /** fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏 */
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
    } else if ([PHPhotoLibrary authorizationStatus] == 2) {/** 拍照之前还需要检查相册权限,已被拒绝，没有相册权限，将无法保存拍的照片 */
        UIAlertController *actionAlert = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [actionAlert addAction:sureAction];
        [self.superController presentViewController:actionAlert animated:YES completion:nil];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) {/** 未请求过相册权限 */
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

/** 调用相机 */
- (void)pushImagePickerController {
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = [locations firstObject];
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];/** 提前定位 */
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        self.imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.superController presentViewController:self.imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

#pragma mark - LayoutPageSubviews

- (void)layoutPageSubviews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.width == 0 || self.photoWidth > 0) {
        return;
    }
    
    self.photoWidth = (self.width - (self.columnCount - 1) * self.photoMargin - self.contentInsets.left - self.contentInsets.right) / self.columnCount;
    self.flowLayout.itemSize = CGSizeMake(self.photoWidth, self.photoWidth);
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.photoWidth + self.contentInsets.top + self.contentInsets.bottom));
    }];
}

- (void)initSubviews {
    _maxCount = 9;
    _columnCount = 3;
    self.photoMargin = 2;
    self.contentInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    [self addSubview:self.collectionView];
}

#pragma mark - Getter&Setter

- (void)setPhotoMargin:(CGFloat)photoMargin {
    _photoMargin = photoMargin;
    self.flowLayout.minimumLineSpacing = photoMargin;
    self.flowLayout.minimumInteritemSpacing = photoMargin;
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;
    self.flowLayout.sectionInset = contentInsets;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor grayColor];
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_collectionView registerClass:[XGPhotoBrowserCell class] forCellWithReuseIdentifier:NSStringFromClass([XGPhotoBrowserCell class])];
    }
    return _collectionView;
}

- (LxGridViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[LxGridViewFlowLayout alloc] init];
    }
    return _flowLayout;
}

- (UIImagePickerController *)imagePickerVc {
    if (!_imagePickerVc) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        if (@available(iOS 7, *)) {/** 改变相册选择页的导航栏外观 */
            _imagePickerVc.navigationBar.barTintColor = self.superController.navigationController.navigationBar.barTintColor;
        }
        _imagePickerVc.navigationBar.tintColor = self.superController.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
        BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (NSMutableArray *)selectedAssets {
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}

- (NSMutableArray *)imageModelArray {
    if (!_imageModelArray) {
        _imageModelArray = [NSMutableArray array];
    }
    return _imageModelArray;
}

- (NSMutableArray *)selectedPhotos {
    if (!_selectedPhotos) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}

@end
