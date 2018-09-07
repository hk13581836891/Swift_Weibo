//
//  UILable+Extension.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/23.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

extension UILabel {
    
    
    /// 遍历构造函数
    ///
    /// - Parameters:
    ///   - title: title
    ///   - color: textColor,默认是深灰色
    ///   - fontSize:fontSize，默认是14号字
    ///   - screenInset:相对于屏幕左右的缩进，默认为0，居中显示，如果设置，则左对齐
    convenience init(title:String ,
                     color:UIColor =  UIColor.darkGray,
                     fontSize:CGFloat = 14,
                     screenInset:CGFloat = 0){
        self.init()
        text = title
        textColor = color
        font = UIFont.systemFont(ofSize: fontSize)
        numberOfLines = 0
        
        if screenInset == 0 {
            textAlignment = NSTextAlignment.center
        }else {
            //设置换行宽度
            preferredMaxLayoutWidth = UIScreen.main.bounds.width - screenInset * 2
            textAlignment = .left
        }
    }
}
































