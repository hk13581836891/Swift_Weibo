//
//  StatusViewModel.swift
//  Swift_Weibo
//
//  Created by houke on 2018/9/6.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

/// 微博视图模型 - 处理单条微博的业务逻辑
class StatusViewModel {
    /// 微博的模型
    var status:Status
    
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
    
    /// 构造函数
    init(status:Status){
        self.status = status
    }

    
}
