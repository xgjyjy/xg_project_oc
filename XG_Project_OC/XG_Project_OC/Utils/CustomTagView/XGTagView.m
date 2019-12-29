//
//  XGTagView.m
//  xuanzhiyi
//
//  Created by 伙伴行 on 2019/12/26.
//  Copyright © 2019 选址易. All rights reserved.
//

#import "XGTagView.h"

@interface XGCollectionViewFlowLayout : UICollectionViewFlowLayout

/// 是否使用最大列间距值(默认NO不使用)
@property (nonatomic, assign, getter=isUserMaxIinteritemSpacing) BOOL userMaxIinteritemSpacing;

/// 标签列的最大间距
@property (nonatomic, assign) CGFloat maxIinteritemSpacing;

@end

@interface XGTagCell : UICollectionViewCell

/// tag的title
@property (nonatomic, strong) UILabel *tagLabel;

/// 背景图片
@property (nonatomic, strong) UIImageView *backgroundImageView;

/// tag的配置
@property (nonatomic, strong) XGTagConfig *tagConfig;

/// tag的数据源
@property (nonatomic, strong) XGTagModel *model;

@end

@interface XGTagView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/// 标签的容器
@property (nonatomic, strong) UICollectionView *collectionView;

/// flowLayout
@property (nonatomic, strong) XGCollectionViewFlowLayout *flowLayout;

/// 标签的配置
@property (nonatomic, strong) XGTagConfig *tagConfig;

/// collectionView的数据源
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

/// 自适应时tag的size
@property (nonatomic, strong) NSMutableArray *tagSizeArray;

/// 多次选中的标签的数据集合
@property (nonatomic, strong) NSMutableArray <XGTagModel *> *multipleChoiceModelArray;

/// 单次选中的标签的数据
@property (nonatomic, strong) XGTagModel *singleChoiceModel;

/// 限制行数时的行数
@property (nonatomic, assign) NSUInteger lineNumber;

@end

@implementation XGTagView

#pragma mark - LifeCycle

- (void)dealloc {
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
}

- (instancetype)initWithTextArray:(NSArray *)textArray tagConfig:(XGTagConfig *)tagConfig {
    if (self = [super init]) {
        _tagConfig = tagConfig;
        [self configDataSource:textArray];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"] && object == self.collectionView) {
        CGFloat height = self.collectionView.contentSize.height;
        if (self.lineNumber > 0) {
            CGFloat lineHeight = self.flowLayout.itemSize.height * self.lineNumber ;
            if (lineHeight < height) height = lineHeight;
        }
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XGTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XGTagCell class]) forIndexPath:indexPath];
    if (self.dataSourceArray.count > 0) {
        cell.tagConfig = self.tagConfig;
        XGTagModel *model = self.dataSourceArray[indexPath.item];
        model.selected = self.tagConfig.isCanChooseMultiple ? [self.multipleChoiceModelArray containsObject:model] : model == self.singleChoiceModel;
        cell.model = model;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tagConfig.tagType == XGTagTypeFixedSize) {
        return self.tagConfig.fixedSize;
    }
    XGTagModel *model = [self.dataSourceArray objectAtIndex:indexPath.item];
    return model.tagSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.tagConfig.interitemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.tagConfig.lineSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (self.dataSourceArray.count == 0 || !self.tagConfig.userInteractionEnabled) {
        return;
    }
    
    XGTagModel *model = [self.dataSourceArray objectAtIndex:indexPath.item];
    if (self.tagConfig.isCanChooseMultiple) {
        if (self.tagConfig.isCancel) {
            if ([self.multipleChoiceModelArray containsObject:model]) {
                [self.multipleChoiceModelArray removeObject:model];
            } else {
                [self.multipleChoiceModelArray addObject:model];
            }
            [collectionView reloadData];
        } else {
            if (![self.multipleChoiceModelArray containsObject:model]) {
                [self.multipleChoiceModelArray addObject:model];
                [collectionView reloadData];
            }
        }
    } else {
        if (self.tagConfig.isCancel) {
            if (self.singleChoiceModel == model) {
                self.singleChoiceModel = nil;
            } else {
                self.singleChoiceModel = model;
            }
            [collectionView reloadData];
        } else {
            if (self.singleChoiceModel != model) {
                self.singleChoiceModel = model;
                [collectionView reloadData];
            }
        }
    }
    
    if (self.tagConfig.isCanChooseMultiple) {
        if ([self.delegate respondsToSelector:@selector(xg_tagView:didSelectedTags:)]) {
            [self.delegate xg_tagView:self didSelectedTags:self.multipleChoiceModelArray];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(xg_tagView:didSelectedTag:)]) {
            [self.delegate xg_tagView:self didSelectedTag:self.singleChoiceModel];
        }
    }
}

