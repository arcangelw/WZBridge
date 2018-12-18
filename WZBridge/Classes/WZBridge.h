//
//  WZBridge.h
//  WZBridge
//
//  Created by 吴哲 on 2018/12/11.
//  Copyright © 2018 arcangelw. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<WZBridge/WZBridge.h>)
FOUNDATION_EXPORT double WZBridgeVersionNumber;
FOUNDATION_EXPORT const unsigned char WZBridgeVersionString[];
#import <WZBridge/WJSCallFunction.h>
#import <WZBridge/WUtil.h>
#import <WZBridge/WWKWebView.h>
#else
#import "WJSCallFunction.h"
#import "WUtil.h"
#import "WWKWebView.h"
#endif
