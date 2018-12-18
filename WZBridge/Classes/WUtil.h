//
//  WUtil.h
//  WZBridge
//
//  Created by 吴哲 on 2018/12/11.
//  Copyright © 2018 arcangelw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WZJSExport;

@interface WUtil : NSObject

+ (nullable NSString *)toJSFunctionInject:(id<WZJSExport>)jsExport namespace:(NSString *)namespace;;

+ (NSDictionary *)toJSON:(nullable NSString *)text;
///{} or {result:result}
+ (NSString *)toResultJSONString:(nullable NSString *)result;
@end

NS_ASSUME_NONNULL_END
