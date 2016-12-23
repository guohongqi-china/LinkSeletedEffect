//
//  TextAttributeString.m
//  图文混排
//
//  Created by MacBook on 16/12/18.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import "TextAttributeString.h"
#import "RegexKitLite.h"
#import "TextAttributeModel.h"
#import "TextRang.h"
#import "EmotionManager.h"

static NSMutableArray *rangArray;

@implementation TextAttributeString
/** 字符串截取 */
+ (ResultAttributeModel *)attributedStringSubset:(NSString *)string textFont:(NSInteger)textFonet{
   
    NSString *str = string;
    
    // 表情的规则
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    // @的规则
    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5]+";
    // #话题#的规则
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    // url链接的规则
    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    
    /** 匹配多个条件相当于or 或 */
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@", emotionPattern, atPattern, topicPattern, urlPattern];
    
    /** 属性字符串 */
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc]init];
    
    /**
     *  注意：这里的capturedStrings、capturedRanges 都是指针；所以我们取值只能用*capturedStrings、
     *       *capturedRanges来取值
     */
    /** 遍历所有特殊字符串的匹配结果 */
    NSMutableArray *specials = [NSMutableArray array];
    [str enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        //长度为0的字符串不拼接
        if((*capturedRanges).length == 0) return;
        //设置特殊文字颜色
        //讲字符串转模型存入数组
        TextAttributeModel *textModel = [[TextAttributeModel alloc]init];
        textModel.text = *capturedStrings;
        textModel.range = *capturedRanges;
        textModel.specical = YES;
        textModel.emotiom = [*capturedStrings hasPrefix:@"["] && [*capturedStrings hasSuffix:@"]"];
        [specials addObject:textModel];
        
    }];
    
    /** 切割字符串 截取特殊字符串以外的字符 */
    [str enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        //NSLog(@"%@  %@",*capturedStrings,NSStringFromRange(*capturedRanges));
        if((*capturedRanges).length == 0) return;
        
        TextAttributeModel *textModel = [[TextAttributeModel alloc]init];
        textModel.text = *capturedStrings;
        textModel.range = *capturedRanges;
        textModel.specical = NO;
        [specials addObject:textModel];
    }];
    
    /** 对得到的结果进行排序 */
    [specials sortUsingComparator:^NSComparisonResult(TextAttributeModel *textModelOne, TextAttributeModel *textModelTwo) {
        //NSOrderedAscending = -1L,（升序）textModelTwo > textModelOne
        //NSOrderedSame, 一样大
        //NSOrderedDescending （降序）textModelTwo < textModelOne
        
        if(textModelOne.range.location > textModelTwo.range.location){
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    
    rangArray = [NSMutableArray array];
    /** 按顺序拼接每一串字符 */
    for(TextAttributeModel *textModel in specials){
        //对特殊字符串做处理
        NSAttributedString *subString = nil;
        if(textModel.isEmotiom){//表情文字
            /** 在属性文字中拼接表情 */
            NSTextAttachment *match = [[NSTextAttachment alloc]init];
            match.image = [UIImage imageNamed:@"d_aini"];
            /** 这里我就认为控件的font为17 */
            UIFont *font = [UIFont systemFontOfSize:textFonet];
            match.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
            subString = [NSAttributedString attributedStringWithAttachment:match];
            
        }else if(textModel.specical){//非表情特殊文字
        subString = [[NSAttributedString alloc]initWithString:textModel.text attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
            
            TextRang *model = [[TextRang alloc]init];
            model.text = textModel.text;
            NSInteger loc = attributeText.length;
            NSInteger leg = textModel.text.length;
            model.range = NSMakeRange(loc, leg);
            [rangArray addObject:model];
        }else{//分特殊字符串
        subString = [[NSAttributedString alloc]initWithString:textModel.text];
        }
         [attributeText appendAttributedString:subString];
    }
    
    /** 给属性字符绑定属性 */
    [attributeText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:textFonet] range:NSMakeRange(0, attributeText.length)];
    
    //整理数据
    ResultAttributeModel *specailModel = [[ResultAttributeModel alloc]init];
    specailModel.specailArr = rangArray;
    specailModel.resultAttStr = attributeText;
    
    return specailModel;
    
}
+ (NSMutableAttributedString *)matchAttribtueString:(NSString *)string textFont:(NSInteger)textFont{
    
    
    NSString *statusString = string;
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
        match.image = [UIImage imageWithContentsOfFile:[TextAttributeString getImagePathFromEmotionName:emotionString]];
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
+ (NSMutableArray *)rangView{
    return rangArray;
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




@end
