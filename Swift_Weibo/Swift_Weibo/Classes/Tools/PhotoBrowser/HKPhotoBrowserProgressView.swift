//
//  HKPhotoBrowserProgressView.swift
//  Swift_Weibo
//
//  Created by houke on 2018/12/12.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

/// 进度视图
class HKPhotoBrowserProgressView: UIView {
    
    //根据进度重绘视图
    var progress:CGFloat = 0 {
        didSet{
            //重绘视图
            setNeedsDisplay()//调用此函数能够让程序自动执行draw(_ rect: CGRect)函数
        }
    }
    
    //MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        /*
         参数：
         中心点
         半径
         起始弧度
         截止弧度
         是否顺时针
         */
        
        let center =  CGPoint(x: rect.width * 0.5, y: rect.height > UIScreen.main.bounds.height ?   UIScreen.main.bounds.height * 0.5 : rect.height * 0.5)
        let r:CGFloat = 35
        let start = -CGFloat.pi / 2
        let end = start + progress * 2 *  CGFloat.pi
    
        let path = UIBezierPath(arcCenter: center, radius: r, startAngle: start, endAngle: end, clockwise: true)
        //添加到中心点的连线
        path.addLine(to: center)
        path.close()//关闭路径
        
        UIColor(white: 1, alpha: 0.3).setFill()
        path.fill()
    }
}
