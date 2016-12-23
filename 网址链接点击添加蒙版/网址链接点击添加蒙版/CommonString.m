//
//  CommonString.m
//  网址链接点击添加蒙版
//
//  Created by MacBook on 16/12/23.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import "CommonString.h"
#import "EmotionManager.h"

@implementation CommonString
+ (NSMutableAttributedString *)matchAttribtueString:(NSString *)string textFont:(NSInteger)textFont{
    
    
    NSString *statusString = string;
    //@"@coderwhy:【动物尖叫合辑】#肥猪流#猫头鹰这么尖叫[偷笑]、@M了个J: 老鼠这么尖叫、兔子这么尖叫[吃惊]、@花满楼: 莫名奇#小笼包#妙的笑到最后[好爱哦]！~ http://t.cn/zYBuKZ8/";
    //1、创建匹配原则
    //@匹配
    //    NSString *atPattern = @"@.*?:";
    //##
    //    NSString *topicPattern = @"#.*?#";
    //表情
    NSString *emotionPattern = @"\\[.*?\\]";
    //链接
    //    NSString *urlPattern = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?";
    
    //    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@", emotionPattern, atPattern, topicPattern, urlPattern];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:emotionPattern options:0 error:nil];
    NSArray *rangeArr = [regex matchesInString:statusString options:0 range:NSMakeRange(0, statusString.length)];
    NSMutableAttributedString *subString = [[NSMutableAttributedString alloc]initWithString:statusString];
    for (NSTextCheckingResult *result in rangeArr) {
        //根据表情名称查找表情图片
        NSString *emotionString = [statusString substringWithRange:result.range];
        /** 在属性文字中拼接表情 */
        NSTextAttachment *match = [[NSTextAttachment alloc]init];
        match.image = [UIImage imageWithContentsOfFile:[CommonString getImagePathFromEmotionName:emotionString]];
        /** 这里我就认为控件的font为17 */
        UIFont *font = [UIFont systemFontOfSize:textFont];
        match.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
        NSAttributedString *attString = [NSAttributedString attributedStringWithAttachment:match];
        
        [subString replaceCharactersInRange:result.range withAttributedString:attString];
    }
    
    return subString;
}
+ (NSString *)getImagePathFromEmotionName:(NSString *)emotionName{
    EmotionManager *emotionManager = [[EmotionManager alloc]init];
    if ([emotionName isEqualToString:@"[偷笑]"]) {
        NSLog(@"===");
    }
    for (EmotionPackAge *emotionPack  in emotionManager.emotionS) {
        for (EmotionModel *emotion in emotionPack.emotionArr) {
            if ([emotionName isEqualToString:emotion.chs]) {
                return emotion.pathImage;
            }
        }
    }
    return @"";
}

/** 手机号验证 如果是返回YES */
+ (BOOL) IsPhoneNumber:(NSString *)number
{
    NSString *phoneRegex1=@"1[34578]([0-9]){9}";
    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex1];
    return  [phoneTest1 evaluateWithObject:number];
}
/** 邮箱验证 如果是返回YES */
+ (BOOL) IsEmailAdress:(NSString *)Email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}
/** 身份证号码验证 如果是返回YES */
+ (BOOL) IsIdentityCard:(NSString *)IDCardNumber
{
    if (IDCardNumber.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:IDCardNumber];
}
/** 银行卡号验证 如果是返回YES */
+ (BOOL) IsBankCard:(NSString *)cardNumber
{
    if(cardNumber.length==0)
    {
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++)
    {
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c))
        {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
    {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo)
        {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}
/** 字符串盘空表达式 如果为空返回@“”，否则返回字符串 */
+ (NSString *)isNullToString:(id)string
{
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"])
    {
        return @"";
        
        
    }else
    {
        
        return (NSString *)string;
    }
}
/** 字符串盘空表达式 如果为空返回YES，否则NO */
+ ( BOOL )stringIsEquelNull:(id)string
{
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"])
    {
        return YES;
        
        
    }else
    {
        
        return NO;
    }
}

/** 归档 */
+ ( BOOL )archiverDataToFilepath:(NSString *)filePath archiverKey:(NSString *)key dataObject:(id)dataObject{
    
    /** 当key为空时我们直接将对象进行归档 */
    if ([CommonString stringIsEquelNull:key]) {
        BOOL success = [NSKeyedArchiver archiveRootObject:dataObject toFile:filePath];
        return success;
    }

    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //编码
    [archiver encodeObject:dataObject forKey:key];
    
    //编码完成之后，对象已经存储到data之中。
    [archiver finishEncoding];
    
    BOOL success = [data writeToFile:filePath atomically:YES];
    return success;
}

/** 解档 */
+ ( id )unarchiverDataFromFilePath:(NSString *)filePath byArchiverKey:(NSString *)key{
    /** 当key为空时我们直接将对象进行解档 */
    if ([CommonString stringIsEquelNull:key]) {
        id resultData =[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];;
        return resultData;
    }
    
    //读取归档数据
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //创建解归档对象，进行反归档
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    //反归档
    id resultData = [unarchiver decodeObjectForKey:key];
    return resultData;
}


@end
