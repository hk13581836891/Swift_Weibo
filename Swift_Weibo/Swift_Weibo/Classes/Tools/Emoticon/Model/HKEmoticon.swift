//
//  HKEmoticon.swift
//  HKEmojiKeyboard
//
//  Created by houke on 2018/11/15.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

//MARK: - 表情模型
@objcMembers class HKEmoticon: NSObject {
    //发送给服务器的表情字符串
    var chs:String?
    //在本地显示的图片名称 + 表情包路径
    var png:String?
    
    var imagePath:String {
        //判断是否有图片
        if png == nil {
            return ""
        }
        //拼接完整路径
        return Bundle.main.bundlePath + "/HKEmoticons.bundle/" + png!
    }
    
    //emjio的字符串编码
    var code:String?{
        didSet{
            emoji = code?.emoji
        }
    }
    //emoji的字符串
    var emoji:String?
    
    //是否删除按钮标记
    var isRemoved = false
    //是否空白按钮标记
    var isEmpty = false
    
    init(isEmpty: Bool){
        self.isEmpty = isEmpty
        super.init()
    }
    
    init(isRemoved: Bool){
        self.isRemoved = isRemoved
        super.init()
    }
    
    init(dict:[String : AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
    override var description: String{
        let keys = ["chs","png", "code", "isRemoved"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
