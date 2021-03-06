//
//  StatusListViewModel.swift
//  Swift_Weibo
//
//  Created by houke on 2018/9/6.
//  Copyright © 2018年 houke. All rights reserved.
//

import Foundation
import SDWebImage


/// 微博数据列表模型 - 封装网络方法
class StatusListViewModel {
   
    //微博数据数组 - 上拉/下拉刷新
    lazy var statusList = [StatusViewModel]()
    
    //下拉刷新计数
    var pulldownCount:Int?
    
    
    /// 加载微博数据库
    ///
    /// - Parameters:
    ///   - isPullup: 是否上拉刷新
    ///   - finish: 完成回调
    func loadStatus(isPullup: Bool , finish: @escaping (Bool) -> ())  {
        //下拉刷新 - 比数组中第一条微博的 id
        let since_id = isPullup ? 0 : (statusList.first?.status.id ?? 0)
        //上拉刷新 - 数组中最后一条微博的 id
        let max_id = isPullup ? (statusList.last?.status.id ?? 0) : 0
        
        
        NetworkTools.sharedTools.loadStatus(since_id: since_id, max_id: max_id) { (result, error) in
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
            //记录下拉刷新的数据
            self.pulldownCount = (since_id > 0) ? dataList.count : nil
            
            //3、拼接数据
            //判断是否是上拉刷新
            if max_id > 0{
                self.statusList = self.statusList + dataList
            }else{
                self.statusList = dataList + self.statusList
                
            }
            //4、缓存单张图片
            self.cacheSingleImage(dataList: dataList , finish: finish)
            
            print("self.statusList.count:\(self.statusList.count)")
        }
        
    }
    
    /// 缓存单张图片
    private func cacheSingleImage( dataList:[StatusViewModel], finish: @escaping (Bool) -> ()) {
        
        //1、创建调度组
        let group = DispatchGroup.init()
        //缓存的数据长度
        var dataLength = 0
        
        
        //2、遍历视图模型数组
        for vm in dataList {
            //判断图片数量是否是单张图片
            if vm.thumbnailUrls?.count != 1{
                continue
            }
            //获取 url
            let url = vm.thumbnailUrls?[0]
            //SDWebImage - 下载图像（缓存是自动完成的）
            //入组 - 监听后续的 block
            group.enter()
            //SDWebImage 的核心函数，如果本地缓存已经存在，同样会通过完成回到返回
            SDWebImageDownloader.shared().downloadImage(with: url, options: SDWebImageDownloaderOptions.highPriority, progress: nil) { (image, data, _, _) in
                //单张图片下载完成
                //累加二进制数据的长度
                dataLength += data?.count ?? 0
                //出组
                group.leave()
                
            }
        }
        //3、监听调度组完成
        group.notify(queue: DispatchQueue.main) {
            print("缓存完成")
            print("--\(dataLength / 1024)k")
            //完成回调 - 控制器才开始刷新表格
            finish(true)
        }
    }

}



































