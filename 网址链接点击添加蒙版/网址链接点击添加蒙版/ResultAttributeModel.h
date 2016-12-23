//
//  ResultAttributeModel.h
//  网址链接点击添加蒙版
//
//  Created by MacBook on 16/12/21.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextRang.h"

@interface ResultAttributeModel : NSObject

/** 属性字符串 */
@property (nonatomic, copy) NSMutableAttributedString *resultAttStr;
/** 特殊字符串（TextRang）模型数组 */
@property (nonatomic, strong) NSMutableArray<TextRang *> *specailArr;
@end
