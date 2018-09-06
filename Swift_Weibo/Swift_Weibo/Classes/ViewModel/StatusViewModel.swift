//
//  StatusViewModel.swift
//  Swift_Weibo
//
//  Created by houke on 2018/9/6.
//  Copyright © 2018年 houke. All rights reserved.
//

import Foundation

/// 微博视图模型 - 处理单条微博的业务逻辑
class StatusViewModel {
    /// 微博的模型
    var status:Status
    
    /// 构造函数
    init(status:Status){
        self.status = status
    }
    
}
