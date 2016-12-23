//
//  URLSeletedLabel.m
//  网址链接点击添加蒙版
//
//  Created by MacBook on 16/12/20.
//  Copyright © 2016年 MacBook. All rights reserved.
//
#define defaultColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]


#import "URLSeletedLabel.h"
#import "TextAttributeString.h"
@interface URLSeletedLabel ()
{
    NSInteger length;
    /** 链接范围数组 */
    NSMutableArray *linkRangeArr;
    /** @范围数组 */
    NSMutableArray *userRangeArr;
    /** ##范围数组 */
    NSMutableArray *topRangeArr;
    /** 表情范围数据 */
    NSMutableArray *emotionArr;
    /** 选中的标签类型 */
    seletedTextType seletedType;
    /** 获取选中的字符串 */
    NSString *seletedString;
}

@end
@implementation URLSeletedLabel

- (instancetype)init{
    if (self = [super init]) {
        [self setProperty];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setProperty];
        
    }
    return self;
}
//属性设置
- (void)setProperty{
    _textStorage = [[NSTextStorage alloc]init];
    _layoutManager = [[NSLayoutManager alloc]init];
    _textContainer = [[NSTextContainer alloc]init];
    self.numberOfLines = 0;
    /** 默认属性设置 */
    //字体大小
    _textFont = 0;
    //特殊字体颜色
    _specialColor = defaultColor(87, 196, 251);
    //选中蒙版颜色
    _seletedColor = [[UIColor alloc]initWithWhite:0.7 alpha:0.2];
    [self setUpSystem];
}
/** 重写父类的赋值方法 */
- (void)setText:(NSString *)text{
    [super setText:text];
    [self sizeToFit];
    length = text.length;
    [self prepatreText:[[NSAttributedString alloc] initWithString:text]];
}
- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
     [self sizeToFit];
    length = attributedText.length;
    [self prepatreText:attributedText];
}
/** 选中颜色 */
- (void)setSeletedColor:(UIColor *)seletedColor{
    _seletedColor = seletedColor;
    if (self.attributedText.length == 0) {
        return;
    }
    [self prepatreText:self.attributedText];
}
/** 字体大小 */
- (void)setTextFont:(NSInteger)textFont{
    _textFont = textFont;
    if (self.attributedText.length == 0) {
        return;
    }
    [self prepatreText:self.attributedText];
}
/** 特殊字体颜色 */
- (void)setSpecialColor:(UIColor *)specialColor{
    _specialColor = specialColor;
    if (self.attributedText.length == 0) {
        return;
    }
    [self prepatreText:self.attributedText];
}
- (void)prepatreText:(NSAttributedString *)text{

    //1、修改_textStorage中存储的内容
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithAttributedString:text];
  
    //2、设置换行模式，否则所有内容都会被绘制到同一行中
    NSRange range = NSMakeRange(0, 0);
    NSMutableDictionary *attDic = [[attributeStr attributesAtIndex:0 effectiveRange:&range]
    mutableCopy];
    NSMutableParagraphStyle *type =  attDic[NSParagraphStyleAttributeName];
    if (type != nil) {
        type.lineBreakMode = NSLineBreakByWordWrapping;
    }else{
        type = [[NSMutableParagraphStyle alloc]init];
        type.lineBreakMode = NSLineBreakByWordWrapping;
        attDic[NSParagraphStyleAttributeName] = type;
        [attributeStr setAttributes:attDic range:range];
        
    }
    
    NSInteger font = _textFont == 0 ? 17 : _textFont;
    [_textStorage setAttributedString:attributeStr];
    [_textStorage addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} range:NSMakeRange(0, attributeStr.length)];


    //3、匹配特殊字符串
    //匹配url
   NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    linkRangeArr = [self getRangeFormResult:detector];
    for (TextRang *rangeModel in linkRangeArr) {
        [_textStorage addAttributes:@{NSForegroundColorAttributeName:_specialColor} range:rangeModel.range];
    }
    
    
    //匹配@用户
    
    userRangeArr = [self getRangeArray:@"@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*"];
    for (TextRang *rangeModel in userRangeArr) {
        [_textStorage addAttributes:@{NSForegroundColorAttributeName:_specialColor} range:rangeModel.range];
    }
    
    //匹配##
    topRangeArr = [self getRangeArray:@"#.*?#"];
    for (TextRang *rangeModel in topRangeArr) {
        [_textStorage addAttributes:@{NSForegroundColorAttributeName:_specialColor} range:rangeModel.range];
    }
    
    //4、通知_layoutManager重新布局
    [self setNeedsDisplay];
    
}
/** 字符串匹配封装 */
- (NSMutableArray *)getRangeArray:(NSString *)pattern{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    return [self getRangeFormResult:regex];
}
/** 根据正则返回相应的特殊字符串范围数组 */
- (NSMutableArray *)getRangeFormResult:(NSRegularExpression *)regex{
    NSArray *rangeArr = [regex matchesInString:_textStorage.string options:0 range:NSMakeRange(0, _textStorage.length)];
    NSMutableArray *resultArr = [NSMutableArray array];
    for (NSTextCheckingResult *result in rangeArr) {
        TextRang *model = [[TextRang alloc]init];
        model.range = result.range;
        [resultArr addObject:model];
    }
    return resultArr;
}

