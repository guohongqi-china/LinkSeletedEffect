//
//  TextAttributeModel.h
//  图文混排
//
//  Created by MacBook on 16/12/18.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TextAttributeModel : NSObject

/** 文字内容 */
@property (nonatomic, copy) NSString *text;
/** 文字范围 */
@property (nonatomic, assign) NSRange range;
/** 是否为特殊文字 */
@property (nonatomic, assign, getter = isSpecical) BOOL specical;
/** 是否为表情 */
@property (nonatomic, assign, getter = isEmotiom) BOOL emotiom;
@end
