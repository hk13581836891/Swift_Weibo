//
//  UITextView+Emoticon.swift
//  HKEmojiKeyboard
//
//  Created by houke on 2018/11/19.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

/**
 代码复核 - 对重构完成的代码进行检查
 1、修改注释
 2、确认是否需要进一步重构
 3、再次检查方法返回值和参数
 */
extension UITextView {
    
    
    /// 图片表情完整字符串内容
    var emoticonText: String {
        
        var strM = String()
        let attrText = attributedText
        
        //遍历属性文本
        attrText?.enumerateAttributes(in: NSRange(location: 0, length: (attrText?.length)!), options: [], using: { (dict : [NSAttributedString.Key:Any], range, _) in
            // - 如果字典中包含NSAttachment说明是图片
            // - 否则是字符串，可以通过 range获得
            if let attachment = dict[NSAttributedString.Key.attachment] as? EmoticonAttachment {
                strM += attachment.emoticon.chs ?? ""
            }else{
                let str = (attrText!.string as NSString).substring(with: range)
                strM += str
            }
        })
        return strM
    }
    
    //插入表情符号
    func insertEmoticon(em:HKEmoticon) {
        //1 空白表情
        if em.isEmpty {
            return
        }
        //2 删除按钮
        if em.isRemoved {
            deleteBackward()
            return
        }
        //3 emjio
        if let emoji = em.emoji {
            replace(selectedTextRange!, withText: emoji)
            return
        }
        //4 图片表情
        insertImageEmoticon(em: em)
        
        //5 通知‘代理’文本变化了 - textViewDidChange?表示代理如果没有实现方法，就什么都不做，更安全
        delegate?.textViewDidChange?(self)
    }
    //插入图片表情
    func insertImageEmoticon(em : HKEmoticon) {
        //1 图片的属性文本
        let imageText = EmoticonAttachment(emoticon: em).imageText(font: font!)
        
        //2 记录 textView attributeString -> 转换成可变文本
        let strM = NSMutableAttributedString(attributedString: attributedText)
        
        //3 插入图片文本
        strM.replaceCharacters(in: selectedRange, with: imageText)
        
        //4 替换属性文本
        //1)记录住‘光标’位置
        let range = selectedRange
        //2)替换文本
        attributedText = strM
        //3)回复光标
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
}
