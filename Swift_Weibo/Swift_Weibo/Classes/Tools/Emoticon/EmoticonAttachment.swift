//
//  EmoticonAttachment.swift
//  HKEmojiKeyboard
//
//  Created by houke on 2018/11/19.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

//表情附件
class EmoticonAttachment: NSTextAttachment {

    //表情模型
    var emoticon:HKEmoticon
    
    
    /// 将当前附件中的emotion转换成属性文本
    func imageText(font:UIFont) -> NSAttributedString {
        image = UIImage(contentsOfFile: emoticon.imagePath)
        
        //'线高' 表示字体的高度
        let lineHeight = font.lineHeight
        //frame = center + bounds + transform(形变：位移、缩放、旋转)
        //bounds(x, y) = contentOffset
        bounds = CGRect(x: 0, y: -4, width: lineHeight, height: lineHeight)
        //获得图片文本NSAttributedString(attachment: attachment) -> 转为属性文本
        let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: self))
        //'添加'字体
        imageText.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: 1))
        return imageText
    }
    //MARK: - 构造函数
    init(emoticon:HKEmoticon){
        self.emoticon = emoticon
        super.init(data: nil, ofType: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
