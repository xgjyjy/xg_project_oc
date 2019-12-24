//
//  XGEmailManager.m
//  XG_Feedback
//
//  Created by 伙伴行 on 2019/12/17.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGEmailManager.h"
#import <skpsmtpmessage/NSData+Base64Additions.h>
#import <skpsmtpmessage/skpsmtpmessage.h>

@interface XGEmailManager ()<SKPSMTPMessageDelegate>

@end

@implementation XGEmailManager

+ (XGEmailManager *)shareInstance {
    static dispatch_once_t onceToken;
    static XGEmailManager *emailManager;
    dispatch_once(&onceToken, ^{
        emailManager = [[XGEmailManager alloc] init];
        emailManager.isWantsSecure = YES;
        emailManager.isRequiresAuth = YES;
    });
    return emailManager;
}

#pragma mark - SKPSMTPMessageDelegate

- (void)messageSent:(SKPSMTPMessage *)message {
    NSLog(@"发送邮件成功了");
    if ([self.delegate respondsToSelector:@selector(xg_messageSent:)]) {
        [self.delegate xg_messageSent:self];
    }
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error {
    NSLog(@"发送邮件失败了");
    if ([self.delegate respondsToSelector:@selector(xg_messageFailed:error:)]) {
        [self.delegate xg_messageFailed:self error:error];
    }
}

#pragma mark - PublicMethods

/** 发送邮件 */
- (void)sendEmailWithContent:(NSString *)content
                  imageDatas:(nonnull NSArray<NSData *> *)imageDatas
                  imageNames:(nonnull NSArray<NSString *> *)imageNames {
    /** 设置邮件内容 */
    NSDictionary *plainPart = @{kSKPSMTPPartContentTypeKey : @"text/plain; charset=UTF-8",
                                kSKPSMTPPartMessageKey : content,
                                kSKPSMTPPartContentTransferEncodingKey : @"8bit"};
    
    NSMutableArray *emailParts = [[NSMutableArray alloc] initWithObjects:plainPart, nil];
    
    /** 设置附件 */
    if ([imageDatas isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < imageDatas.count; i++) {
            NSData *imageData = [imageDatas objectAtIndex:i];
            NSString *imageName = [imageNames objectAtIndex:i];
            NSString *imagePart = [NSString stringWithFormat:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"%@.jpg\"",imageName];
            NSString *attachmentPart = [NSString stringWithFormat:@"attachment;\r\n\tfilename=\"%@.jpg\"",imageName];
            NSDictionary *attachmentDict = @{kSKPSMTPPartContentTypeKey : imagePart,
                                             kSKPSMTPPartContentDispositionKey : attachmentPart,
                                             kSKPSMTPPartMessageKey : [imageData encodeBase64ForData],
                                             kSKPSMTPPartContentTransferEncodingKey : @"base64"};
            [emailParts addObject:attachmentDict];
        };
    }
    
    /** 初始化邮件并添加parts  */
    SKPSMTPMessage *emailMessage = [[SKPSMTPMessage alloc] init];
    emailMessage.delegate = self;
    emailMessage.fromEmail = self.fromEmail;
    emailMessage.pass = self.SMTPPassword;
    emailMessage.login = self.loginUserName;
    emailMessage.toEmail = self.toEmail;
    emailMessage.relayHost = self.relayHost;
    emailMessage.connectTimeout = self.connectTimeout;
    emailMessage.requiresAuth = self.isRequiresAuth;
    emailMessage.wantsSecure = self.isWantsSecure;
    emailMessage.subject = [NSString stringWithFormat:@"=?UTF-8?B?%@?=",[self base64EncodeString:self.emailSubject]];
    emailMessage.parts = emailParts;
    
    /** 发送邮件 (必须放在主线程调用,因为内部有runloop,主线程的Runloop是默认开启的，子线程需要调用[Runloop run]开启这个线程) */
    [emailMessage send];
}

- (NSString *)base64EncodeString:(NSString *)string{
    //1、先转换成二进制数据
    NSData *data =[string dataUsingEncoding:NSUTF8StringEncoding];
    //2、对二进制数据进行base64编码，完成后返回字符串
    return [data base64EncodedStringWithOptions:0];
}

#pragma mark - Getter&Setter

- (NSString *)fromEmail {
    return _fromEmail ? _fromEmail : @"xgAllLog@163.com";
}

- (NSString *)SMTPPassword {
    return _SMTPPassword ? _SMTPPassword : @"8307024lxlx";
}

- (NSString *)toEmail {
    return _toEmail ? _toEmail : @"xgjyjy@163.com";
}

- (NSString *)relayHost {
    return _relayHost ? _relayHost : @"smtp.163.com";
}

- (NSString *)loginUserName {
    return _loginUserName ? _loginUserName : @"xgAllLog";
}

- (NSInteger)connectTimeout {
    return _connectTimeout ? _connectTimeout : 30;;
}

- (NSString *)emailSubject {
    return _emailSubject ? _emailSubject : @"用户反馈问题了,快点查看吧!";
}

@end
