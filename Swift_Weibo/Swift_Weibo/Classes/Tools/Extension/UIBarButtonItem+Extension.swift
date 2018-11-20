//
//  UIBarButtonItem+Extension.swift
//  Swift_Weibo
//
//  Created by houke on 2018/11/20.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    
    /// 便利构造函数
    ///
    /// - Parameters:
    ///   - imageName: 图像名
    ///   - target: 监听对象
    ///   - actionName: 监听图像名
    convenience init(imageName: String, target: AnyObject?, actionName: String?){
        ()
        let btn = UIButton(imageName: imageName, backImageName: "")
        //判断 actionName
        if let _ = actionName {
            btn.addTarget(target, action: Selector(actionName ?? ""), for: UIControlEvents.touchUpInside)
        }
        self.init(customView: btn)
    }
}
