//
//  VisitorTableViewController.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/21.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
/**
 传递点击事件
 1、使用代理
 2、通过监听方法
 */
/*
 提问：1、应用程序中创建了几个 visitorView?
        如果底部标签都被点击查看过则创建4个，每个控制器各自有各自的访客视图；如果启动后不做任何操作只创建一个
      2、visitorView如果用懒加载会怎样？
        访客视图在登录后也会被创建出来,因为每个控制器调用了isitorView?.setupInfo 
 */

class VisitorTableViewController: UITableViewController {

    ///用户登录标记
    var usrLogon = UserAccountViewModel.sharedUserAccount.userLogon
    ///访客视图
    var visitorView:VisitorView?
    
    
    override func loadView() {
        
        usrLogon ? super.loadView() : setupVisitorView()
    }

    func setupVisitorView()  {
        visitorView = VisitorView()
        //1、设置代理
//        visitorView?.delegate = self
        //2、直接添加监听方法
        visitorView?.registerBtn.addTarget(self, action: #selector(registerBtnClick), for: UIControlEvents.touchUpInside)
        visitorView?.loginBtn.addTarget(self, action: #selector(loginBtnClick), for: UIControlEvents.touchUpInside)
        
        //设置导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.plain, target: self, action: #selector(registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.plain, target: self, action: #selector(loginBtnClick))
        
        view = visitorView
    }
    @objc func registerBtnClick()  {
        print("zhuce")
    }
    @objc func loginBtnClick()  {
        print("登录")
        let vc = OAuthViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        present(nav, animated: true, completion: nil)
    }
}

extension VisitorTableViewController:VisitorViewDelegate {
    
    func visitorViewDidRegister() {
        print("注册")
    }
    func visitorViewDidLogin() {
        print("登录")
    }
}





















