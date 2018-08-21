//
//  MainViewController.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/20.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    //MARK: - 监听方法
    @objc func composeButtonClick()  {
        print("dd")
    }
    

    //MARK: - 生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewControllers()
        setUpcomposeButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let w:CGFloat = (tabBar.bounds.width / CGFloat( (tabBar.items?.count)!) + 2.0)
        composeButton.frame = CGRect(origin: CGPoint(x: tabBar.bounds.width/2 - w/2, y: 0), size: CGSize(width: w, height:tabBar.bounds.height))
        tabBar.bringSubview(toFront: composeButton)
    }
    
    //MARK: - 懒加载控件
    lazy var composeButton:UIButton = UIButton(
        imageName: "tabbar_compose_icon_add",
        backImageName: "tabbar_compose_button")
    
}

//MARK: - 设置界面
extension MainViewController{
    
    func setUpcomposeButton()  {

        tabBar.addSubview(composeButton)
        composeButton.addTarget(self, action: #selector(composeButtonClick), for: UIControlEvents.touchUpInside)
    }
 
    func addChildViewControllers(){
        
        //设置 tintColor - 图片渲染颜色
        //性能提升技巧：如果能用颜色解决，就不建议使用图片
        tabBar.tintColor = UIColor.orange
        addChildViewController(vc: HomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(vc: MessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(UIViewController())
        addChildViewController(vc: DiscoveryTableViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(vc: ProfileTableViewController(), title: "我的", imageName: "tabbar_profile")
    }
    
    /// 添加控制器
    /// - Parameters:
    ///   - vc: vc
    ///   - title: title
    ///   - imageName: imageName
    func addChildViewController(vc:UIViewController, title:String, imageName:String) {
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        
        let nav = UINavigationController(rootViewController: vc)
        addChildViewController(nav)
        //标题设置 - 由内至外添加（homeVC -> nav -> UITabBarController）

    }
}





























