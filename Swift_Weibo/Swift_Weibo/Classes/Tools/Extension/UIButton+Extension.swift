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
    
    /// 便利构造函数
    ///
    /// - Parameters:
    ///   - title: title
    ///   - color: textColor
    ///   - backImageName: 背景图像
    convenience init(title:String, color:UIColor, backImageName:String){
        self.init()
        
        setTitle(title, for: UIControlState.normal)
        setTitleColor(color, for: UIControlState.normal)
        setBackgroundImage(UIImage(named: backImageName), for: UIControlState.normal)
        
        sizeToFit()
    }
    
    /// 便利构造函数
    ///
    /// - Parameters:
    ///   - title: title
    ///   - title: 字体大小
    ///   - color: textColor
    ///   - imageName: 图像名称
    ///   - backColor: 背景颜色,默认为nil
    convenience init(title:String, fontSize:CGFloat, color:UIColor = UIColor.darkGray, imageName:String? , backColor:UIColor? = nil){
        self.init()
        
        setTitle(title, for: UIControlState.normal)
        setTitleColor(color, for: UIControlState.normal)
        if let imageName = imageName {
          setImage(UIImage(named: imageName), for: UIControlState.normal)
        }
        backgroundColor = backColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        sizeToFit()
    }
    
}




























