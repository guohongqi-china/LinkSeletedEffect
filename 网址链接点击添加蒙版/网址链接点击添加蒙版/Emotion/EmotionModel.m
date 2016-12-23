//
//  EmotionModel.m
//  图文混排
//
//  Created by MacBook on 16/12/14.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import "EmotionModel.h"
#import "NSString+Emoji.h"

@implementation EmotionModel
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"png"]) {
        _pathImage = [[[NSBundle mainBundle]pathForResource:@"Emoticons" ofType:@"bundle"] stringByAppendingString:[NSString stringWithFormat:@"/%@",value]];
        }
    if ([key isEqualToString:@"code"]) {
        //1、创建一个扫描器
        NSScanner *scanner = [[NSScanner alloc]initWithString:value];
        //2、调用方法得到code中的值
        UInt32 value = 0;
        [scanner scanHexInt:&value];
        //3、将value转成字符串
        
        _emojiCode = [NSString emojiWithIntCode:value];
    }
    [super setValue:value forKey:key];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (instancetype)initNull:(BOOL)isNull{
    if (self = [super init]) {
        _isNull = isNull;
    }
    return self;
}
- (instancetype)initRemove:(BOOL)isRemove{
    if (self = [super init]) {
        _isRemove = isRemove;
    }
    return self;
}

@end
