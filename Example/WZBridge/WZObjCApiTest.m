//
//  WZObjCApiTest.m
//  WZBridge_Example
//
//  Created by 吴哲 on 2018/12/12.
//  Copyright © 2018 arcangelw. All rights reserved.
//

#import "WZObjCApiTest.h"

@implementation WZObjCApiTest
{
    NSTimer *_timer;
    int _t;
    WJSCallFunction *_func;
}
- (void)callAsyn:(nonnull WJSCallFunction *)func {
    NSLog(@"%s  Hello, I am js",__func__);
    [func executeWithParam:@"hellow js ,I am ObjC ,I received your message" completionHandler:^(NSString * _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",result);
    }];
}

- (void)callAsyn:(nonnull NSString *)msg :(nonnull WJSCallFunction *)func {
    NSLog(@"%s  Hello, I am js",__func__);
    [func executeWithParam:[NSString stringWithFormat:@"hellow js ,I am ObjC ,I received your message:%@",msg] completionHandler:^(NSString * _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",result);
    }];
}

- (void)callSyn {
    NSLog(@"%s  Hello, I am js",__func__);
}

- (nonnull NSString *)callSyn:(nonnull NSString *)msg {
    NSLog(@"%s  Hello, I am js",__func__);
    return [NSString stringWithFormat:@"hellow js ,I am ObjC ,I received your message:%@",msg];
}

- (void)callProgress:(WJSCallFunction *)func
{
    if (_func) {
        [_timer invalidate];
        _timer = nil;
        _func.removeAfterExecute = YES;
        [_func executeWithParam:@"" completionHandler:nil];
    }
    _func = func;
    _func.removeAfterExecute = NO;
    _t = 10;
    [_func executeWithParam:@(_t).stringValue completionHandler:nil];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(onTimer:)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)onTimer:(NSTimer *)timer
{
    _t--;
    NSLog(@"%d",_t);
    if (_t > 0) {
        [_func executeWithParam:@(_t).stringValue];
    }else{
        _func.removeAfterExecute = YES;
        [_func executeWithParam:@(0).stringValue];
        [_timer invalidate];
        _timer = nil;
    }
}
@end
