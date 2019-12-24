//
//  XGWebViewController.m
//  XG_Project_OC
//
//  Created by 伙伴行 on 2019/12/21.
//  Copyright © 2019 XG_Project_OC. All rights reserved.
//

#import "XGWebViewController.h"
#import "XGSystemEventManager.h"
#import "NSString+XGAdd.h"
#import <YYCategories/NSDictionary+YYAdd.h>

#pragma mark - WeakScriptMessageDelegate(解决ScriptMessageHandler对控制器的强引用)

@interface WeakScriptMessageDelegate : NSObject <WKScriptMessageHandler>

@property (nonatomic, assign) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end

@implementation WeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    if (self = [super init]) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end

@interface XGWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

/// web容器
@property (nonatomic, strong) WKWebView *wkWebView;

/// 进度条
@property (nonatomic, strong) UIProgressView *progressView;

/// 分享按钮
@property (nonatomic, strong) UIButton *shareButton;

/// H5的风格
@property (nonatomic, assign) XGH5Style H5Style;

/// url
@property (nonatomic,   copy) NSString *webUrl;

/// 本地html的名称
@property (nonatomic,   copy) NSString *htmlName;

/// title
@property (nonatomic,   copy) NSString *vcTitle;

/// 是否加载导航失败
@property (nonatomic, assign) BOOL isFailProvisionalNavigation;

/// 是否需要返回rootVc
@property (nonatomic, assign) BOOL isNeedBackToRootVc;

@end

@implementation XGWebViewController

#pragma mark - LifeCycle

- (instancetype)initWithH5Style:(XGH5Style)style
                        vcTitle:(NSString *)vcTitle
                         webUrl:(NSString *)webUrl {
    if (self = [super init]) {
        _H5Style = style;
        _vcTitle = vcTitle;
        _webUrl = webUrl;
    }
    return self;
}

- (instancetype)initWithH5Style:(XGH5Style)style
                        vcTitle:(NSString *)vcTitle
                         webUrl:(NSString *)webUrl
             isNeedBackToRootVc:(BOOL)isNeedBackToRootVc {
    if (self = [super init]) {
        _H5Style = style;
        _vcTitle = vcTitle;
        _webUrl = webUrl;
        _isNeedBackToRootVc = isNeedBackToRootVc;
    }
    return self;
}

- (instancetype)initWithVcTitle:(NSString *)vcTitle
                       htmlName:(NSString *)htmlName {
    if (self = [super init]) {
        _H5Style = XGH5StyleiOSBack;
        _vcTitle = vcTitle;
        _htmlName = htmlName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
    if (self.webUrl.xg_isString) {
        NSString *urlString = [NSString getCompleteWebsite:self.webUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:30.f];
        [self.wkWebView loadRequest:request];
    } else if (self.htmlName.xg_isString) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:self.htmlName
                                                             ofType:@"html"];
        NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
        [self.wkWebView loadHTMLString:htmlCont baseURL:baseURL];
    }
    [self.wkWebView addObserver:self
                     forKeyPath:@"estimatedProgress"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    kWeakSelf(weakSelf);
    [self setNeedReloadBlock:^{
        if ([weakSelf.wkWebView canGoBack]) {
            [weakSelf.wkWebView reload];
        }
    }];
}

- (void)dealloc{
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    XLog(@"当前控制器销毁了%@",self);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (![object isEqual:self.wkWebView]) {
        return;
    }
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    XLog(@"name===%@,body===%@,userC===%@",message.name,message.body,userContentController)
    if ([message.name isEqualToString:@"getAppInfo"]) {/** 获取设备信息(包括版本号) */
        [self getAppInfoWithParameter:message];
    } else if ([message.name isEqualToString:@"getUserInfo"]) {/** 获取用户信息 */
        [self getUserInfoWithParameter:message];
    } else if ([message.name isEqualToString:@"phoneCall"]) {/** 拨打电话 */
        [self phoneCallWithParameter:message];
    } else if ([message.name isEqualToString:@"share"]) {/** 调用分享 */
        [self shareWithParameter:message];
    } else if ([message.name isEqualToString:@"changePage"]) {/** 调用系统跳转 */
        [self changePageWithParameter:message];
    } else if ([message.name isEqualToString:@"backPage"]) {/** 系统回退 */
        [self backPageWithParameter:message];
    } else if ([message.name isEqualToString:@"surroundMating"]) {/** 查看周边 */
        [self surroundMatingWithParameter:message];
    } else if ([message.name isEqualToString:@"hiddenNavigator"]) {/** 隐藏原生导航栏 */
        [self hiddenNavigator:message];
    }
}

