//
//  ViewController.m
//  runtime-归档解档
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 baixinxueche. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "Student.h"

#import "Student+category.h"

@interface ViewController ()
{
    Student *student;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    student = [[Student alloc] init];
    
   
    
}

//获取所有的属性
- (IBAction)getAllVariable:(UIButton *)sender {
    
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([Student class], &outCount);
    
    // 遍历所有成员变量
    for (int i = 0; i < outCount; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        const char *type = ivar_getTypeEncoding(ivar);
        NSLog(@"成员变量名：%s 成员变量类型：%s",name,type);
    }
    // 注意释放内存！
    free(ivars);
    
}

//获取所有的方法
- (IBAction)getAllMethods:(UIButton *)sender {
    unsigned int count;
    //获取方法列表，所有在.m文件显式实现的方法都会被找到，包括setter+getter方法；
    Method *allMethods = class_copyMethodList([Student class], &count);
    for(int i =0;i<count;i++)
    {
        //Method，为runtime声明的一个宏，表示对一个方法的描述
        Method md = allMethods[i];
        //获取SEL：SEL类型,即获取方法选择器@selector()
        SEL sel = method_getName(md);
        //得到sel的方法名：以字符串格式获取sel的name，也即@selector()中的方法名称
        const char *methodname = sel_getName(sel); NSLog(@"(Method:%s)",methodname);
    }
    
    free(allMethods);
    
}


//改变属性值
- (IBAction)changeVariable:(UIButton *)sender {
    NSLog(@"打印当前对象 -- %@",student);
    unsigned int count = 0;
    Ivar *variLists = class_copyIvarList([Student class], &count);
    Ivar ivar = variLists[0];
    const char *str = ivar_getName(ivar);
    NSLog(@"得到的Ivar是 -- %s",str);
    
    object_setIvar(student, ivar, @"SB");
    NSLog(@"改变之后的student：%@",student);
}


//增加属性
- (IBAction)addVariable:(UIButton *)sender {
    
    student.height = 12;           //给新属性height赋值
    NSLog(@"%f",[student height]); //访问新属性值
    
}


//添加一个新的方法
- (IBAction)addNewMethod:(UIButton *)sender {
    /* 动态添加方法：
     第一个参数表示Class cls 类型；
     第二个参数表示待调用的方法名称；
     第三个参数(IMP)myAddingFunction，IMP一个函数指针，这里表示指定具体实现方法myAddingFunction；
     第四个参数表方法的参数，0代表没有参数；
     */
    class_addMethod([student class], @selector(addNewMethod), (IMP)myAddingFunction, 0);
    //调用方法 【如果使用[student addNewMethod]调用方法，在ARC下会报“no visible @interface"错误】
    [student performSelector:@selector(addNewMethod)];
}

//具体的实现（方法的内部都默认包含两个参数Class类和SEL方法，被称为隐式参数。）
int myAddingFunction(id self, SEL _cmd){
    NSLog(@"已新增方法:addNewMethod");
    return 1;
}

- (void)addNewMethod{
    NSLog(@"啦啦啦");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
