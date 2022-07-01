//
//  ATRuntimeTool.m
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/4/21.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import "ATRuntimeTool.h"
#import <objc/runtime.h>

@implementation ATRuntimeTool

/**
 获取对象的所有属性和属性内容

 @param obj 对象 @return 所有属性及属性内容 [NSDictionary *] */
+ (NSDictionary *)getAllPropertiesAndVaules:(NSObject *)obj
{
    NSMutableDictionary *propsDict = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *properties =class_copyPropertyList([obj class], &outCount);
    for ( int i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [obj valueForKey:(NSString *)propertyName];
        if (propertyValue) {
            [propsDict setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return propsDict;
}

/**
 获取指定类的属性

 @param cls 被获取属性的类
 @return 属性名称 [NSString *]
 */
NSArray * getClassProperty(Class cls) {

    if (!cls) return @[];

    NSMutableArray * all_p = [NSMutableArray array];

    unsigned int a;

    objc_property_t * result = class_copyPropertyList(cls, &a);

    for (unsigned int i = 0; i < a; i++) {
        objc_property_t o_t =  result[i];
        [all_p addObject:[NSString stringWithFormat:@"%s", property_getName(o_t)]];
    }

    free(result);

    return [all_p copy];
}

/**
 获取指定类（以及其父类）的所有属性

 @param cls 被获取属性的类
 @param until_class 当查找到此类时会停止查找，当设置为 nil 时，默认采用 [NSObject class]
 @return 属性名称 [NSString *]
 */
NSArray * getAllProperty(Class cls, Class until_class) {

    Class stop_class = until_class ?: [NSObject class];

    if (class_getSuperclass(cls) == stop_class) return @[];

    NSMutableArray * all_p = [NSMutableArray array];

    [all_p addObjectsFromArray:getClassProperty(cls)];

    if (class_getSuperclass(cls) == stop_class) {
        return [all_p copy];
    } else {
        [all_p addObjectsFromArray:getAllProperty([cls superclass], stop_class)];
    }

    return [all_p copy];
}

/**
 获取指定类的变量

 @param cls 被获取变量的类
 @return 变量名称集合 [NSString *]
 */
NSArray * getClassIvar(Class cls) {

    if (!cls) return @[];

    NSMutableArray * all_p = [NSMutableArray array];

    unsigned int a;

    Ivar * iv = class_copyIvarList(cls, &a);

    for (unsigned int i = 0; i < a; i++) {
        Ivar i_v = iv[i];
        [all_p addObject:[NSString stringWithFormat:@"%s", ivar_getName(i_v)]];
    }

    free(iv);

    return [all_p copy];
}

/**
 获取指定类（以及其父类）的所有变量

 @param cls 被获取变量的类
 @param until_class 当查找到此类时会停止查找，当设置为 nil 时，默认采用 [NSObject class]
 @return 变量名称集合 [NSString *]
 */
NSArray * getAllIvar(Class cls, Class until_class) {

    Class stop_class = until_class ?: [NSObject class];

    if (class_getSuperclass(cls) == stop_class) return @[];

    NSMutableArray * all_p = [NSMutableArray array];

    [all_p addObjectsFromArray:getClassIvar(cls)];

    if (class_getSuperclass(cls) == stop_class) {
        return [all_p copy];
    } else {
        [all_p addObjectsFromArray:getAllIvar([cls superclass], stop_class)];
    }

    return [all_p copy];
}


@end