#pragma mark - PublicMethods

- (void)singleChoiceTagAtText:(NSString *)text {
    if (self.dataSourceArray.count == 0) return;
    for (XGTagModel *model in self.dataSourceArray) {
        if ([model.tagText isEqualToString:text]) {
            self.singleChoiceModel = model;
            break;
        }
    }
    [self.collectionView reloadData];
}

- (void)singleChoiceTagAtIndex:(NSInteger)index {
    if (self.dataSourceArray.count == 0 || index < 0) return;
    if (index >= self.dataSourceArray.count) return;
    self.singleChoiceModel = [self.dataSourceArray objectAtIndex:index];
    [self.collectionView reloadData];
}

- (void)multipleChoiceTagAtIndexs:(NSArray<NSNumber *> *)indexs {
    if (![indexs isKindOfClass:[NSArray class]]) return;
    if (indexs.count == 0) return;
    if (self.dataSourceArray.count == 0) return;
    if (indexs.count > self.dataSourceArray.count) return;
    for (NSNumber *index in indexs) {
        if (index.intValue >= self.dataSourceArray.count) {
            NSAssert(index.intValue >= self.dataSourceArray.count , @"下标越界了");
            return;
        }
        XGTagModel *model = [self.dataSourceArray objectAtIndex:index.intValue];
        [self.multipleChoiceModelArray addObject:model];
    }
    [self.collectionView reloadData];
}

- (void)multipleChoiceTagAtTexts:(NSArray<NSString *> *)texts {
    if (![texts isKindOfClass:[NSArray class]]) return;
    if (texts.count == 0) return;
    if (self.dataSourceArray.count == 0) return;
    if (texts.count > self.dataSourceArray.count) return;
    for (XGTagModel *tagModel in self.dataSourceArray) {
        for (NSString *text in texts) {
            if ([text isEqualToString:tagModel.tagText]) {
                [self.multipleChoiceModelArray addObject:tagModel];
                continue;
            }
        }
    }
    [self.collectionView reloadData];
}

- (void)cancelSelected {
    self.singleChoiceModel = nil;
    [self.multipleChoiceModelArray removeAllObjects];
    [self.collectionView reloadData];
}

- (void)reloadDataSoure:(NSArray *)textArray {
    if (![textArray isKindOfClass:[NSArray class]]) return;
    if (textArray.count == 0) return;
    [self configDataSource:textArray];
    [self.collectionView reloadData];
}

- (void)displaySpecifiedLineTag:(NSUInteger)lineNumber {
    self.lineNumber = lineNumber;
    [self.collectionView reloadData];
    self.collectionView.scrollEnabled = NO;
}

#pragma mark - PrivateMethods

