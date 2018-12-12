//
//  WZObjCApiTest.h
//  WZBridge_Example
//
//  Created by 吴哲 on 2018/12/12.
//  Copyright © 2018 arcangelw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WZBridge/WWKWebView.h>
#import <WZBridge/WJSCallFunction.h>

NS_ASSUME_NONNULL_BEGIN
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

NS_ASSUME_NONNULL_END
