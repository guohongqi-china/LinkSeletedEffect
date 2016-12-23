//
//  CommonString.h
//  网址链接点击添加蒙版
//
//  Created by MacBook on 16/12/23.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonString : NSString
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

/** 归档 */
+ ( BOOL )archiverDataToFilepath:(NSString *)filePath archiverKey:(NSString *)key dataObject:(id)dataObject;

/** 解档 */
+ ( id )unarchiverDataFromFilePath:(NSString *)filePath byArchiverKey:(NSString *)key;





@end
