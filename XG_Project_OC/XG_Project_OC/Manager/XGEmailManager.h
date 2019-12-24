//
//  XGEmailManager.h
//  XG_Feedback
//
//  Created by 伙伴行 on 2019/12/17.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XGEmailManager;
@protocol XGEmailManagerDelegate <NSObject>

/// 发送成功
/// @param message 当前对象
- (void)xg_messageSent:(XGEmailManager *)message;

/// 发送失败
/// @param message 当前对象
/// @param error 错误
- (void)xg_messageFailed:(XGEmailManager *)message error:(NSError *)error;

@end

@interface XGEmailManager : NSObject

/// 代理
@property (nonatomic,   weak) id<XGEmailManagerDelegate> delegate;

/// 是否要求验证(默认yes)
@property (nonatomic, assign) BOOL isRequiresAuth;

/// 发送者邮箱(默认xgAllLog@163.com)
@property (nonatomic,   copy) NSString *fromEmail;

/// 发送者邮箱POP3/SMTP服务授权码(默认8307024lxlx)
@property (nonatomic,   copy) NSString *SMTPPassword;

/// 接收者邮箱(默认xgjyjy@163.com)
@property (nonatomic,   copy) NSString *toEmail;

/// 接受者邮箱的主机地址(默认smtp.163.com)
@property (nonatomic,   copy) NSString *relayHost;

/// 发送者邮箱的用户名(默认xgAllLog)
@property (nonatomic,   copy) NSString *loginUserName;

/// 邮件发送的超时时间(默认30s)
@property (nonatomic, assign) NSInteger connectTimeout;

/// 是否加密邮件(默认yes)
@property (nonatomic, assign) BOOL isWantsSecure;

/// 邮件主题(默认用户反馈)
@property (nonatomic,   copy) NSString *emailSubject;

/// 单例
+ (XGEmailManager *)shareInstance;

/// 发送邮件
/// @param content 邮件内容
/// @param imageDatas 图片数据集合
/// @param imageNames 图片名集合
- (void)sendEmailWithContent:(NSString*)content
                  imageDatas:(NSArray <NSData *> *)imageDatas
                  imageNames:(NSArray <NSString *> *)imageNames;

@end

NS_ASSUME_NONNULL_END
