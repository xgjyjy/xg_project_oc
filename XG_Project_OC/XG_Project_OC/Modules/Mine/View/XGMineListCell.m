//
//  XGMineListCell.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/9.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGMineListCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+XGAdd.h"

@interface XGMineListCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation XGMineListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
        [self layoutPageSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_rightView) {
        if (CGRectEqualToRect(_rightView.frame, CGRectZero)) {
            [_rightView sizeToFit];
        }
        
        CGFloat rightMargin = 0;
        if (_isHiddenArrow) {
            rightMargin = -15;
        } else {
            rightMargin = -15 - _arrowImageView.width - 5;
        }
        
        _rightView.X = self.contentView.width - _rightView.width + rightMargin;
        _rightView.Y = (self.contentView.height - _rightView.height) / 2;
    }

}

- (void)setRightView:(UIView *)rightView {
    if (_rightView) {
        [_rightView removeFromSuperview];
    }
    _rightView = rightView;
    [self.contentView addSubview:_rightView];
}

- (void)setIsHiddenArrow:(BOOL)isHiddenArrow {
    _isHiddenArrow = isHiddenArrow;
    self.arrowImageView.hidden = isHiddenArrow;
}

- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    self.titleLabel.text = titleText;
}

- (void)initSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.arrowImageView];
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
        _titleLabel.textColor = [UIColor xg_colorWithHexString:@"333333"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
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
