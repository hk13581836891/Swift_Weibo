//
//  BasicGrammar.swift
//  HKSwift01
//
//  Created by houke on 2018/7/26.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
/*熟悉 swift 基本语法
 常量 变量
 可选项  ??运算符
 控制流：if, 三目, if let, guard, switch
 字符串
 循环
 集合: 数组 集合
 */

class BasicGrammarController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        dictionaryDemo()
    }
    //MARK: 字典
    func dictionaryDemo()  {
        //同数组 可变 var  不可变 let
        var dict:[String : Any] = ["name": "小花", "age":18]
        dict["name"] = "小草"//修改
        dict["school"] = "test"//增加键值
        print(dict)
        
        //遍历
        for (key, value) in dict {
            print("key:\(key) --- value:\(value)")
        }
        
        let dic = ["name": "小芳", "title":"test" ]
        //合并字典时和设置内容一样，如果有key，则覆盖 否则新增
        for (key, value) in dic {
            dict[key] = value
        }
        print(dict)//
        
    }
    //MARK: 数组
    func collection()  {
        //集合的用法
        ////数组的基本操作
        let arr1 = ["aa", "bb"]
        print(arr1)
        //数字不需要包装 但结构体可以包装成NSValue
        let arr2 = [CGPoint(x: 10, y: 10) , 18, "str", arr1] as [Any]
        print(arr2)//[(10.0, 10.0), 18, "str", ["aa", "bb"]]
        let arr3 = [NSValue(cgPoint: CGPoint(x: 10, y: 10)) , 18, "str", arr1] as [Any]
        print(arr3)//[NSPoint: {10, 10}, 18, "str", ["aa", "bb"]]
        
        //数组的可变、不可变
        /*
         swift 中对象可以没有任何父类
         可变数组用 var修饰 不可变用 let修饰
         增 append\insert  删remove 改通过下标获取元素进行修改
         */
        var arr:[Any] = ["one", "two", 3, 4, 5, 6, 7, 8, 9,10, 11, 12,13]
        print(arr.capacity)
        arr.append(14)
        print(arr)
        arr[0] = "one more"
        print(arr)
        arr.remove(at: 1)
        print(arr)
        arr.removeLast()
        arr.removeAll(keepingCapacity: true)
        arr.removeAll()
        
        //遍历
        for obj in arr {
            print(obj)
        }
        
        //数组容量增加测试 capacity
        var array :[String] //定义一个存放字符串的数组 没有分配空间
        array = [String]()//给数组分配空间
        for i in 0..<40 {
            array.append("张三 \(i)")
            print(array[i] +  "---\(array.capacity)")
        }
        print(array.count)
        
        var array1 = [String]()//定义并且实例化一个空的存放字符串的数组£
        array1.append("lisi")
        array1 += array  //字符串的拼接
        print(array1)
        print("判断字符是否为空 \(array1.isEmpty)" )//判断字符是否为空
        print("判断数组是否包含某个元素 \(array1.contains("lisi"))")//判断数组是否包含某个元素
        array1.insert("test", at: 1) //在该变量数组指定位置添加元素，原本的元素被移动到新元素后面
        print(array1)
        
      
        
    }
    //MARK: - 循环
    func cycleDemo()  {
        for i in 0 ..< 5 {
            print(i)
        }
        print("--------")
        
        for i in (0..<5).reversed() {
            print(i)
        }
        
        print("--------")
        for i in (0..<5) where i % 2 == 0 {
            print(i)
        }
        print("--------")
        
        //定义范围
        let x = 0 ..< 9
        print(x)
        //包含
        let y = 0 ... 9
        print(y)
        
        

    }
    //MARK: - 字符串
    func stringUseDemo2() {
    //字符串的子串
        let str = "hello world"
        let s1 = (str as NSString) .substring(with: NSMakeRange(2, 5))
        let s4 = NSString(string: str).substring(with:  NSMakeRange(2, 5))
        print(s4,"\r\n",s1)
        
        let s2 = str[str.index(str.startIndex, offsetBy: 2) ..< str.index(str.startIndex, offsetBy: 5)]
        print(s2)
        let s3 = String(str.reversed())
        print(s3)
        
        //多行书写
        let s5 = """
        第一行
        第二行
        第三行
        。。。
        """
        print(s5)
    }
    
    func stringUseDemo()  {
        //字符串的使用(拼接 遍历 长度 格式化)
        let name = "张三"
        let age = 18
        let point = view.center
        //拼接
        print("\(name)" + String(age) + "\(point)" )
        print("\(name) \(age) \(point)")
        
        //遍历
        /*
         String 结构体(量级轻,苹果推荐用)，支持直接遍历
         NSString 类对象
         */
        let string = "hello word"
        for c in string {
            print(c)
        }
        //长度
        print(string.count)
        let chinese = "中文"
        print(chinese.count) //2
        print(chinese.lengthOfBytes(using: String.Encoding.utf8)) //6 说明一个中文占3个字节的长度
        
        let cha:NSString = "简体中文"
        print(cha.length)
        
        //格式化 显示时间 09:08:07
        let h = 9
        let m = 8
        let s = 7
        
        let time1 = String(format: "%02d:%02d:%02d", h,m,s)
        let time2 = String(format: "%02d:%02d:%02d", arguments: [h, m, s])
        print(time1, "---",time2)
    }
    //MARK: - 控制流- switch
    func switchDemo(){
        
/*
 1、switch可以判断的类型不限于 int
 2、各 case之间不会穿透,如果有多个值，使用，分割
 3、 在 case中定义变量可以不加{}
 4、 每个 case之间不需要添加 break
 5、 必须包含所有情况的处理 default:中也必须有处理，如果没有任何处理可以添加 break语句
    */
        let x = "w"
        switch x {
        case "q","w":
            let y = 10
            print(y)
        default:
            print(x)
        }
        
        let point = CGPoint(x: 100, y: 90)
        switch point {
        case let p where p.x == 100 && p.y == 90 :
            print(p)
        default:
            print("nooo")
        }
        
        let score = 91
        switch score {
        case _ where score > 90:
            print("优")
        default:
            print("一般")
        }
        
        
    }
    //MARK: - 控制流- if let 及 guard
    func demo5()  {
        //if let 及 guard的用法
        
        let oName:String? = "张三"
        var oAage:Int? //= 20
        if oName != nil && oAage != nil{
            print("mr" + oName! + "----" + String(oAage!))
        }
        
        if let name = oName, let age = oAage {
            print("mr" + name + "  age----" + String(age))
        }
        guard let name = oName else {
            print("oName为 nil")
            return
        }
        guard let age = oAage else {
            print("oAge为 nil")
            return
        }
        print("mr" + name + "  age----" + String(age))
    }
    
    //MARK: - 控制流 --  if分支和三目
    func demo4()  {
        let x = 10
        //if后面的（）可以省，但{}不能省
        if x == 3 {
            print("3")
        }else{
            print("10")
        }
        //swift中 三目运算符比较常用
        x < 10 ? print("aa") : print("bb")
    }
    
    //MARK: - 可选类型
    func demo3()  {
        //可选类型的用法
        //指定准确类型 : type
        let x:Double = 2
        print(x + 1.3)
        
        //可选项:一个变量可以为本身的类型 也可以为 nil,使用？定义
        let y:Int? = 10
        print(y)
        
        var z:Double?// = 2.2
        print(z)
        
        //可选类型：类型？  可选类型的变量解包：类型！(解包时要保证该可选类型的变量有值)
        // ??运算符优先级较低 用于判断变量或常量为空时 给变量或常量赋值
        var urlString:String? //= "http://www.baidu.com"
        
//        urlString = urlString ?? "888";
//            print(urlString)
        let url = URL(string: urlString ?? "_")
        print(url)

        print("---------")

        let req = URLRequest(url: url!)
        print(req)
        
//        if url != nil {
//            let request = URLRequest(url: url!)
//            print(request)
//        }
    }
    //MARK: -  let & var
    func demo2()  {
        //常量 变量
        /*
         自动推导
         隐式转换
         */
        let x = 20
        let y = 1.5
        let z = Double( x) + y
        print(z)
    }

    func demo1()  {
       //常量 变量
        let x = 20
        var y = 30
        y = 80
        print(x+y)
        return

        let v = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        v.backgroundColor = UIColor.red
        view.addSubview(v)
        
        //创建按钮
        let btn = UIButton(type: UIButtonType.contactAdd)
        view.addSubview(btn)
        btn.center = view.center
        btn.addTarget(self, action: #selector(testClick), for: UIControlEvents.touchUpInside)
        
        //        testClick()
    }
    @objc func testClick() {
        print("ddddd")
    }
 
}



























