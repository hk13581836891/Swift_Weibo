//
//  HKEmoticonManager.swift
//  HKEmojiKeyboard
//
//  Created by houke on 2018/11/15.
//  Copyright © 2018年 houke. All rights reserved.
//

import Foundation
import UIKit

//MARK: - 表情包视图模型 - 对应的是emoticons.plist
/**
 1 emoticons.plist定义表情包数组
    packages字典数组，每一个 id 对应不同表情包的目录
 2 从每一个表情包目录中，加载 info.plist 可以获得不同的表情内容
 id目录名
 froup_name_cn 表情分组名称 - 显示在 toolbar上
 emoticons 数组
 字典
 chs 发送给服务器的字符串
 png 在本地显示的图片名称
 code emoji的自渡船编码
 */
class HKEmoticonManager {
    
    //单例
    static let sharedManager = HKEmoticonManager()
    
    //表情包模型
    lazy var packages = [HKEmoticonPackage]()
    
    //MARK: - 最近表情
    //添加最近表情 -> 表情添加到 packages[0]的表情数组 (仅是内存排序)
    func addFavorite(em:HKEmoticon){
    
        //0表情次数+1
        em.times = em.times + 1 
        //1 判断表情是否被添加
        if !packages[0].emoticons.contains(em) {
            
            print(packages[0].emoticons)
            packages[0].emoticons.insert(em, at: 0)
            
            //删除倒数第二个按钮
            packages[0].emoticons.remove(at: packages[0].emoticons.count - 2)
        }
        //2排序数组
//        packages[0].emoticons.sort { (em1, em2) -> Bool in
//            em1.times > em2.times
//        }
        //排序数组 尾随闭包
        packages[0].emoticons.sort {$0.times > $1.times}
        
    }
    
    //MARK: - 构造函数 构造函数私有化，在单例中防止外部直接使用构造函数（可能会多次使用，多次创建）
    private init() {
        loadPlist()
    }
    
    //MARK: - 生成属性字符串
    ///将字符串转换成属性字符串
    func emoticonText(string: String, font:UIFont) -> NSAttributedString {
        let strM = NSMutableAttributedString(string: string)
        
        //1 准备正则表达式[] 是正则表达式关键字，需要转义
        let pattern = "\\[.*?\\]"
        
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        //2 匹配多项内容
        let results = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        //3 得到匹配的数量
        var count = results.count
        
        print(count)
        
        //4 倒着遍历查找到的范围
        /**
         如果正着遍历，一旦替换了前面的内容，后面的 range 响应都会发生变化
         倒着遍历 - 第一次匹配的所有 range都有效
         */
        while count > 0 {
            count = count - 1
            let range = results[count].range(at: 0)
            
            //1 从字符串中获取表情子串
            let emStr = (string as NSString).substring(with: range)
            // 2 根据 emStr 查找对应的表情模型
            if let em = emoticonWithString(string: emStr) {
                //3 根据 em建立一个图片属性文本
                let attrText = EmoticonAttachment(emoticon: em).imageText(font: font)
                
                //替换属性字符串中的内容
                strM.replaceCharacters(in: range, with: attrText)
                print(attrText)
            }
            print(range)
        }
        
        return strM
        
    }
    
    /// 根据表情字符串，在表情包中查找对应的表情
    ///
    /// - Parameter string: 表情字符串
    /// - Returns: 表情模型
    private func emoticonWithString(string:String) -> HKEmoticon? {
        //遍历表情包数组
        for package in packages {
            //过滤emoticons数组，查找 em.chs == string 的表情模型
            //filter过滤函数，返回值为符合条件的数组
            //1 如果闭包有返回值，闭包代码只有一句，可以省略 return
            //2 如果有参数，参数可以使用$0 $1..替代
            //3 $0对应的就是数组中的元素
            let emoticon = package.emoticons.filter {$0.chs == string}.last
            //            let emoticon = package.emoticons.filter { (em) -> Bool in
            //                em.chs == string
            //                }.last
            if emoticon != nil{
                return emoticon;
            }
        }
        return nil;
    }
    
    //从 emoticons.plist 加载表情包数据
    func loadPlist()  {
        //0 添加最近分组
        packages.append(HKEmoticonPackage(dict: ["group_name_cn" : "最近a" as AnyObject]))
        
        //1 加载 emoticons.plist - 如果文件不存在，path == nil
        let path = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "HKEmoticons.bundle")!
        
        //2 加载‘字典’
        let dict = NSDictionary(contentsOfFile: path) as! [String : AnyObject]
        
        //3 从字典中获得 id 的数组 -  value(forKey: "")直接获取字典数组中的 key对应的数组
        let array = (dict["packages"]! as! NSArray).value(forKey: "id")
        
        //4 遍历 id数组，准备加载 info.plist
        for id in array as! [String] {
            loadInfoPlist(id: id)
        }
        print(packages)
    }
    
    //加载每一个 id目录下的 info.plist
    private func loadInfoPlist(id:String)  {
        //1 建立路径
        let path = Bundle.main.path(forResource: "info.plist", ofType: nil, inDirectory: "HKEmoticons.bundle/\(id)")!
        
        let dict = NSDictionary(contentsOfFile: path) as! [String : AnyObject]
        packages.append(HKEmoticonPackage(dict:dict))
    }
}








































