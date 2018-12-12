//
//  WWKWebView.m
//  WZBridge
//
//  Created by 吴哲 on 2018/12/11.
//  Copyright © 2018 arcangelw. All rights reserved.
//

#import "WWKWebView.h"
#import "WZUtil.h"
#import "WJSCallFunction.h"

@interface WWKUserScript : WKUserScript
/// namespace
@property(nonatomic ,copy) NSString *namespace;
@end
@implementation WWKUserScript
@end

@interface _WZWeakObject : NSObject
/// value
@property(nonatomic ,weak) id<WZJSExport> value;
- (instancetype)initWith:(id<WZJSExport>)value;
@end
@implementation _WZWeakObject
- (instancetype)initWith:(id<WZJSExport>)value
{
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}
@end


WWKWebViewDialogKey  const  WWKWebViewDialogKeyAlertTitle = @"WWKWebViewDialogKeyAlertTitle";
WWKWebViewDialogKey  const  WWKWebViewDialogKeyAlertBtn = @"WWKWebViewDialogKeyAlertBtn";
WWKWebViewDialogKey  const  WWKWebViewDialogKeyConfirmTitle = @"WWKWebViewDialogKeyConfirmTitle";
WWKWebViewDialogKey  const  WWKWebViewDialogKeyConfirmOkBtn = @"WWKWebViewDialogKeyConfirmOkBtn";
WWKWebViewDialogKey  const  WWKWebViewDialogKeyConfirmCancelBtn = @"WWKWebViewDialogKeyConfirmCancelBtn";
WWKWebViewDialogKey  const  WWKWebViewDialogKeyPromptOkBtn = @"WWKWebViewDialogKeyPromptOkBtn";
WWKWebViewDialogKey  const  WWKWebViewDialogKeyPromptCancelBtn = @"WWKWebViewDialogKeyPromptCancelBtn";


@interface WWKWebView()<WKUIDelegate>
/// orig
@property(nonatomic ,weak) id<WKUIDelegate> orig;
/// namespaceInterfaces
@property(nonatomic ,copy) NSMutableDictionary<NSString *,_WZWeakObject *> *namespaceInterfaces;
/// dialogTextDic
@property(nonatomic ,copy) NSDictionary<NSString *,NSString *> *dialogInfo;
@end
@implementation WWKWebView
{
    BOOL _isDebug;
}

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration
{
    NSString *js = [NSString stringWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"wkbridge" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil];
    js = js?:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wkbridge" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil];
    NSAssert(js!=nil, @"wkbridge.js is missing");
    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                               forMainFrameOnly:YES];
    [configuration.userContentController addUserScript:script];
    self = [super initWithFrame:frame configuration:configuration];
    if (self) {
        super.UIDelegate = self;
        _namespaceInterfaces = @{}.mutableCopy;
        _dialogInfo = @{}.copy;
        _isDebug = NO;
    }
    return self;
}

- (void)dealloc
{
    [_namespaceInterfaces removeAllObjects];
}

- (void)setUIDelegate:(id<WKUIDelegate>)UIDelegate
{
    self.orig = UIDelegate;
}

#pragma mark - WKUIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (self.orig && [self.orig respondsToSelector:@selector(webView:createWebViewWithConfiguration:forNavigationAction:windowFeatures:)]) {
        return [self.orig webView:webView createWebViewWithConfiguration:configuration forNavigationAction:navigationAction windowFeatures:windowFeatures];
    }
    return nil;
}

- (void)webViewDidClose:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0))
{
    if (self.orig && [self.orig respondsToSelector:@selector(webViewDidClose:)]) {
        return [self.orig webViewDidClose:webView];
    }
}

- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo API_AVAILABLE(ios(10.0))
{
    if (self.orig && [self.orig respondsToSelector:@selector(webView:shouldPreviewElement:)]) {
        return [self.orig webView:webView shouldPreviewElement:elementInfo];
    }
    return NO;
}

