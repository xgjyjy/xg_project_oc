//
//  NSURL+XGAdd.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/5.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "NSURL+XGAdd.h"

/// image/resize,m_lfit,h_160,w_160
/// x-oss-process=style/place_ls
static NSString * const ossStyle = @"x-oss-process=style/place_ls";
static NSString * const ossStyle_and = @"&x-oss-process=style/place_ls";
static NSString * const ossStyleQuery = @"?x-oss-process=style/place_ls";

@implementation NSURL (XGAdd)

- (NSURL *)thumbImageURL {
    if (![self.host hasPrefix:@"img.cdn"] && ![self.host hasPrefix:@"hb-oss-public"]) return self;
    if (self.query.xg_isString && [self.query containsString:@"x-oss-process"]) return self;
    NSString *string = ossStyle;
    NSString *lastCharacter = [self.absoluteString substringWithRange:NSMakeRange(self.absoluteString.length - 1, 1)];
    if (self.query.xg_isString) {
        if (![lastCharacter isEqualToString:@"&"]) {
            string = ossStyle_and;
        }
    } else {
        if (![lastCharacter isEqualToString:@"?"]) {
            string = ossStyleQuery;
        }
    }
    return [NSURL URLWithString:[self.absoluteString stringByAppendingString:string]];
}

@end
