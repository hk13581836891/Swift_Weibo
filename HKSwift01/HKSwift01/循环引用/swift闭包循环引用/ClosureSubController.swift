//
//  ClosureSubController.swift
//  HKSwift01
//
//  Created by houke on 2018/8/9.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

class ClosureSubController: UIViewController {
    
    var complateClosure : ((String) -> ())?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //MARK: - 解决循环引用三种方法
    //3、swift 方法2
    func method3() -> () {
        //[unowned self]表示闭包中的 self 都是assign, 如果 self被释放，闭包中的 self地址不会修改
        //与oc 中__unsafe_unretained 类似，如果 self被释放，会出现野指针
        //闭包是该类 属性的情况下 不会出问题
        loadData { [unowned self] (result) in
            print(result)
            print(self.view)
        }
    }
    //2、swift 方法1
    func method2() -> () {
        //[weak self]表示闭包中的 self 都是弱引用
        //与__weak 类似，如果 self被释放，什么也不做更安全
        loadData { [weak self] (result) in
            print(result)
            //self?表示对象一旦被释放，不再访问其属性或者方法
            print(self?.view as Any)
        }
    }
    //1、oc传统方法
    func method1() ->  (){
        //weak小户型在运行时可能会被改变 -> 执行对象一旦被释放就会变成 nil
        //weak 属性不能用 let 定义
        weak var weakSelf = self
        loadData { (result) in
            print(result)
            //闭包中一定要使用 self
            //weakSelf？ 表示对象一旦被释放，不再访问其属性或者方法
            print(weakSelf?.view as Any)
        }
    }
    func loadData(complated: @escaping (_:String) -> ()) {
        
        complateClosure = complated
        DispatchQueue.global().async {
            print("模拟异步加载数据")
            
            DispatchQueue.main.async {
                print("主线程回调")
//                complated("testString")
                self.complateClosure?("test111")
            }
        }
    }

    deinit {
        print("控制器 88")
    }
}
