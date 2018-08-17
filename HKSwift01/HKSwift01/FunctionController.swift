//
//  FunctionController.swift
//  HKSwift01
//
//  Created by houke on 2018/7/31.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
/*
 函数
  定义格式
  外部参数
  无返回值的三种情况
闭包
 闭包的定义
 尾随闭包
 循环引用
 
 闭包 闭包的定义 {(形参列表)->返回值类型 in 代码执行}
 类似于 OC中 block
 block
    - 是 c 语言的
    - 是一组预先准备好的代码，在需要的时候执行
    - 可以当做参数传递
    - 如果出现 self 需要注意循环引用
 在 swift中，函数本身就可以当做参数传递
 */

class FunctionController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        closure2(x: 3) { (html) in
//            print(html)
//        }
//        
//        handleData(urlStr: "http://www.baidu.com") { (string) in
//            print(string)
//        }
    }
    
    // MARK: - 网络请求
    func handleData(urlStr: String, completion: @escaping(String) -> ()) -> () {
        
        let url0 = URL(string: urlStr)
        
        guard let url = url0 else {
            print("网址为空")
            return
        }
     
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                
                print("网络请求失败 \(String(describing: error))")
                return
            }
            
            let html = String(data: data, encoding: .utf8)
            completion(html!)
            
            }.resume()
        
    }
    
    //闭包作为参数
    func closure2(x:Int , finish:@escaping (_:String)->()) {
        
        DispatchQueue.global().async {
            
            print("耗时操作 \(Thread.current)")
            DispatchQueue.main.async {
                print("完成 \(Thread.current)")
                
                finish("ssss\(x)")
            }
            
        }
    }
    
    func closureAsArguments()  {
        //    - 闭包作为函数的参数
        // ( 闭包名:()->() ) -> ()
        // Function types cannot have argument labels(argument labels 参数标签)
        //重要 闭包作为参数时，闭包不能使用参数标签
        func loadData(success : @escaping(_ : [String]) -> ()){
            
            let json = ["新闻", "图片", "热点"]
            
            success(json)
        }
        
        //@noescape : 如果这个闭包是在这个函数结束前被调用，就是非逃逸的闭包(默认)。
        //@escaping : 如果这个闭包是在函数执行完后才被调用，调用的地方超过了这函数的范围，所以叫逃逸闭包。
        
        /*调用*/
        // 尾随闭包 : 如果函数最后一个参数是闭包, 函数参数可以提前结果, 最后一个参数直接使用 {} 包装闭包的代码
        
        loadData(success: ({ (json) in
            print(json)
        }))
        // (相当于没有参数)
        loadData { (result) in
            
            print(result)
        }
        // 按照函数本身编写结果
        loadData(success: { (result) -> () in
            
            print(result)
        })
  
        // 闭包与block相同, 也有循环引用, 推荐用 [weak self]
        loadData { [weak self] (result) in
            
            print(self?.view as Any)
            print(result)
        }
    }
    
    func threeClosures()  {
        let cl1 = {print("无参数无返回值闭包")}
        cl1()
        let cl2 = {(x:Int, y:Int) -> () in print("有参数无返回值、\(x+y)")}
        cl2(10, 20)
        let cl3 = {(x:Int , y: Int)-> (Int) in return x*y}
        print("有参数有返回值 \(cl3(2, 6))")
    }
    class ClassA {
        // 接受非逃逸闭包作为参数
        func someMethod(closure: @escaping () -> Void) {
            // 想干什么？
        }
    }
    
    class ClassB {
        let classA = ClassA()
        var someProperty = "Hello"
        
        func testClosure() {
            classA.someMethod {
                // self 被捕获
                self.someProperty = "闭包内..."
            }
        }
    }
    
    func closure1() -> () {
        //closure闭包的定义 {(形参列表)->返回值类型 in 代码执行}
        //in用来区分函数定义和执行代码
        let blockFunc = {(x:Int,y:Int) -> Int in return x + y}
        
        print(blockFunc(10, 12))
    }
    
    //MARK: - 定义函数常量
    func funcLet() -> (){
        let sumFunc = sum
        let r = sumFunc(3, 3)
        print(r)
        print(sum(sum1:3, sum2: 7))
    }
    //MARK: 函数
    //func 函数名（形参列表） -> 返回值类型
    func sum(sum1:Int, sum2:Int) -> Int {
        return sum1 + sum2
    }
    
    //外部参数 此时的sum1 sum2就属于外部参数
    //外部参数在闭包中很重要
    func sum2(sum1 x:Int, sum2 y:Int) -> Int {
        return x+y
    }
    
    /*无返回值的三种类型
     1\返回值什么都不写
     2、返回值写 Void
     3\返回值写（）
     这三种类型在闭包中会使用
 */
    func noResult1(x:Int)  {
        print("test1")
    }
    func noResult2(x:Int) -> Void {
        print("test2")
    }
    func noResult3(x:Int) -> () {
        print("test3")
    }
}


































