//
//  XGSettingListCell.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/9.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGSettingListCell.h"
#import "UIButton+XGAdd.h"
#import <SDImageCache.h>
#import "NSObject+XGAdd.h"

@interface XGSettingListCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *arrowLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIActivityIndicatorView *cacheActivityIndicatorView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation XGSettingListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
        [self layoutPageSubviews];
    }
    return self;
}

- (void)clearImageCache:(ClearImageCacheComplete)complete {
    SDImageCache *imgCache = [SDImageCache sharedImageCache];
    NSUInteger cacheSize = [imgCache getSize];
//    if (cacheSize > 0) {
        [self.cacheActivityIndicatorView startAnimating];
        self.arrowLabel.hidden = YES;
        [imgCache clearMemory];
        
        kWeakSelf(weakSelf);
        [imgCache clearDiskOnCompletion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.cacheActivityIndicatorView stopAnimating];
                complete ? complete() : nil;
            });
        }];
//    }
}

- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    self.titleLabel.text = titleText;
}

- (void)setArrowTitle:(NSString *)arrowTitle {
    _arrowTitle = arrowTitle;
    self.arrowLabel.text = arrowTitle;
    self.arrowLabel.hidden = !arrowTitle.xg_isString;
}

- (void)setDisplayCacheLabel:(BOOL)displayCacheLabel {
    _displayCacheLabel = displayCacheLabel;
    if (displayCacheLabel) {
        self.arrowLabel.hidden = NO;
        SDImageCache *imgCache = [SDImageCache sharedImageCache];
        NSUInteger cacheSize = [imgCache getSize];
        self.arrowLabel.text = [NSString stringWithFormat:@"%.1fM",cacheSize / 1024.0 / 1024.0];
    } else {
        self.arrowLabel.hidden = YES;
    }
}

- (void)setHideLine:(BOOL)hideLine {
    _hideLine = hideLine;
    self.lineView.hidden = hideLine;
}

- (void)initSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.arrowLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.cacheActivityIndicatorView];
    [self.contentView addSubview:self.lineView];
}

- (void)layoutPageSubviews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
    [self.arrowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.arrowImageView.mas_leading).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
    [self.cacheActivityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.arrowImageView.mas_leading).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(15);
        make.trailing.bottom.offset(0);
        make.height.equalTo(@0.5);
    }];
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_rightarrow_icon"]];
    }
    return _arrowImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor xg_blackColor];
        _titleLabel.font = [UIFont xg_pingFangFontOfSize:17];
    }
    return _titleLabel;
}

- (UILabel *)arrowLabel {
    if (!_arrowLabel) {
        _arrowLabel = [[UILabel alloc] init];
        _arrowLabel.textColor = [UIColor xg_grayColor];
        _arrowLabel.font = [UIFont xg_pingFangFontOfSize:12];
    }
    return _arrowLabel;
}

- (UIActivityIndicatorView *)cacheActivityIndicatorView {
    if (!_cacheActivityIndicatorView) {
        _cacheActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _cacheActivityIndicatorView.hidesWhenStopped = YES;
    }
    return _cacheActivityIndicatorView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor xg_separatorLineColor];
    }
    return _lineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
