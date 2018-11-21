//
//  HKEmoticonPackage.swift
//  HKEmojiKeyboard
//
//  Created by houke on 2018/11/15.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

//MARK: - 表情包模型
@objcMembers class HKEmoticonPackage: NSObject {

    //表情包所在路径
    var id:String?
    //表情包的名称，显示在 toolbar中
    var group_name_cn:String?
    //表情数组 - 能够保证在使用的时候，数组已经存在，可以直接追加数据
    lazy var emoticons = [HKEmoticon]()
    
    init(dict : [String: AnyObject]){
        super.init()
        
        id = dict["id"] as? String
        group_name_cn = dict["group_name_cn"] as? String
        //1获取字典数组
        if let array = dict["emoticons"] as? [[String : AnyObject]] {
            //2遍历数组
            var index = 0
            for var d in array {
                //判断是否有 png的值 和id
                if let png = d["png"] as? String, let dir = id{
                    //2重新设置字典的 png的 value
                    d["png"] = dir + "/" + png as AnyObject //png前面拼接 id
                }
                emoticons.append(HKEmoticon(dict: d))
                
                //每隔20个添加一个删除按钮
                index = index + 1
                if index == 20 {
                    emoticons.append(HKEmoticon(isRemoved: true))
                    index = 0
                }
            }
        }
        //2添加空白按钮
        appendEmptyEmoticon()
    }
    
    /// 在表情数组末尾添加空白表情
    func appendEmptyEmoticon() {
        
        //取表情的余数
        let count = emoticons.count % 21
        
        //只有最近和默认需要添加空白表情
        if emoticons.count > 0 && count == 0 {
            return
        }
        
        //添加空白表情
        for _ in count..<20 {
            emoticons.append(HKEmoticon(isEmpty: true))
        }
        emoticons.append(HKEmoticon(isRemoved: true))
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
    override var description: String{
        let keys = ["id", "group_name_cn", "emoticons"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
