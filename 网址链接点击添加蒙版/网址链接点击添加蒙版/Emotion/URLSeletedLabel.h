//
//  URLSeletedLabel.h
//  网址链接点击添加蒙版
//
//  Created by MacBook on 16/12/20.
//  Copyright © 2016年 MacBook. All rights reserved.
//
typedef enum _seletedTextType{
    seletedTextLink,
    seletedTextAt,
    seletedTextTopic
}seletedTextType;

#import <UIKit/UIKit.h>
@protocol URLSeletedLabelDelegate<NSObject>

- (void)didSeletedTextType:(seletedTextType)seletedType seletedContent:(NSString *)content;

@end

@interface URLSeletedLabel : UILabel
/** 只要textStorage中的内容发生改变，就可以通知layoutManager重新布局，layoutManager重新布局需要通过textContainer绘制指定的区域。 */
/**
 * 存储内容
 * textStorage 有个layoutManager
 */
@property (nonatomic, strong) NSTextStorage *textStorage;

/**
 * 专门用于布局管理者
 * layoutManager 中有个 textContainer
 */
@property (nonatomic, strong) NSLayoutManager *layoutManager;

/** 专门用于绘制指定的区域 */
@property (nonatomic, strong) NSTextContainer *textContainer;
/** 选中范围 */
@property (nonatomic, assign) NSRange seletedRange;
/** 选中的状态 */
@property (nonatomic, assign) BOOL isSeleted;
/** 选中的颜色 */
@property (nonatomic, strong) UIColor *seletedColor;
/** label字体大小默认是17 */
@property (nonatomic, assign) NSInteger textFont;
/** 特殊字体颜色 默认黄色*/
@property (nonatomic, strong) UIColor *specialColor;
/** 代理 */
@property (nonatomic, assign) id<URLSeletedLabelDelegate> delegate;
@end
