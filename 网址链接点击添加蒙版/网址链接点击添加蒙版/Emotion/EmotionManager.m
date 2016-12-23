//
//  EmotionManager.m
//  图文混排
//
//  Created by MacBook on 16/12/14.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import "EmotionManager.h"

@implementation EmotionManager
- (instancetype)init{
    if (self = [super init]) {
        
        //1、添加最近表情
        EmotionPackAge *lastEmotion = [[EmotionPackAge alloc]initWithID:@""];
        
        //2、添加默认表情
        EmotionPackAge *defaultEmotion = [[EmotionPackAge alloc]initWithID:@"com.sina.default"];
        
        //3、添加emoji表情
        EmotionPackAge *emojiEmotion = [[EmotionPackAge alloc]initWithID:@"com.apple.emoji"];
        
        //4、添加浪小花表情
        EmotionPackAge *billowEmotion = [[EmotionPackAge alloc]initWithID:@"com.sina.lxh"];
        
        //添加到数组
        _emotionS = [NSMutableArray array];
        [_emotionS addObject:lastEmotion];
        [_emotionS addObject:defaultEmotion];
        [_emotionS addObject:emojiEmotion];
        [_emotionS addObject:billowEmotion];


    }
    return self;
}

@end
