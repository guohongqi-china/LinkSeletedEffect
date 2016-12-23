//
//  JSONModel.m
//  网址链接点击添加蒙版
//
//  Created by MacBook on 16/12/22.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import "JSONModel.h"

@implementation JSONModel
// 归档方法
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.age forKey:@"age"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
}
// 反归档方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self != nil) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeIntegerForKey:@"age"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
    }
    return self;
}

- (NSString *)description
{
    NSString *string = [NSString stringWithFormat:@"%@,%ld,%@",self.name,self.age,self.gender];
    return string;
}
@end
