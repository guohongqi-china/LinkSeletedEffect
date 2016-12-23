//
//  EmotionModel.h
//  图文混排
//
//  Created by MacBook on 16/12/14.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmotionModel : NSObject

/** 表情 */
@property (nonatomic, copy) NSString *code;
/** 图片 */
@property (nonatomic, copy) NSString *png;
/** 文字 */
@property (nonatomic, copy) NSString *chs;
/** 图片路径 */
@property (nonatomic, copy) NSString *pathImage;
/** 表情字符 */
@property (nonatomic, copy) NSString *emojiCode;
/** 删除表情 */
@property (nonatomic, assign) BOOL isRemove;
/** 空白表情 */
@property (nonatomic, assign) BOOL isNull;
- (instancetype)initRemove:(BOOL)isRemove;
- (instancetype)initNull:(BOOL)isNull;

@end
