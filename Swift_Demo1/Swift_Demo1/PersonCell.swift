//
//  PersonCell.swift
//  Swift_Demo1
//
//  Created by houke on 2018/8/14.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {
    
    //个人模型 Swift中设置模型可以用 didSet
    var person:Person?{
        didSet{
            //不需要使用‘_成员变量 = 变量’， 因为已经完成设置了
            //当 person模型被设置值完成后，执行的代码
            nameLab.text = person?.name
            ageLab.text = "年龄：" + "\(person?.age ?? 0)"
            
        }
    }
    
    
    @IBOutlet weak var ageLab: UILabel!
    @IBOutlet weak var nameLab: UILabel!
}