/** 隐藏原生导航栏 */
- (void)hiddenNavigator:(WKScriptMessage *)parameter {
    self.navigationBarView.hidden = YES;
    self.wkWebView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    NSDictionary *dict = parameter.body;
    [self buddyCallBackWithId:[dict safeValue:@"callbackId"] data:nil];
}

/** 获取设备信息(包括版本号) */
- (void)getAppInfoWithParameter:(WKScriptMessage *)parameter {
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *platform = @"iOS";
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *screenSize = [NSString stringWithFormat:@"%.0f*%.0f" ,kScreenWidth ,kScreenHeight];
    NSString *screenScale = [NSString stringWithFormat:@"Scale=%.1f" ,[UIScreen mainScreen].scale];
    NSString *devicePlatform = [UIDevice currentDevice].model;
    NSString *deviceVersion = [NSString getDeviceVersion];
    NSString *userAgentValue = [NSString stringWithFormat:@"xuanzhiyi/%@(%@;%@;%@;%@;%@=%@)" ,appVersion ,platform ,systemVersion ,screenSize ,screenScale ,devicePlatform ,deviceVersion];
    NSDictionary *dict = parameter.body;
    [self buddyCallBackWithId:[dict safeValue:@"callbackId"]
                         data:@{@"phoneType":userAgentValue,@"versionName":appVersion}];
}

/** 获取用户信息、如id、token、电话、userName等 */
- (void)getUserInfoWithParameter:(WKScriptMessage *)parameter {
//    NSDictionary *dict = parameter.body;
//    id userInfo = [XGUserDefaultManager getUserDataAfterLogin];
//    if (![userInfo hb_isDictionary] || [userInfo count] == 0) {
//        userInfo = [NSNull null];
//    }
//    [self buddyCallBackWithId:[dict valueForCheckKey:@"callbackId"] data:userInfo];
}

/** 拨打电话 入參：phoneNumber : phoneNumber */
- (void)phoneCallWithParameter:(WKScriptMessage *)parameter {
    NSDictionary *dict = parameter.body;
    NSString *phoneNumber = [dict safeValue:@"phoneNumber"];
    [XGSystemEventManager callTelephone:phoneNumber completionHandler:nil];
    [self buddyCallBackWithId:[dict safeValue:@"callbackId"] data:nil];
}

/** 调用分享 入參：{url : file(url), title:""(分享标题), content:"分享内容", logo:(分享块的图片url)} */
- (void)shareWithParameter:(WKScriptMessage *)parameter {
//    if (![XGSDKManager canUseWxApi]) {
//        [self showTipsWithText:@"未安装微信，无法分享"];
//        return;
//    }
//    NSDictionary *dict = parameter.body;
//    XGShareFromType fromType = [[dict valueForCheckKey:@"type"] integerValue];
//    [XGShareManager shareToWebWithTitle:[dict valueForCheckKey:@"title"]
//                                 content:[dict valueForCheckKey:@"content"]
//                              shareImage:[dict valueForCheckKey:@"logo"]
//                                shareUrl:[dict valueForCheckKey:@"url"]
//                       currentController:self
//                           shareFromType:fromType];
//    [self buddyCallBackWithId:[dict valueForCheckKey:@"callbackId"] data:nil];
}

/** 调用系统跳转(H5跳原生界面) 入參：{url : url} */
- (void)changePageWithParameter:(WKScriptMessage *)parameter {
    NSDictionary *dict = parameter.body;
    NSString *urlString = [dict safeValue:@"url"];
    XGWebViewController *htmlVc = [[XGWebViewController alloc] initWithH5Style:XGH5StyleFullScreen vcTitle:nil webUrl:urlString];
    [self.navigationController pushViewController:htmlVc animated:YES];
    [self buddyCallBackWithId:[dict safeValue:@"callbackId"] data:nil];
}

/** 系统回退 入參：{needRefresh:1(1表示回退后刷新页面，0不刷新)} */
- (void)backPageWithParameter:(WKScriptMessage *)parameter {
    NSDictionary *dict = parameter.body;
    NSInteger needRefresh = [[dict safeValue:@"needRefresh"] integerValue];
    if (self.needReloadBlock && needRefresh == 1) {
        self.needReloadBlock();
    }
    [self navigationBarBackButtonClick:nil];
    [self buddyCallBackWithId:[dict safeValue:@"callbackId"] data:nil];
}

