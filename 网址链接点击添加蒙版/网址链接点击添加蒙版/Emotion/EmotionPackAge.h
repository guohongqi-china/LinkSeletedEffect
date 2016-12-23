//
//  EmotionPackAge.h
//  图文混排
//
//  Created by MacBook on 16/12/14.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmotionModel.h"

@interface EmotionPackAge : NSObject
/** 表情数组 */
@property (nonatomic, strong) NSMutableArray *emotionArr;
/** 构造函数 */
- (instancetype)initWithID:(NSString *)ID;

@end
