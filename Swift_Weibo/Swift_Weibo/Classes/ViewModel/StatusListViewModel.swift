//
//  StatusListViewModel.swift
//  Swift_Weibo
//
//  Created by houke on 2018/9/6.
//  Copyright © 2018年 houke. All rights reserved.
//

import Foundation


/// 微博数据列表模型 - 封装网络方法
class StatusListViewModel {
   
    //微博数据数组 - 上拉/下拉刷新
    lazy var statusList = [StatusViewModel]()
    
    func loadStatus(finish: @escaping (Bool) -> ())  {
        NetworkTools.sharedTools.loadStatus { (result, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            //判断 result的数据结构是否正确
            guard let array = (result as AnyObject)["statuses"] as? [[String : Any]] else{
                print("数据格式错误")
                finish(false)
                return
            }
            //遍历字典的数组，字典转模型
            //1、可变的数组
            var dataList = [StatusViewModel]()
            //2、遍历数组
            for dict in array {
                dataList.append(StatusViewModel(status: Status(dict: dict)))
            }
            //3、拼接数据
            self.statusList = dataList + self.statusList
            print(self.statusList)
            print("0000000")
            //4、完成回调
            finish(true)
        }
        
    }

}



































