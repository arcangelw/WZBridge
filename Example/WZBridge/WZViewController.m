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
    [self.view addSubview:_webView];

    _ocTest = [[WZObjCApiTest alloc] init];
    [_webView addJavascriptObject:_ocTest namespace:@"toObjC"];
    _swiftTest = [[WZSwiftApiTest alloc] init];
    [_webView addJavascriptObject:_swiftTest namespace:@"toSwift"];

    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    [_webView loadHTMLString:[NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil] baseURL:baseURL];
}

@end
