//
//  ViewController.swift
//  SwiftTableViewDemo2
//
//  Created by houke on 2018/8/17.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var tableView:UITableView = {
    //实例化 tableview时，需要指定样式，指定后不能再修改
    let tab = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tab.dataSource = self //设置数据源
        //注册可重用 cell
        tab.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return tab
    
    }()
    //纯代码创建视图层次结构 - 和 storyboard、xib等价
    override func loadView() {
         //设置视图
        view = tableView
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
}

//此处是遵守 tableView 数据源协议，（swift遵守协议跟继承很像）；
//数据源协议里的必选函数（非optional），如果不全都实现 ，则会报错
//swift 中，遵守协议的写法，类似于与他语言中的多继承
//oc中没有多继承，可以使用协议替代
extension ViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //方法1 使用此方法必须注册可重用 cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "hello \(indexPath.row)"
        return cell
 
        /*
         //方法2 不要求必须注册可重用 cell,返回值是可选的（在 ios7.0以后用的不多）
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "hello \(indexPath.row)"
        return cell!
         */
        
    }
}






