/** 查看周边 入參: {lng: '121.5273285', log: '31.21515044'} */
- (void)surroundMatingWithParameter:(WKScriptMessage *)parameter {
//    NSDictionary *dict = parameter.body;
//    CLLocationCoordinate2D point = CLLocationCoordinate2DMake([[dict valueForCheckKey:@"log"] doubleValue],[[dict valueForCheckKey:@"lng"] doubleValue]);
//    XGLocationViewController *locationVc = [[XGLocationViewController alloc] initAroundSearchMapWithPoint:point titleString:@"周边配套" mapTitle:[dict valueForCheckKey:@"address"] mapSubtitle:nil];
//    [self.navigationController pushViewController:locationVc animated:YES];
//    [self buddyCallBackWithId:[dict valueForCheckKey:@"callbackId"] data:nil];
}

/** H5调用原生方法后的,统一回调方法 入参: {code : 200,data:{versionName:1.0.0},mag: "success"} */
- (void)buddyCallBackWithId:(NSNumber *)callbackId data:(id)data {
    if (data == nil) {
        data = [NSNull null];
    }
    NSMutableDictionary *backData = [NSMutableDictionary new];
    [backData setValue:data forKey:@"data"];
    [backData setValue:@"200" forKey:@"code"];
    [backData setValue:@"success" forKey:@"msg"];
    
    NSString *jsonString = [backData jsonStringEncoded];/** 字典转json */
    NSString *jsString = [NSString stringWithFormat:@"buddyCallBack('%@','%@')",callbackId,jsonString];
    XLog(@"js===%@",jsString)
    [self.wkWebView evaluateJavaScript:jsString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        XLog(@"原生回调H5的结果%@\nerror:%@",result,error);
    }];
}

/// 失败的回调
- (void)buddyFailureCallbackWithId:(NSNumber *)callbackId  message:(NSString *)msg code:(NSString *)code data:(id)data {
    if (data == nil) {
        data = [NSNull null];
    }
    NSMutableDictionary *backData = [NSMutableDictionary new];
    [backData setValue:data forKey:@"data"];
    [backData setValue:code forKey:@"code"];
    [backData setValue:msg forKey:@"msg"];
    
    NSString *jsonString = [backData jsonStringEncoded];
    NSString *jsString = [NSString stringWithFormat:@"buddyCallBack('%@','%@')",callbackId,jsonString];
    
    [self.wkWebView evaluateJavaScript:jsString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        XLog(@"原生回调H5的结果%@\nerror:%@",result,error);
    }];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // 全屏模式下, 加载成功才会隐藏导航栏
    if (self.H5Style == XGH5StyleFullScreen && !self.navigationBarView.hidden && !_isFailProvisionalNavigation && self.webUrl.xg_isString) {
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationBarView.alpha = 0;
        } completion:^(BOOL finished) {
            self.navigationBarView.hidden = YES;
        }];
        _isFailProvisionalNavigation = NO;
    }
    
    XLog(@"加载完毕")
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error {
    XLog(@"加载失败")
    _isFailProvisionalNavigation = YES;
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"error(1)" ofType:@"html"];
    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
    [self.wkWebView loadHTMLString:htmlCont baseURL:baseURL];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    XLog(@"开始加载")
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    XLog(@"H5的alert:%@",message)
#ifdef DEBUG
    UIAlertController *ac = [UIAlertController new];
    ac.message = message;
    [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:ac animated:YES completion:nil];
#else
    completionHandler();
