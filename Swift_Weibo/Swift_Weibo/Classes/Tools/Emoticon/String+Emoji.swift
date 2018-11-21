//
//  String+Emoji.swift
//  HKEmojiKeyboard
//
//  Created by houke on 2018/11/16.
//  Copyright © 2018年 houke. All rights reserved.
//

import Foundation

extension String {
    //返回当前字符串中16进制对应的d emoji字符串
    var emoji:String {
        //文本扫描器 - 扫描指定格式的字符串
        let scanner = Scanner(string: self)
        
        //unicode 的值
        var value:uint = 0
        scanner.scanHexInt32(&value)
        
        //转换unicodde '字符'
        let char = Character(UnicodeScalar(value)!)
        
        //转换成字符串
        return "\(char)"
        
    }
    
}
