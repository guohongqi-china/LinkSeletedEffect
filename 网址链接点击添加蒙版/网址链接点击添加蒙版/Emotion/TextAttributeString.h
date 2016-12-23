//
//  TextAttributeString.h
//  图文混排
//
//  Created by MacBook on 16/12/18.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ResultAttributeModel.h"

@interface TextAttributeString : NSString
/** 将普通字符串转换为属性字符串 */
+ (ResultAttributeModel *)attributedStringSubset:(NSString *)string textFont:(NSInteger)textFonet;
+ (NSMutableAttributedString *)matchAttribtueString:(NSString *)string textFont:(NSInteger)textFont;
/** 手机号验证 如果是返回YES */
+ (BOOL) IsPhoneNumber:(NSString *)number;

/** 邮箱验证 如果是返回YES */
+ (BOOL) IsEmailAdress:(NSString *)Email;

/** 身份证号码验证 如果是返回YES */
+ (BOOL) IsIdentityCard:(NSString *)IDCardNumber;

/** 银行卡号验证 如果是返回YES */
+ (BOOL) IsBankCard:(NSString *)cardNumber;

/** 字符串盘空表达式 如果为空返回@“”，否则返回字符串 */
+ (NSString *)isNullToString:(id)string;

/** 字符串盘空表达式 如果为空返回YES，否则NO */
+ ( BOOL )stringIsEquelNull:(id)string;












@end
