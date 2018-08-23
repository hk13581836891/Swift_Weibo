//
//  UIImageView+Extension.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/23.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// 遍历构造函数
    ///
    /// - Parameter imageName: imageName
    convenience init(imageName:String){
        self.init(image: UIImage(named: imageName))
    }
}
