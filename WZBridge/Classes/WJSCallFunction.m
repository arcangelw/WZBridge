//
//  WZCallFunction.m
//  WZBridge
//
//  Created by 吴哲 on 2018/12/11.
//  Copyright © 2018 arcangelw. All rights reserved.
//

#import "WJSCallFunction.h"
#import "WWKWebView.h"

@implementation WJSCallFunction

- (instancetype)initWithWebView:(WWKWebView *)webView
{
    self = [super init];
    if (self) {
        _webView = webView;
        _removeAfterExecute = YES;
    }
    return self;
}

- (void)execute
{
    return [self executeCompletionHandler:nil];
}

- (void)executeCompletionHandler:(JSCompletionHandler)completionHandler
{
    return [self executeWithParam:nil completionHandler:completionHandler];
}

- (void)executeWithParam:(NSString *)param
{
    return [self executeWithParam:param completionHandler:nil];
}

- (void)executeWithParam:(NSString *)param completionHandler:(JSCompletionHandler)completionHandler
{
    return [self executeWithParams:param?@[param]:nil completionHandler:completionHandler];
}

- (void)executeWithParams:(NSArray<NSString *> *)params
{
    return [self executeWithParams:params completionHandler:nil];
}

- (void)executeWithParams:(NSArray<NSString *> *)params completionHandler:(JSCompletionHandler)completionHandler
{
    NSMutableString *callJs = [[NSMutableString alloc] init];

    [callJs appendFormat:@"wkbridge.invokeCallback(\"%@\", %@", self.callFuncId, self.removeAfterExecute ? @"true" : @"false"];
    if (params){
        for (NSUInteger i = 0, l = params.count; i < l; i++){
            NSString *arg = [params objectAtIndex:i];
            NSString *encodedArg = [arg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"]];
            [callJs appendFormat:@", \"%@\"", encodedArg];
        }
    }
    
    [callJs appendString:@");"];
    
    if (self.webView){;
        [self.webView evaluateJavaScript:callJs.copy completionHandler:^(id _Nullable value, NSError * _Nullable error) {
            if (error) {
                NSLog(@"callBack js error: %@",error);
            }
            if (completionHandler) {
                completionHandler(value,error);
            }
        }];
    }else{
        if (completionHandler) {
            NSError *error = [NSError errorWithDomain:@"webView dealloc" code:-1 userInfo:nil];
            completionHandler(nil,error);
        }
    }
}
@end
