//
//  NetworkingController.swift
//  HKSwift01
//
//  Created by houke on 2018/8/8.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

class NetworkingController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "http://apidev.ttplus.cn/list/hot?refresh=true&devId=DEF9CD54-BC87-40CB-B4AE-CEB0687F01E8&_t=1533623730797&is_first=true")
        // _表示忽略
        URLSession.shared.dataTask(with: url!) { (data, _, error) in
             print(data!)
            
            let str = "[\"hello\", \"world\"]"
            let dataStr = str.data(using: String.Encoding.utf8)
            
            
            //反序列化
            //oc中按位枚举的方式改为数组的方式设置[值1, 值2]
            /*
             class func jsonObject(with data: Data, options opt: JSONSerialization.ReadingOptions = []) throws -> Any
             'throws'会抛出异常，就必须处理异常
             用try异常还是会向上传递异常,
             dataTask(with: URL, completionHandler: <(Data?, URLResponse?, Error?) -> Void)
             所以代码中那个completionHandler的类型被推断为(NSURLResponse?, NSData?, NSError?) -> Void throws而不是sendAsynchronousRequest期待的(NSURLResponse?, NSData?, NSError?) -> Void
              所以用 try! 或 try?
             */
            //1、用do catch捕获异常
            do{
                let rel1 = try JSONSerialization.jsonObject(with: dataStr!, options: [])
                print(rel1)
            }catch{//如果反序列化失败，能够捕获到 json 失败的准确原因，而不会崩溃
                print(error)
            }
            //2、try！程序员要负责，如果数据格式不正确 会崩溃(尽量不用)
            let relult = try! JSONSerialization.jsonObject(with: dataStr!, options: [JSONSerialization.ReadingOptions.mutableContainers, JSONSerialization.ReadingOptions.mutableLeaves])
            print(relult)
            
            
            //3、try? 搭配 guard 组合使用
            guard let resl2 = try? JSONSerialization.jsonObject(with: dataStr!, options: [JSONSerialization.ReadingOptions.mutableContainers, JSONSerialization.ReadingOptions.mutableLeaves])  else {
                print("反序列化失败")
                return
            }
            print(resl2)
            
        }.resume()
        
        
    }
}






















