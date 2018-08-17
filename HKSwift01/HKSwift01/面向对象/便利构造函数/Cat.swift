//
//  Cat.swift
//  HKSwift01
//
//  Created by houke on 2018/8/6.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

class Cat: Animal {

    var color : String?
    
    //如果子类没有实现父类的方法 执行时，会直接调用父类的方法
    //如果子类没有实现便利构造函数，调用方同样可以使用父类的便利构造函数，实例化子类对象
    //便利构造函数，不能被继承也不能被重写
    
}
