//
//  UILabel+XGAdd.h
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (XGAdd)

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

/**
 两端对齐
 */
- (void)textAlignmentLeftAndRight;

/**
 指定Label以最后的冒号对齐的width两端对齐
 (使用时应注意要在给Lable的frame，text设置完之后再使用，默认使用textAlignmentLeftAndRight即可。若有其他指定宽度要设置，可使用- (void)textAlignmentLeftAndRightWith:(CGFloat)labelWidth;  若结尾文字以其他固定文字结尾，可替换冒号再使用)

 @param labelWidth labelWidth
 */
- (void)textAlignmentLeftAndRightWith:(CGFloat)labelWidth endString:(NSString *)endString;


@end

NS_ASSUME_NONNULL_END
