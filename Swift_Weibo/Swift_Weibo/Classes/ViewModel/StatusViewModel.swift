//
//  StatusViewModel.swift
//  Swift_Weibo
//
//  Created by houke on 2019/1/24.
//  Copyright © 2019年 houke. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// 微博视图模型 - 处理单条微博的业务逻辑
/// 视图模型继承CustomStringConvertible 为了打印描述信息
class StatusViewModel: NSObject{
    
    let disposeBag = DisposeBag.init()
    let validateSubject = PublishSubject<String>()
    
    /// 微博的模型
    var status:Status
    
    /// 表格的可重用表示符号
    var cellId:String{
        return status.retweeted_status != nil ? "\(StatusRetweetedCell.self)" : "\(StatusNormalCell.self)"
    }
    
    /// 缓存行高
    lazy var rowHeight:CGFloat = {
        //计算行高
        var cell:StatusCell
        if self.status.retweeted_status != nil {
            cell = StatusRetweetedCell(style: UITableViewCellStyle.default, reuseIdentifier: "\(StatusRetweetedCell.self)")
        }else{
            cell = StatusNormalCell(style: UITableViewCellStyle.default, reuseIdentifier: "\(StatusNormalCell.self)")
        }
        return cell.rowHeigth(vm: self)
    }()
    
    //微博发布日期
    var creatAt:String?{
        return Date.sinaDate(string: status.created_at ?? "")?.dateDescription
    }
    
    /// 用户头像 URL
    var userIconUrl:URL {
        return URL(string: (status.user?.profile_image_url) ?? "")!
    }
    /// 用户默认头像
    var userDefaultImage:UIImage {
        return UIImage(named: "avatar_default_big")!
    }
    /*
     UIImage类型的属性可以做成计算型属性，而不用担心大量重复创建对象 是因为：
     使用 UIImage imageNamed 创建的图像，缓存由系统管理，程序员不能直接释放
     适用的图像 - 小的图片素材
     注意：高清大图,不能用这个方法 使用 contentOfFile
     */
    /// 用户会员图标
    var userMemberImage:UIImage? {
        
        //根据 mbrank来生成图像
        if (status.user?.mbrank)! > 0 && (status.user?.mbrank)! < 8 {
            return UIImage(named: "common_icon_membership_level\(status.user?.mbrank ?? 0)")
        }
        return nil
    }
    
    var userVipImage:UIImage? {
        //认证类型，-1：没有认证， 0：认证用户 2，3，5：企业认证 220：达人
        switch status.user?.verified_type ?? -1 {
        case 0: return UIImage(named: "avatar_vip")
        case 2, 3, 5: return UIImage(named: "avatar_enterprise_vip")
        case 220: return UIImage(named: "avatar_grassroot")
        default: return nil
        }
    }
    
    /// 缩略图 URL数组 - 存储型属性
    /// 如果是原创微博，可以有图，可以没有图
    /// 如果是转发微博，一定没有图，retweeted_status中，可以有图，也可以没有图
    /// 一条微博，最多只有一个 pic_urls 数组
    var thumbnailUrls:[URL]?
    
    var retweetedText:String?{
        //1 判断是否转发微博,如果不是直接返回 nil
        guard let s = status.retweeted_status else {
            return nil
        }
        //        status.retweeted_status.
        //2\ s就是转发微博
        print("@\(s.user?.screen_name ?? "")：\(s.text ?? "")");
        return "@\(s.user?.screen_name ?? "")：\(s.text ?? "")"
    }
    
    /// 构造函数
    init(status:Status){
        self.status = status
        
        //根据模型，来生成缩略图的数组
        if let urls = status.retweeted_status?.pic_urls ?? status.pic_urls {
            //创建缩略图数组
            thumbnailUrls = [URL]()
            
            //遍历字典数组 -> 数组如果可选，不允许遍历，因为数组是通过下标来检索数据，所以使用！
            for dict in urls {
                
                //因为字典时按照 key来取值，如果 key错误，会返回 nil,此处强行解包是要求服务器返回的 key不出错
                //                let ss = "https://wx4.sinaimg.cn/woriginal/835eb1a0gy1fywybfinmzg20dw06oe6x.gif"
                //                let url = URL(string: ss)
                let url = URL(string: dict["thumbnail_pic"]!)
                
                //此处强行解包是要求服务器返回的 url字符串一定能够生成 URL
                thumbnailUrls?.append(url!)
            }
        }
    }
    
    /// 描述信息
//    var description: String {
//
//        return status.description
//    }
    
    //MARK: - rac方法
    func retweetedBtnClick(){
        validateSubject.onNext("retweetedBtnClick")
    }
}
