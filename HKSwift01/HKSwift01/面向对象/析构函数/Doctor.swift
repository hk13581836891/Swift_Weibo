//
//  Doctor.swift
//  HKSwift01
//
//  Created by houke on 2018/8/6.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

@objcMembers class Doctor: Teacher {

    /*
     构造过程：从子类开始，分配空间，初始化属性。向父类依次调用。一直到所有的属性全部就绪
     析构过程：从子类开始释放，自动调用父类的析构函数，释放父类的属性。释放过程和构造过程完全一样
     */
    deinit {
        print("doctor 88")
    }
}




















