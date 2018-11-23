//
//  UIImage+Extension.swift
//  PhotoSelector
//
//  Created by houke on 2018/11/23.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 将图像缩放到指定‘宽度’
    ///
    /// - Parameter width: 目标宽度
    /// - Returns: 如果给定的图片宽度小于指定宽度就直接返回，不需缩放
    func scaleToWidth(width:CGFloat) -> UIImage {
        //判断宽度
        if width > size.width {
            return self
        }
        //计算比例
        let height = size.height * width / size.width
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        //使用核心绘图绘制新的图像
        //1 上下文
        UIGraphicsBeginImageContext(rect.size)
        //2 绘图 - draw(in: rect)在指定区域拉伸、缩放绘制
        self.draw(in: rect)
        //3 取结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        //4 关闭上下文
        UIGraphicsEndImageContext()
        //5 返回结果
        return result!
    }
}
