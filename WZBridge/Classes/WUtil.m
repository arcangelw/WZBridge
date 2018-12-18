//
//  WUtil.m
//  WZBridge
//
//  Created by 吴哲 on 2018/12/11.
//  Copyright © 2018 arcangelw. All rights reserved.
//

#import "WUtil.h"
#import "WWKWebView.h"
#include <objc/runtime.h>


static inline NSArray<Protocol *> * _Nonnull _protocolListFrom(Class _Nullable class){
    NSMutableArray *protos = @[].mutableCopy;
    unsigned int count;
    Protocol *__unsafe_unretained* protocolList = class_copyProtocolList(class,&count);
    for (int i = 0; i < count; i++) {
        const char *protoChar = protocol_getName(protocolList[i]);
        NSString *protoName = [[NSString alloc] initWithUTF8String:protoChar];
        Protocol *proto = NSProtocolFromString(protoName);
        if (proto && protocol_conformsToProtocol(proto, @protocol(WZJSExport))) {
            [protos addObject:proto];
        }
    }
    free(protocolList);
    return protos.copy;
}

static inline NSArray<NSString *> * _Nonnull _protocolMethodFrom(Protocol * _Nonnull proto, BOOL isRequiredMethod, BOOL isInstanceMethod){
    NSMutableArray *methods = @[].mutableCopy;
    unsigned int count;
    struct objc_method_description *methodList = protocol_copyMethodDescriptionList(proto, isRequiredMethod, isInstanceMethod, &count);
    for (int i = 0; i < count; i++) {
        struct objc_method_description method = methodList[i];
        NSString *methodName = NSStringFromSelector(method.name);
        if (methodName) {
            [methods addObject:methodName];
        }
    }
    free(methodList);
    return methods.copy;
}

@implementation WUtil

+ (NSString *)toJSFunctionInject:(id<WZJSExport>)jsExport namespace:(NSString *)namespace;
{
    NSArray<Protocol *> *protos = _protocolListFrom(object_getClass(jsExport));
    if (protos.count) {
        NSMutableArray<NSString *> *methods = @[].mutableCopy;
        for (Protocol *proto in protos) {
            [methods addObjectsFromArray:_protocolMethodFrom(proto, YES, YES)];
            [methods addObjectsFromArray:_protocolMethodFrom(proto, NO, YES)];
        }
        NSSet<NSString *> *methodSet = [NSSet<NSString *> setWithArray:methods];
        if (methodSet.count) {
            NSMutableString* injection = [[NSMutableString alloc] init];
            [injection appendString:@"(function (){ wkbridge.inject(\""];
            [injection appendString:namespace];
            [injection appendString:@"\", ["];
            NSArray<NSString *> *list = methodSet.allObjects;
            for (int i = 0; i < list.count; i++) {
                [injection appendString:@"\""];
                [injection appendString:list[i]];
                [injection appendString:@"\""];
                if (i != list.count - 1){
                    [injection appendString:@", "];
                }
            }
            [injection appendString:@"]);}())"];
            return injection.copy;
        }
    }
    return nil;
}

+ (NSDictionary *)toJSON:(NSString *)text
{
    NSError *error = nil;
    id value = [NSJSONSerialization JSONObjectWithData:[text dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if (error) {
        NSLog(@"toJSON: error:%@", error);
    }
    return value;
}
+ (NSString *)toResultJSONString:(NSString *)result
{
    NSDictionary *rd = result?@{@"result":result}:@{};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:rd options:kNilOptions error:&error];
    if (error || !data) {
        NSLog(@"toResultJSONString: error:%@", error);
        return @"{}";
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end
