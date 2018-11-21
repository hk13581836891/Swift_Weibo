//
//  HKEmoticonManager.swift
//  HKEmojiKeyboard
//
//  Created by houke on 2018/11/15.
//  Copyright © 2018年 houke. All rights reserved.
//

import Foundation

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
    
    
    //MARK: - 构造函数 构造函数私有化，在单例中防止外部直接使用构造函数（可能会多次使用，多次创建）
    private init() {
        loadPlist()
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








