#endif
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(BOOL))completionHandler {
    completionHandler(YES);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(nonnull NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(NSString * _Nullable))completionHandler {
    completionHandler(defaultText);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = [url scheme];
    UIApplication *app = [UIApplication sharedApplication];
    if ([scheme isEqualToString:@"tel"]) {
        if ([app canOpenURL:url]) {
            [app openURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                decisionHandler(WKNavigationActionPolicyCancel);/** 一定要加上这句,否则会打开新页面 */
            });
            return;
        }
    }else if ([scheme isEqualToString:@"sms"]) {
        if ([app canOpenURL:url]) {
            [app openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - TargetAction

- (void)navigationBarBackButtonClick:(UIButton *)sender {
    if (self.isNeedBackToRootVc) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return ;
    }
    if ([self.wkWebView canGoBack] && !self.isBackToAppPage) {
        [self.wkWebView goBack];
    } else if (self.navigationController.topViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)shareButtonClick:(UIButton *)sender {
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareLogoUrl]]];
//    [XGShareManager shareToWebWithTitle:self.shareTitle
//                                 content:self.shareContent
//                              shareImage:image
//                                shareUrl:self.shareUrl
//                       currentController:self
//                           shareFromType:XGShareFromTypeOther];
}

#pragma mark - LayoutSubviews

- (void)configSubviews {
    self.wkWebView.scrollView.bounces = NO;
    [self.view addSubview:self.wkWebView];
    [self.view bringSubviewToFront:self.navigationBarView];
    self.navigationBarView.hidden = NO;
    [self showNavigationBarBackButton];
    if (self.isNeedBackToRootVc) {
        self.xg_enableDragBack = NO;
    }
    
    switch (self.H5Style) {
        case XGH5StyleiOSBack: {
            [self setTitleText:self.vcTitle];
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor xg_colorWithHexString:@"eaeaea"];
            lineView.frame = CGRectMake(0, kContentY - 0.5, kScreenWidth, 0.5);
            [self.navigationBarView addSubview:lineView];
            [self.navigationBarView addSubview:self.progressView];
            if (self.showShareButton) {
                [self.navigationBarView addSubview:self.shareButton];
                self.shareButton.frame = CGRectMake(kScreenWidth - 44, self.navigationBarView.height - 44, 44, 43);
            }
        }
            break;
        case XGH5StyleFullScreen: {
            CGFloat webViewH = kScreenHeight;
            CGFloat webViewY = 0;
            // [self setTitleText:@"选址易"];
            //            if (@available(iOS 11.0, *)) {
            //                UIEdgeInsets safeArea = [HBScreenAptation hb_keyWindowSafeAreaInsets];
            //                if (safeArea.top > 20) {
            //                    webViewY = safeArea.top - 20; // 穿透状态栏, 并适配iPhoneX 那些
            //                }
            //                webViewH -= webViewY;
            //            }
            
            self.wkWebView.frame = CGRectMake(0, webViewY, kScreenWidth, webViewH);
            [self.view addSubview:self.progressView];
        }
            break;
    }
    // 去除偏移
    [self scrollViewContentInsetAdjustmentNever:self.wkWebView.scrollView];
}

#pragma mark - Setter&Getter
- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        /** WKUserScriptInjectionTimeAtDocumentEnd为网页加载完成时注入 */
        NSString *path = [[NSBundle mainBundle] pathForResource:@"hook.js" ofType:nil];
        NSString *js = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        [config.userContentController addUserScript:script];
        WeakScriptMessageDelegate *weakDelegate = [[WeakScriptMessageDelegate alloc] initWithDelegate:self];
        [config.userContentController addScriptMessageHandler:weakDelegate name:@"getAppInfo"];
        [config.userContentController addScriptMessageHandler:weakDelegate name:@"getUserInfo"];
        [config.userContentController addScriptMessageHandler:weakDelegate name:@"enlargeImg"];
        [config.userContentController addScriptMessageHandler:weakDelegate name:@"phoneCall"];
        [config.userContentController addScriptMessageHandler:weakDelegate name:@"share"];
        [config.userContentController addScriptMessageHandler:weakDelegate name:@"changePage"];
        [config.userContentController addScriptMessageHandler:weakDelegate name:@"backPage"];
        [config.userContentController addScriptMessageHandler:weakDelegate name:@"surroundMating"];
        [config.userContentController addScriptMessageHandler:weakDelegate name:@"backTop"];
        [config.userContentController addScriptMessageHandler:weakDelegate name:@"hiddenNavigator"];
        [config.userContentController addScriptMessageHandler:weakDelegate name:@"nativeApp"];
        [config.userContentController addScriptMessageHandler:weakDelegate name:@"openIM"];
        [config.userContentController addScriptMessageHandler:weakDelegate name:@"getLoginStatus"];
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kContentY, kScreenWidth, kScreenHeight) configuration:config];
        _wkWebView.backgroundColor = [UIColor whiteColor];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
    }
    return _wkWebView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kContentY - 1, kScreenWidth, 1)];
        _progressView.tintColor = [UIColor redColor];
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"ic_share_dark"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

@end
