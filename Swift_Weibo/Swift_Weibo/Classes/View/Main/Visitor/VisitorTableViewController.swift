//
//  VisitorTableViewController.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/21.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
/*
 提问：1、应用程序中创建了几个 visitorView?
        如果底部标签都被点击查看过则创建4个，每个控制器各自有各自的访客视图；如果启动后不做任何操作只创建一个
      2、visitorView如果用懒加载会怎样？
        访客视图在登录后也会被创建出来,因为每个控制器调用了isitorView?.setupInfo 
 */

class VisitorTableViewController: UITableViewController {

    ///用户登录标记
    var usrLogon = false
    ///访客视图
    var visitorView:VisitorView?
    
    
    override func loadView() {
        
        usrLogon ? super.loadView() : setupVisitorView()
    }

    func setupVisitorView()  {
        visitorView = VisitorView()
        view = visitorView
    }
}






















