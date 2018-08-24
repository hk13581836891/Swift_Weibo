//
//  Swift_OCHybrid.m
//  Swift_Weibo
//
//  Created by houke on 2018/8/24.
//  Copyright © 2018年 houke. All rights reserved.
//

#import "Swift_OCHybrid.h"
//ProductName-Swift.h 注意 ProductName 不能包含中文和数字的组合包括“-”
//注意:swift调 oc不会有问题，但 oc无法访问 swift中的特殊语法，例如:枚举！
#import "Weibo-Swift.h"

static Swift_OCHybrid *instance;
@implementation Swift_OCHybrid

+(instancetype)sharedHybird
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
        instance.hybrid = @"ss";
    });
    
    return instance;
}
- (void)testMethod{
    
   SoundTools *test = [SoundTools new];
    [test testClassFun];
    [SoundTools sharedTools2];
//    NSLog(@"--%@",dd);sharedTools2
}
@end
