//
//  EmotionPackAge.m
//  图文混排
//
//  Created by MacBook on 16/12/14.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import "EmotionPackAge.h"

@implementation EmotionPackAge

- (instancetype)initWithID:(NSString *)ID{
    if (self = [super init]) {
        
        _emotionArr = [NSMutableArray array];
        
        if ([ID isEqualToString:@""]) {
            for (NSInteger i = 0 ; i < 20 ; i ++) {
                EmotionModel *model = [[EmotionModel alloc]initNull:YES];
                [_emotionArr addObject:model];
            }
            EmotionModel *emotiom = [[EmotionModel alloc]initRemove:YES];
            [_emotionArr addObject:emotiom];
            return self;
        }
        
        /** 1、获取文件路径，我们这里不是读取的mainBundle里面的数据了，所以使用下面的方法 */
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@/info.plist",ID] ofType:nil inDirectory:@"Emoticons.bundle"];
        /** 2、根据文件路径获取表情数组 */
        NSArray *emtionS = [NSArray arrayWithContentsOfFile:path];
        
        /** 3、遍历数组转模型数组 */
        NSInteger index = 0;
        for (NSMutableDictionary *dicEmotion in emtionS) {
            EmotionModel *model = [[EmotionModel alloc]init];
            if (dicEmotion[@"png"]) {
                dicEmotion[@"png"] = [[ID stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%@",dicEmotion[@"png"]]];
            }
            
            [model setValuesForKeysWithDictionary:dicEmotion];
            [_emotionArr addObject:model];
            
            index ++;
            if (index == 20) {
                EmotionModel *emotiom = [[EmotionModel alloc]initRemove:YES];
                [_emotionArr addObject:emotiom];
                index = 0;
            }
            
            
        }
        /** 4、添加空白表情 */
        NSInteger count = _emotionArr.count % 21;
        if (count == 0 ) {
            return self;
        }
        
        for (NSInteger i = count ; i < 20 ; i ++) {
            EmotionModel *model = [[EmotionModel alloc]initNull:YES];
            [_emotionArr addObject:model];
        }
        EmotionModel *emotiom = [[EmotionModel alloc]initRemove:YES];
        [_emotionArr addObject:emotiom];

        NSLog(@"%@",_emotionArr);
        
    }
    return self;
}

@end
