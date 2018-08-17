//
//  Network.m
//  HKSwift01
//
//  Created by houke on 2018/8/1.
//  Copyright © 2018年 houke. All rights reserved.
//

#import "Network.h"

@interface Network()
    @property (nonatomic, copy) void (^finishBlock)(NSString *str);
    @end

@implementation Network

-(void)getData:(void (^)(NSString* str))finish
    {
        self.finishBlock = finish;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"耗时操作");
            [NSThread sleepForTimeInterval:3];
            [self working];
        });
    }
    
    -(void)working
    {
        if(_finishBlock){
            _finishBlock(@"json");
        }
        
    }
    
    -(void)dealloc{
        NSLog(@"Network 走了");
    }
@end
