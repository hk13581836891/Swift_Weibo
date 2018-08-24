//
//  Swift_OCHybrid.h
//  Swift_Weibo
//
//  Created by houke on 2018/8/24.
//  Copyright © 2018年 houke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Swift_OCHybrid : NSObject

@property (nonatomic, strong) NSString *hybrid;

+ (instancetype)sharedHybird;
- (void)testMethod;
@end
