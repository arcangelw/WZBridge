//
//  WZCallInfo.h
//  WZBridge
//
//  Created by 吴哲 on 2018/12/11.
//  Copyright © 2018 arcangelw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JSCompletionHandler)(NSString * _Nullable result,NSError * _Nullable error);
@class WWKWebView;
@interface WJSCallFunction : NSObject

@property (nullable ,nonatomic, weak) WWKWebView *webView;
@property (nonatomic, copy) NSString *callFuncId;
/// default YES
@property (nonatomic, assign) BOOL removeAfterExecute;

- (instancetype)initWithWebView:(WWKWebView *)webView;

- (void)execute;
- (void)executeCompletionHandler:(nullable JSCompletionHandler)completionHandler;
- (void)executeWithParam:(nullable NSString *)param;
- (void)executeWithParam:(nullable NSString *)param completionHandler:(nullable JSCompletionHandler)completionHandler;
- (void)executeWithParams:(nullable NSArray<NSString *> *)params;
- (void)executeWithParams:(nullable NSArray<NSString *> *)params completionHandler:(nullable JSCompletionHandler)completionHandler;
@end


NS_ASSUME_NONNULL_END
