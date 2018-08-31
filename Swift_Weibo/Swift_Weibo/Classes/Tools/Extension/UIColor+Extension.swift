//
//  UIColor+Extension.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/31.
//  Copyright © 2018年 houke. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    //返回随机颜色
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}
