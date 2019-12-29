//
//  XGPhotoBrowserCell.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/22.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGPhotoBrowserCell.h"
#import "UIView+XGAdd.h"

@interface XGPhotoBrowserCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation XGPhotoBrowserCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
        [self layoutPageSubviews];
    }
    return self;
}

- (void)setModel:(XGPhotoBrowserModel *)model {
    _model = model;
    self.deleteButton.hidden = NO;
    if (model.image) {
        self.imageView.image = model.image;
        return;
    }
    NSString *imageName = nil;
    switch (model.uploadStatus) {
        case XGFileUploadStatusUploading:
        case XGFileUploadStatusSuccess:
            imageName = @"shangchuan";
            break;
        case XGFileUploadStatusMD5Failure:
            imageName = @"jiaoyan";
            break;
        case XGFileUploadStatusFailure:
            imageName = @"shibai";
            break;
        default:
            break;
    }
    [self.imageView xg_setImageWithURL:model.urlString placeholderImage:[UIImage imageNamed:imageName]];
}

- (void)setAddImage:(UIImage *)addImage {
    _addImage = addImage;
    self.imageView.image = addImage;
    self.deleteButton.hidden = YES;
}

- (void)setCurrentRow:(NSInteger)currentRow {
    _currentRow = currentRow;
    _deleteButton.tag = currentRow;
}

- (void)deleteButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(deleteButtonClick:currentRow:)]) {
        [self.delegate deleteButtonClick:sender currentRow:self.currentRow];
    }
}

- (UIView *)snapshotView {
    UIView *cellSnapshotView = nil;
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        cellSnapshotView = [self snapshotViewAfterScreenUpdates:NO];
    } else {
        CGSize size = CGSizeMake(self.bounds.size.width + 20, self.bounds.size.height + 20);
        UIGraphicsBeginImageContextWithOptions(size, self.opaque, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cellSnapshotView = [[UIImageView alloc]initWithImage:cellSnapshotImage];
    }
    
    UIView *snapshotView = [[UIView alloc] init];
    snapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    cellSnapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    
    [snapshotView addSubview:cellSnapshotView];
    return snapshotView;
}

- (void)initSubviews {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.deleteButton];
}

- (void)layoutPageSubviews {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.trailing.offset(0);
    }];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    }
    return _imageView;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"public_update_delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

@end

@implementation XGPhotoBrowserModel

@end