- (void)configDataSource:(NSArray *)textArray {
    for (int i = 0; i < textArray.count; i++) {
        NSString *text = [textArray objectAtIndex:i];
        CGSize tagSize = [self calculateString:text font:self.tagConfig.tagFont maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        XGTagModel *model = [[XGTagModel alloc] init];
        model.tagIndex = i;
        model.tagText = text;
        CGFloat tagWidth = tagSize.width + self.tagConfig.padding.left + self.tagConfig.padding.right;
        if (self.tagConfig.tagMaxWidth > 0 && self.tagConfig.tagMaxWidth < (tagSize.width + self.tagConfig.padding.left + self.tagConfig.padding.right)) {
            tagWidth = self.tagConfig.tagMaxWidth;
        }
        model.tagSize = self.tagConfig.tagType == XGTagTypeFixedSize ? self.tagConfig.fixedSize : CGSizeMake(tagWidth, tagSize.height + self.tagConfig.padding.top + self.tagConfig.padding.bottom);
        [self.dataSourceArray addObject:model];
    }
}

/** 计算字符串的size */
- (CGSize)calculateString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize {
    // 影响文字大小的因素有：
    // 1.跟文字的字体大小有关
    // 2.跟它限定的宽度有关，宽度越窄，高度越高
    // 第一个参数：传入一个 CGSize 用来限定它最大的宽度是多少，最大的高度是多少
    // 如果没有达到最大的宽度和最大的高度，那么返回实际尺寸，如果超过了你限定的最大宽度和高度，那么只会返回你最大的宽度和高度
    // 第二个参数：直接传 NSStringDrawingUsesLineFragmentOrigin 就可以，因为它既可以计算单行，也可以计算多行
    // 第三个参数：传入一个字典，这个字典就是让你设置字体的大小的，或者字体颜色
    return [string boundingRectWithSize:maxSize
                                options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:@{NSFontAttributeName : font}
                                context:nil].size;
}

#pragma mark - Getter&Setter

- (XGCollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = ({
            XGCollectionViewFlowLayout *flowLayout = [[XGCollectionViewFlowLayout alloc] init];
            flowLayout.userMaxIinteritemSpacing = !self.tagConfig.isSpacingAdaptive;
            flowLayout.maxIinteritemSpacing = self.tagConfig.interitemSpacing;
            flowLayout;
        });
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = ({
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
            collectionView.backgroundColor = [UIColor whiteColor];
            collectionView.showsVerticalScrollIndicator = NO;
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.delegate = self;
            collectionView.dataSource = self;
            [collectionView registerClass:[XGTagCell class]
               forCellWithReuseIdentifier:NSStringFromClass([XGTagCell class])];
            collectionView;
        });
    }
    return _collectionView;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (NSMutableArray *)multipleChoiceModelArray {
    if (!_multipleChoiceModelArray) {
        _multipleChoiceModelArray = [[NSMutableArray alloc] init];
    }
    return _multipleChoiceModelArray;
}

@end

@implementation XGTagCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.backgroundImageView];
        [self.contentView addSubview:self.tagLabel];
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setTagConfig:(XGTagConfig *)tagConfig {
    _tagConfig = tagConfig;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = self.tagConfig.borderRadius;
    self.tagLabel.font = tagConfig.tagFont;
    self.tagLabel.lineBreakMode = tagConfig.lineBreakMode;
    self.tagLabel.numberOfLines = tagConfig.numberOfLines ? tagConfig.numberOfLines : 1;
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(tagConfig.padding.top);
        make.bottom.offset(-tagConfig.padding.bottom);
        make.leading.offset(tagConfig.padding.left);
        make.trailing.offset(-tagConfig.padding.right);
    }];
}

- (void)setModel:(XGTagModel *)model {
    _model = model;
    self.tagLabel.text = model.tagText;
    [self.tagLabel sizeToFit];
    self.tagLabel.textColor = model.isSelected ? self.tagConfig.selectedTextColor : self.tagConfig.normalTextColor;
    if (self.tagConfig.normalBgColor) {
        self.contentView.backgroundColor = model.isSelected ? self.tagConfig.selectedBgColor : self.tagConfig.normalBgColor;
    } else if (self.tagConfig.normalBgImage) {
        self.backgroundImageView.image = model.isSelected ? self.tagConfig.selectedBgImage : self.tagConfig.normalBgImage;
    } else if (self.tagConfig.normalBorderColor && self.tagConfig.borderWidth) {
        self.contentView.layer.borderWidth = model.isSelected ? self.tagConfig.borderWidth : 0;
        self.contentView.layer.borderColor = model.isSelected ? self.tagConfig.normalBorderColor.CGColor : [UIColor clearColor].CGColor;
    }
    self.backgroundImageView.hidden = !self.tagConfig.normalBgImage;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _tagLabel;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView;
        });
    }
    return _backgroundImageView;
}

@end

@implementation XGCollectionViewFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    if (!self.isUserMaxIinteritemSpacing) return [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for (int i = 1; i < attributes.count; i++){
        //当前attributes
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        //上一个attributes
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
        //我们想设置的最大间距，可根据需要改
        NSInteger maximumSpacing = self.maxIinteritemSpacing;
        //前一个cell的最右边
        NSInteger prevorigin = CGRectGetMaxX(prevLayoutAttributes.frame);
        //如果是分组进行跳过
        NSInteger curIndex = currentLayoutAttributes.indexPath.section;
        NSInteger preIndex = prevLayoutAttributes.indexPath.section;
        if (curIndex != preIndex) {
            continue;
        }
        //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
        //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
        if(prevorigin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width){
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = prevorigin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
            //            NSLog(@"currentLayoutAttributes.frame =%@",NSStringFromCGRect(currentLayoutAttributes.frame));
        }
    }
    return attributes;
}

@end

@implementation XGTagConfig

- (instancetype)init {
    if (self = [super init]) {
        _userInteractionEnabled = YES;
    }
    return self;
}

@end

@implementation XGTagModel

@end
