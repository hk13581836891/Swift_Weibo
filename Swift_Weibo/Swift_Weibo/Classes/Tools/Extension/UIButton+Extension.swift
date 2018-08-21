//
//  UIButton+Extension.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/21.
//  Copyright © 2018年 houke. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    //便利构造函数
    convenience init(imageName:String, backImageName:String) {
        self.init()
        setImage(UIImage(named: imageName), for: UIControlState.normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: UIControlState.highlighted)
        setBackgroundImage(UIImage(named: backImageName), for: UIControlState.normal)
        setBackgroundImage(UIImage(named: backImageName + "_highlighted"), for: UIControlState.highlighted)
        
        //会根据背景图片的大小调整尺寸
        sizeToFit()
    }
}
