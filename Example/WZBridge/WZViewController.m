//
//  WZViewController.m
//  WZBridge
//
//  Created by arcangelw on 12/11/2018.
//  Copyright (c) 2018 arcangelw. All rights reserved.
//

#import "WZViewController.h"
#import "WZObjCApiTest.h"
#import "WZBridge_Example-Swift.h"

@interface WZViewController ()
@property(nonatomic ,strong) WWKWebView *webView;
/// ocTest
@property(nonatomic ,strong) WZObjCApiTest *ocTest;
/// swiftTest
@property(nonatomic ,strong) WZSwiftApiTest *swiftTest;
@end

@implementation WZViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    _webView = [[WWKWebView alloc] initWithFrame:self.view.bounds];
    [_webView setDebugMode:YES];
    [self.view addSubview:_webView];

    _ocTest = [[WZObjCApiTest alloc] init];
    [_webView addJavascriptObject:_ocTest namespace:@"toObjC"];
    _swiftTest = [[WZSwiftApiTest alloc] init];
    [_webView addJavascriptObject:_swiftTest namespace:@"toSwift"];

    [_webView setDialogText:@"启禀陛下:" forKey:WWKWebViewDialogKeyAlertTitle];
    [_webView setDialogText:@"朕知道了" forKey:WWKWebViewDialogKeyAlertBtn];
    [_webView setDialogText:@"!!!" forKey:WWKWebViewDialogKeyConfirmTitle];
    
    [_webView addObserverForType:WWObserverTypeTitle block:^(id  _Nonnull value) {
        NSLog(@"block title is :%@",value);
    }];
     [_webView addObserverForType:WWObserverTypeTitle target:self selector:@selector(addTitle:)];
    [_webView addObserverForType:WWObserverTypeProgress block:^(id  _Nonnull value) {
        NSLog(@"block progress is :%@",value);
    }];
    [_webView addObserverForType:WWObserverTypeProgress target:self selector:@selector(addProgress:)];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    [_webView loadHTMLString:[NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil] baseURL:baseURL];
    
}
- (void)addTitle:(NSString *)title
{
    NSLog(@"target title is :%@",title);
}

- (void)addProgress:(id)value
{
    NSLog(@"target progress is :%@",value);
}

@end
