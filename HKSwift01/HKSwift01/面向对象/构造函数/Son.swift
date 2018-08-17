//
//  Son.swift
//  HKSwift01
//
//  Created by houke on 2018/8/2.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

class Son: Person {

    var no:String?
    
    //如果子类没有实现父类的方法，在执行时，会直接调用父类的方法
    //在编译时子类调用的方法对于子类是同样存在的,只不过在子类里没有实现代码,在调用的时候是调用父类的实现代码(继承 - oc也一样)
    
    
    //如果父类没有实现 init()函数，则子类也不能重写 init函数
//    override init() {
//        sonName = "sonOverride"
//        testP = "testP"
//        super.init()
//    }
    //重写父类方法
//    override init(name: String, age: Int) {
//        no = "002"
//        super.init(name: name, age: age)
//    }
//    
//    init(name: String, age: Int, no:String) {
//        self.no = no
//        super.init(name: name, age: age)
//    }
}
