//
//  ViewController.m
//  HKSwift01
//
//  Created by houke on 2018/8/1.
//  Copyright © 2018年 houke. All rights reserved.
//

#import "ViewController.h"
#import "Network.h"

@interface ViewController ()

    @property (nonatomic, strong) Network *network;

@property(nonatomic, strong) NSString *testStr;
@property (nonatomic, strong) void (^testBlock)(NSString *str);
@end

@implementation ViewController
    
    -(Network *)network{
        if(!_network){
            _network = [Network new];
        }
        return _network;
    }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData:^(NSString *str) {
        NSLog(@"--%@",str);
        NSLog(@"++%@",self.view);
    }];
    
//    self.testStr = @"11111";
//    __weak typeof(self) weakSelf = self;
//
//    [self.network getData:^(NSString *str) {
//
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        strongSelf.testStr = @"22222";
//        for(int i = 0; i< 1000 ; i ++){
//            NSLog(@"+++%i--%@--%@", i, strongSelf.testStr,strongSelf.view);
//        }
////        NSLog(@"weakSelf%@ --- %@", str, weakSelf.view);
//    }];
}

-(void)loadData:(void (^)(NSString *))complate{
    self.testBlock = complate;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"模拟异步加载数据");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程");
            self.testBlock(@"test444");
        });
        
    });
}
    -(void)dealloc{
        NSLog(@"ViewController 走了");
    }
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