/** 如果UILabel调用setNeedsDisplay方法，系统会重新调用drawTextInRect */
- (void)drawTextInRect:(CGRect)rect{
    // 重绘：理解为一个小的uiview
    /**
     * 第一个参数：指定绘制的范围
     * 第二个参数:指定从什么地方开始绘制
     */
    
    if (_seletedRange.length != 0) {
        
    UIColor *seletedColor = _isSeleted ? [_seletedColor colorWithAlphaComponent:0.5] : [UIColor clearColor];
    [_textStorage addAttributes:@{NSBackgroundColorAttributeName : seletedColor} range:_seletedRange];
    [_layoutManager drawBackgroundForGlyphRange:_seletedRange atPoint:CGPointMake(0, 0)];
        
    }
    NSRange range = NSMakeRange(0, _textStorage.length);
    [_layoutManager drawGlyphsForGlyphRange:range atPoint:CGPointZero];

}
- (void)layoutSubviews{
    [super layoutSubviews];
    _textContainer.size = self.frame.size;
}
- (void)setUpSystem{

    //1、将_layoutManager添加到_textStorage中
    [_textStorage addLayoutManager:_layoutManager];
    
    //2、将_textContainer添加到_layoutManager中
    [_layoutManager addTextContainer:_textContainer];
    
    //3、
    self.userInteractionEnabled = YES;
    _textContainer.lineFragmentPadding = 0;
    _seletedRange = NSMakeRange(0, 0);
    length = 0;
    _isSeleted = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [[event touchesForView:self] anyObject];
    CGPoint rootViewLocation = [touch locationInView:self];
    _seletedRange = [self getSeletedRang:rootViewLocation];
    
    seletedString = [_textStorage.string substringWithRange:_seletedRange];
    [self seleteStateSeting:YES];
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self seleteStateSeting:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSeletedTextType:seletedContent:)]) {
        [self.delegate didSeletedTextType:seletedType seletedContent:seletedString];
    }
}

/** 选中之后状态设置 */
- (void)seleteStateSeting:(BOOL)seleted{
    _isSeleted = seleted;
    //重绘布局：这个步骤很关键。否则无发显示选中效果
    [self setNeedsDisplay];
}

/** 获取选中的段落的范围 */
- (NSRange)getSeletedRang:(CGPoint)seletedPoint{
    if (_textStorage.length == 0) {
        return NSMakeRange(0, 0);
    }
    
    //1、获取选中点所在的下标值（index）
    NSInteger index = [_layoutManager glyphIndexForPoint:seletedPoint inTextContainer:_textContainer];
    
    //2、判断链接是在哪个范围内
    //链接范围数组
    for (TextRang *rangModel in linkRangeArr) {
        NSRange rang = rangModel.range;
        if (index > rang.location && index < rang.location + rang.length) {
            seletedType = seletedTextLink;
            return  rang;
        }
    }
    //@范围数组
    for (TextRang *rangModel in userRangeArr) {
        NSRange rang = rangModel.range;
        if (index > rang.location && index < rang.location + rang.length) {
            seletedType = seletedTextAt;
            return  rang;
        }
    }
    //##范围数组
    for (TextRang *rangModel in topRangeArr) {
        NSRange rang = rangModel.range;
        if (index > rang.location && index < rang.location + rang.length) {
            seletedType = seletedTextTopic;
            return  rang;
        }
    }

    return NSMakeRange(0, 0);
   
}

@end