- (nullable UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions API_AVAILABLE(ios(10.0))
{
    if(self.orig && [self.orig respondsToSelector:@selector(webView:previewingViewControllerForElement:defaultActions:)]) {
        return [self.orig webView:webView previewingViewControllerForElement:elementInfo defaultActions:previewActions];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController API_AVAILABLE(ios(10.0))
{
    if (self.orig && [self.orig respondsToSelector:@selector(webView:commitPreviewingViewController:)]) {
        [self.orig webView:webView commitPreviewingViewController:previewingViewController];
    }
}

#pragma mark - WKUIDelegate && runJavaScript

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    if (self.orig && [self.orig respondsToSelector:@selector(webView:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:)]) {
        [self.orig webView:webView runJavaScriptAlertPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler];
    }else{
        UIViewController *vc = [self _viewController];
        NSAssert(vc != nil, @"Cannot find current view controller");
        NSString *title = _dialogInfo[WWKWebViewDialogKeyAlertTitle] ?: @"提示";
        NSString *actionTitle = _dialogInfo[WWKWebViewDialogKeyAlertBtn] ?: @"确定";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (completionHandler) {
                completionHandler();
            }
        }];
        [alert addAction:action];
        [vc presentViewController:alert animated:YES completion:nil];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    if (self.orig && [self.orig respondsToSelector:@selector(webView:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:)]) {
        [self.orig webView:webView runJavaScriptConfirmPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler];
    }else{
        UIViewController *vc = [self _viewController];
        NSAssert(vc != nil, @"Cannot find current view controller");
        NSString *title = _dialogInfo[WWKWebViewDialogKeyConfirmTitle] ?: @"提示";
        NSString *cancelTitle = _dialogInfo[WWKWebViewDialogKeyConfirmCancelBtn] ?: @"取消";
        NSString *okTitle = _dialogInfo[WWKWebViewDialogKeyConfirmOkBtn] ?: @"确定";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (completionHandler) {
                completionHandler(NO);
            }
        }];
        [alert addAction:cancelAction];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (completionHandler) {
                completionHandler(YES);
            }
        }];
        [alert addAction:okAction];
        [vc presentViewController:alert animated:YES completion:nil];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler
{
    NSString *prefix = @"_wkbridge-js:";
    if ([prompt hasPrefix:prefix]) {
        NSString *namespace= [prompt substringFromIndex:[prefix length]];
        NSString *result = nil;
        if (_isDebug) {
            result = [self performNamespace:namespace defaultText:defaultText];
        }else{
            @try {
                result = [self performNamespace:namespace defaultText:defaultText];
            } @catch (NSException *exception) {
                NSLog(@"js to oc error: %@",exception);
            }
        }
        completionHandler(result);
        
    }else{
        if (self.orig && [self.orig respondsToSelector:@selector(webView:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:)]) {
            [self.orig webView:webView runJavaScriptTextInputPanelWithPrompt:prompt defaultText:defaultText initiatedByFrame:frame completionHandler:completionHandler];
        }else{
            UIViewController *vc = [self _viewController];
            NSAssert(vc != nil, @"Cannot find current view controller");
            NSString *cancelTitle = _dialogInfo[WWKWebViewDialogKeyPromptCancelBtn] ?: @"取消";
            NSString *okTitle = _dialogInfo[WWKWebViewDialogKeyPromptOkBtn] ?: @"确定";
            __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.text = defaultText;
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (completionHandler) {
                    completionHandler(@"");
                }
            }];
            [alert addAction:cancelAction];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (completionHandler) {
                    completionHandler(alert.textFields.firstObject.text);
                }
            }];
            [alert addAction:okAction];
            [vc presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark - uiview
- (UIViewController *)_viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

#pragma mark - addJavascriptObject

- (void)addJavascriptObject:(id<WZJSExport>)object namespace:(NSString *)namespace
{
    NSString *js = [WZUtil toJSFunctionInject:object namespace:namespace];
    if (js.length) {
        WWKUserScript *script = [[WWKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                     forMainFrameOnly:YES];
        script.namespace = namespace;
        [self.configuration.userContentController addUserScript:script];
    }
    _namespaceInterfaces[namespace] = [[_WZWeakObject alloc] initWith:object];
}

- (void)removeJavascriptObject:(NSString *)namespace
{
    NSArray<WKUserScript *> *userScripts = self.configuration.userContentController.userScripts;
    [self.configuration.userContentController removeAllUserScripts];
    for (WKUserScript *script in userScripts) {
        if ([script isKindOfClass:WWKUserScript.class] && [((WWKUserScript *)script).namespace isEqualToString:namespace]) {
#if DEBUG
            NSLog(@"removeJavascriptObject namespace:%@ successfully",namespace);
#endif
        }else{
            [self.configuration.userContentController addUserScript:script];
        }
    }
}

- (void)setDialogText:(NSString *)value forKey:(WWKWebViewDialogKey)key
{
    NSMutableDictionary<NSString *,NSString *> *dialogInfo = _dialogInfo.mutableCopy;
    dialogInfo[key] = value;
    _dialogInfo = dialogInfo.copy;
}

- (void)setDebugMode:(BOOL)debug
{
    _isDebug = debug;
}
#pragma mark - JS to OC

- (NSString *)performNamespace:(NSString *)namespace defaultText:(NSString *)defaultText
{
    id<WZJSExport> object = _namespaceInterfaces[namespace].value;
    if (!object) {
        NSLog(@"namespace:%@ JavascriptObject not find",namespace);
        return nil;
    }
    NSDictionary *dict = [WZUtil toJSON:defaultText];
    NSString *methodName = dict[@"func"];
    NSArray *args = dict[@"args"];
    SEL sel = NSSelectorFromString(methodName);
    id result = nil;
    if ([object respondsToSelector:sel]) {
        do {
            NSMethodSignature* sig = [[object class] instanceMethodSignatureForSelector:sel];
            NSInvocation* invoker = [NSInvocation invocationWithMethodSignature:sig];
            invoker.selector = sel;
            invoker.target = object;
            NSMutableArray *argsCache = @[].mutableCopy;
            if (args.count) {
                NSInteger i = 2;
                for (id arg in args) {
                    NSAssert([arg isKindOfClass:NSString.class] || [arg isKindOfClass:NSDictionary.class], @"arg only is NSString or NSDictionary");
                    if ([arg isKindOfClass:NSString.class]) {
                        NSString *v = (NSString *)arg;
                        v = v.stringByRemovingPercentEncoding;
                        [argsCache addObject:v];
                        [invoker setArgument:&v atIndex:i];
                    }else{
                        NSString *callFuncId = ((NSDictionary *)arg)[@"id"];
                        WJSCallFunction *func = [[WJSCallFunction alloc] initWithWebView:self];
                        func.callFuncId = callFuncId;
                        [argsCache addObject:func];
                        [invoker setArgument:&func atIndex:i];
                    }
                    i++;
                }
            }
            [invoker invoke];
            
            const char *sigReturnType = sig.methodReturnType;
            if ([sig methodReturnLength] > 0 && strcmp(sigReturnType, @encode(id)) == 0){
                
                void *retValue = NULL;
                [invoker getReturnValue:&retValue];
                result = (__bridge id)retValue;
                NSAssert(!result || [result isKindOfClass:NSString.class], @"result only is NSString");
                result = [WZUtil toResultJSONString:result];
            }

        } while (0);
    }else {
        NSString *error = [NSString stringWithFormat:@"Error! \n Method %@ is not invoked,since there is not a implementation for it at (namespace:%@ JavascriptObject)",methodName,namespace];
        if (_isDebug) {
            NSString *js = [error stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            js = [NSString stringWithFormat:@"window.alert(decodeURIComponent(\"%@\"));",js];
            [self evaluateJavaScript:js completionHandler:nil];
        }
        NSLog(@"%@", error);
    }
    
    return result;
}

@end
