//
//  TextRang.h
//  图文混排
//
//  Created by MacBook on 16/12/19.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextRang : NSString

/** 特殊文字的内容 */
@property (nonatomic, copy) NSString *text;
/** 特殊文字范围 */
@property (nonatomic, assign) NSRange range;

@end
