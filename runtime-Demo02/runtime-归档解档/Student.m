//
//  Student.m
//  runtime-归档解档
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 baixinxueche. All rights reserved.
//

#import "Student.h"

@interface Student()
{
    NSString *name;
}
@end


@implementation Student

//初始化person属性
-(instancetype)init{
    self = [super init];
    if(self) {
        name = @"Tom";
        self.age = 12;
    } 
    return self;
}
- (void)study{
    NSLog(@"学生要学习");
}

- (void)sleep{
    NSLog(@"学生要睡觉");
}

//输出person对象时的方法：
-(NSString *)description{
    return [NSString stringWithFormat:@"name:%@ age:%d",name,self.age];
}

@end
