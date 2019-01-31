//
//  ProperyLabel.swift
//  Swift_Weibo
//
//  Created by houke on 2019/1/30.
//  Copyright © 2019年 houke. All rights reserved.
//

import UIKit

class ProperyLabel: UILabel {
   
    //MARK: - 重写属性
    override var text:String?{
        didSet{
            prepareText()
        }
    }
    override var attributedText:NSAttributedString?{
        didSet{
            prepareText()
        }
    }
    
    //MARK: - 绘制文本
    override func drawText(in rect: CGRect) {
        
        let range = NSRange(location: 0, length: textStorage.length)
        
        //绘制字形 - 布局管理器绘制 textStorage中的内容
        layouManager.drawGlyphs(forGlyphRange: range, at: CGPoint.zero)
    }
    
    /// 准备文本系统
    func prepareTextSystem() {
        
        //1准备文本内容
        prepareText()
        
        //2设置对象关系
        textStorage.addLayoutManager(layouManager)
        layouManager.addTextContainer(textContainer)
    }
    
    /// 准备文本内容
    private func prepareText(){
        
        if attributedText != nil {
            //直接设置属性文本
            textStorage.setAttributedString(attributedText!)
        }else if text != nil{
            textStorage.setAttributedString(NSAttributedString(string: text!))
        }else{
            textStorage.setAttributedString(NSAttributedString(string: ""))
        }
        
        //遍历 url 数组，设置文本属性
        for range in rangeForUrls {
            textStorage.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: range)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置文本容器的尺寸
        textContainer.size = bounds.size
    }
    //MARK: - 懒加载属性
    /// 文本内容 - 可变属性字符串的子类
    private lazy var textStorage = NSTextStorage()

    /// 布局管理器 - 负责文本绘制
    private lazy var layouManager = NSLayoutManager()
    
    /// 文本容器 - 设置绘制的尺寸
    private lazy var textContainer = NSTextContainer()
}

// MARK: - 正则表达式相关函数/属性
extension ProperyLabel{

    /// 返回字符串中所有 URL连接的范围数组
    var rangeForUrls:[NSRange] {
        
        //1定义正则表达式
        let pattern = "[a-zA-Z]*://[a-zA-Z0-9/\\.]*"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        //2 匹配所有的url 连接
        let result = regex.matches(in: textStorage.string, options: [], range: NSRange(location: 0, length: textStorage.length))
        
        var array = [NSRange]()
        for m in result {
            array.append(m.range(at: 0))
        }
        
        return array
    }
    
}



























