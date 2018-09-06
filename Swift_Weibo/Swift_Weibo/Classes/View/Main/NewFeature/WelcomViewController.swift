//
//  WelcomViewController.swift
//  Swift_Weibo
//
//  Created by houke on 2018/9/3.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomViewController: UIViewController {

    
    /// 设置界面，视图的层次结构
    override func loadView() {
        //直接使用背景图像作为根视图，不用关心图像的缩放问题
        view = backImageView
        setupUI()
    }
    
    /// 视图加载完成之后的后续处理，通常用来设置数据
    override func viewDidLoad() {
        super.viewDidLoad()
        //异步加载用户头像
        iconView.setImageWith(UserAccountViewModel.sharedUserAccount.avatarUrl, placeholderImage: UIImage(named: "avatar_default_big"))
    }
    
    //动画效果放到DidAppear
    //视图已经显示，通常可以动画/键盘处理
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
        //1、更改约束 - 改变位置
        //updateConstraints用来更新已经设置过的约束
        //multiplier 是只读属性，创建之后不允许修改
        /*
         使用自动布局开发，有一个原则：
         - 所有'使用约束'设置位置的控件，不要再设置 ‘frame’
         
            * 原因：自动布局系统会根据设置的约束，自动计算控件的frame
            * 在layoutSubviews函数中设置frame
            * 如果程序员主动修改frame,会引起自动布局系统计算错误!
         
         - 工作原理：当有一个运行循环启动，自动布局系统，会收集所有的约束变化
         - 在运行循环结束前，调用 layoutSubviews 函数统一设置 frame
         - 如果希望某些约束提前更新!使用‘layoutIfNeeded’函数 让自动布局系统提前更新当前收集到的约束变化
         */
        
        iconView.snp.updateConstraints { (make) in
             make.bottom.equalTo(view).offset( -UIScreen.main.bounds.size.height * 0.7)
        }
        
//        //2、动画
        UIView.animate(withDuration: 1.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            //修改所有‘可动画’属性 - 自动布局动画
            self.view.layoutIfNeeded()
        }, completion:  { (_) in
            UIView.animate(withDuration: 1, animations: {
                self.welcomeLab.alpha = 1
            }, completion: { (_) in
                //不推荐写法
//                UIApplication.shared.keyWindow?.rootViewController = MainViewController()
                //发送通知
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBSwitchRootViewControllerNotification), object: nil)
            })
        })
        
    }

    //MARK: - 懒加载控件
    /// 背景图像
    private lazy var backImageView:UIImageView = UIImageView(imageName: "ad_background")
    private lazy var iconView:UIImageView = {
        let iv = UIImageView(imageName: "avatar_default_big")
        iv.layer.cornerRadius = 45
        iv.layer.masksToBounds = true
        return iv
    }()
    private lazy var welcomeLab:UILabel = {
        let lab:UILabel = UILabel(title: "欢迎归来", fontSize: 18)
        lab.alpha = 0
        return lab
    }()
}

// MARK: - 设置界面
extension WelcomViewController {
    private func setupUI()  {
        //1、添加控件
        view.addSubview(iconView)
        view.addSubview(welcomeLab)
        
        //2、自动布局
        iconView.snp.makeConstraints { (make) in
            print(view)
            make.centerX.equalTo(view)
            //multiplier 是只读属性，创建之后不允许修改，所以此处不使用
            make.bottom.equalTo(view).offset( -(UIScreen.main.bounds.size.height * 0.3))
            make.size.equalTo(CGSize(width: 90, height: 90))

        }
        welcomeLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(iconView.snp.bottom).offset(20)
        }
    }
}





























