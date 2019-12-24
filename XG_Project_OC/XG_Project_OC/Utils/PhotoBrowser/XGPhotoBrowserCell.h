//
//  XGPhotoBrowserCell.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/22.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, XGFileUploadStatus) {
    /// 文件上传中
    XGFileUploadStatusUploading,
    
    /// 文件MD5请求失败
    XGFileUploadStatusMD5Failure,
    
    /// 文件上传失败
    XGFileUploadStatusFailure,
    
    /// 文件上传成功
    XGFileUploadStatusSuccess
};

typedef NS_OPTIONS(NSUInteger, XGFileFromType) {
    /// 文件来自相册并且是单张
    XGFileFromTypeSingleAlbum,
    
    /// 文件来自相册并且是多张
    XGFileFromTypeMultipleAlbum,
    
    /// 文件来自拍照
    XGFileFromTypeTakingPictures
};

@class XGPhotoBrowserCell;
@class XGPhotoBrowserModel;
@protocol XGPhotoBrowserCellDelegate <NSObject>

- (void)deleteButtonClick:(UIButton *)sender currentRow:(NSInteger)row;

@end

@interface XGPhotoBrowserCell : UICollectionViewCell

/// 代理
@property (nonatomic,   weak) id<XGPhotoBrowserCellDelegate> delegate;

/// 非添加按钮的图片
@property (nonatomic, strong) XGPhotoBrowserModel *model;

/// 当前row
@property (nonatomic, assign) NSInteger currentRow;

/// "+"按钮的图片
@property (nonatomic, strong) UIImage *addImage;

- (UIView *)snapshotView;

@end

@interface XGPhotoBrowserModel : NSObject

@property (nonatomic,   copy) NSString *md5String;
@property (nonatomic,   copy) NSString *urlString;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) id asset;
@property (nonatomic, assign) XGFileUploadStatus uploadStatus;
@property (nonatomic, assign) XGFileFromType fromType;

@end

NS_ASSUME_NONNULL_END
