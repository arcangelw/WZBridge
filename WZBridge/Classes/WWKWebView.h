//
//  WWKWebView.h
//  WZBridge
//
//  Created by 吴哲 on 2018/12/11.
//  Copyright © 2018 arcangelw. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * WWKWebViewDialogKey;
UIKIT_EXTERN WWKWebViewDialogKey  const  WWKWebViewDialogKeyAlertTitle;
UIKIT_EXTERN WWKWebViewDialogKey  const  WWKWebViewDialogKeyAlertBtn;
UIKIT_EXTERN WWKWebViewDialogKey  const  WWKWebViewDialogKeyConfirmTitle;
UIKIT_EXTERN WWKWebViewDialogKey  const  WWKWebViewDialogKeyConfirmOkBtn;
UIKIT_EXTERN WWKWebViewDialogKey  const  WWKWebViewDialogKeyConfirmCancelBtn;
UIKIT_EXTERN WWKWebViewDialogKey  const  WWKWebViewDialogKeyPromptOkBtn;
UIKIT_EXTERN WWKWebViewDialogKey  const  WWKWebViewDialogKeyPromptCancelBtn;

typedef void(^WWObserverBlock)(id _Nonnull value);
typedef NSString * WWObserverType;
UIKIT_EXTERN WWObserverType const WWObserverTypeTitle;
UIKIT_EXTERN WWObserverType const WWObserverTypeProgress;

@protocol WZJSExport <NSObject>
@end

@interface WWKWebView : WKWebView

- (void)addJavascriptObject:(id<WZJSExport>)object namespace:(NSString *)namespace;
- (void)removeJavascriptObject:(NSString *)namespace;

- (void)setDialogText:(nullable NSString *)value forKey:(WWKWebViewDialogKey)key;

- (void)addObserverForType:(WWObserverType)type block:(nonnull WWObserverBlock)block;
- (void)addObserverForType:(WWObserverType)type target:(nonnull id)target selector:(nonnull SEL)selector;
- (void)removeObserverForType:(WWObserverType)type;
- (void)removeAllObservers;

- (void)setDebugMode:(BOOL)debug;

@end

NS_ASSUME_NONNULL_END
