# WZBridge

[![CI Status](https://img.shields.io/travis/arcangelw/WZBridge.svg?style=flat)](https://travis-ci.org/arcangelw/WZBridge)
[![Version](https://img.shields.io/cocoapods/v/WZBridge.svg?style=flat)](https://cocoapods.org/pods/WZBridge)
[![License](https://img.shields.io/cocoapods/l/WZBridge.svg?style=flat)](https://cocoapods.org/pods/WZBridge)
[![Platform](https://img.shields.io/cocoapods/p/WZBridge.svg?style=flat)](https://cocoapods.org/pods/WZBridge)

## Example

A simple javascript and native interaction bridge WKWebView
 
Inspired by [EasyJSWebView](https://github.com/dukeland/EasyJSWebView)  an [dsBridge](https://github.com/wendux/DSBridge-IOS)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage
1. Implement APIs in a class 

```ObjC
@protocol WZObjCApiTestExport <WZJSExport>
@required
- (void)callSyn;
- (NSString *)callSyn:(NSString *)msg;
- (void)callAsyn:(NSString *)msg :(WJSCallFunction *)func;
- (void)callAsyn:(WJSCallFunction *)func;
@optional
- (void)callProgress:(WJSCallFunction *)func;
@end

@interface WZObjCApiTest : NSObject<WZObjCApiTestExport>
@end
@implementation WZObjCApiTest
{
    NSTimer *_timer;
    int _t;
    WJSCallFunction *_func;
}
#pragma mark - to implement protocol method
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
        [_func executeWithParam:@""];
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
```
2. add API object to WWKWebView 

```ObjC
WWKWebView *webView = [WWKWebView new];
[webView addJavascriptObject:[WZObjCApiTest new] namespace:@"toObjC"];
/// custom dialogText
[webView setDialogText:@"启禀陛下:" forKey:WWKWebViewDialogKeyAlertTitle];
/// monitor title or progress 
[webView addObserverForType:WWObserverTypeProgress block:^(id  _Nonnull value) {
        NSLog(@"block progress is :%@",value);
 }];
[webView addObserverForType:WWObserverTypeTitle target:self selector:@selector(setTitle:)]; 
```
3. Call Native (ObjC/Swift) API in Javascript

```js
toObjC.callSyn()

var fromObjC = toObjC.callSyn("Hellow! I'm js!")

toObjC.callAsyn("Hellow! I'm js!",function(v){
    return "OK ,I received your message:" + v;
})

toObjC.callAsyn(function(v){
    return "OK ,I received your message:" + v;
})
```

## Installation

WZBridge is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WZBridge'
```

## Author

arcangelw, wuzhezmc@gmail.com

## License

WZBridge is available under the MIT license. See the LICENSE file for more info.
