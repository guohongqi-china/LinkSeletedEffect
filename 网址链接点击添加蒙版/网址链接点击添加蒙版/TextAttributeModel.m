//
//  TextAttributeModel.m
//  图文混排
//
//  Created by MacBook on 16/12/18.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import "TextAttributeModel.h"

@implementation TextAttributeModel
- (NSString *)description{
    return [NSString stringWithFormat:@"%@ -- %@",_text,NSStringFromRange(_range)];
}
@end
