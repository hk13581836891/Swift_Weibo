//
//  Network.h
//  HKSwift01
//
//  Created by houke on 2018/8/1.
//  Copyright © 2018年 houke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Network : NSObject

    -(void)getData:(void (^)(NSString* str))finish;
@end
