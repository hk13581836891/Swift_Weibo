//
//  String+Regex.swift
//  RegularExpressionTest
//
//  Created by houke on 2019/1/23.
//  Copyright © 2019年 ttplus. All rights reserved.
//
/**
 正则表达式
 是一个独立的语言，适用于所有的开发语言, 甚至编辑器
 
 1.匹配方案
 .  匹配任意字符，换行除外
 *  匹配任意多的字符
 ?  尽量少的匹配
 
 2.常用函数
 firstMatch 在指定的字符串中，查找‘第一个’和 pattern符合的字符串
 matches 在指定的字符串中，查找所有和 pattern符合的字符串
 
 3.常用方法
 range(at: index)
 index == 0 取到所有和 pattern匹配一致的字符串
 index == 1 取到 pattern中（第一个）内部的内容，依次递增
 
 4、pattern的编写方法
 1>将完整的字符串直接复制到 pattern
 2>将需要获取的内容使用‘(.*?)’设置
 3>将不关心的内容，可变的内容使用'.*?' 过滤并且忽略，能够适应更多的数据匹配
 
 5.正则表达式适用于所有的语言，常用的正则表达式，可以直接Google搜索
 */
import Foundation

extension String{
    //从当前字符串中，过滤连接和文字
    //元组，允许一个函数返回多个数值
    func href() -> (link: String, text: String)?{
        
        //1. 创建正则表达式
        //匹配方案 - 专门用来过滤字符串的
        let pattern = "<a href=\"(.*?)\" .*?>(.*?)</a>"
        //throws 针对 pattern是否正确的异常处理
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        //firstMatch 在指定的字符串中，查找第一个和 pattern符合的字符串
        guard let result = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count))  else {
            print("没有匹配项目")
            return nil
        }
        
        let str = self as NSString
        
        let r1 = result.range(at: 1)
        let link = str.substring(with: r1)
        
        let r2 = result.range(at: 2)
        let text = str.substring(with: r2)
        return (link, text)
    }
}
