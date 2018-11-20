//
//  ComposeViewController.swift
//  Swift_Weibo
//
//  Created by houke on 2018/11/20.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    // MARK: - 监听方法
    //关闭
    @objc private func close() {
        //关闭键盘
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    //发布微博
    @objc private func sendStatus() {
        print("发布微博")
    }
    //选择表情
    @objc private func selectEmoticon() {
        print("选择表情")
    }
    // MARK: - 视图生命周期
    override func loadView() {
        view = UIView()
         setupUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //激活键盘
        textView.becomeFirstResponder()
    }
    // MARK: - 懒加载控件
    //工具条
    private lazy var toolbar = UIToolbar()
    
    /// 文本视图
    lazy var textView:UITextView = {
       let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.textColor = UIColor.darkGray
        //始终允许垂直滚动，默认为 false,设为 true时，几遍内容区域小于整体区域也可以滚动
        tv.alwaysBounceVertical = true
        //设置关闭键盘的模式
        tv.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        return tv
    }()
    
    //占位标签
    private lazy var placeHolderLab:UILabel = UILabel(title: "分享新鲜事...", color: UIColor.lightGray, fontSize: 18)
}

// MARK: - 设置界面
private extension ComposeViewController {
    func setupUI()  {
        //1设置背景颜色
        view.backgroundColor = UIColor.white
        //2设置控件
        prepareNavgationBar()
        prepareToobar()
        prepareTextView()
    }
    
    private func prepareTextView() {
        view.addSubview(textView)
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(toolbar.snp.top)
        }
        textView.text = "分享新鲜事..."
        //添加占位标签
        textView.addSubview(placeHolderLab)
        
        placeHolderLab.snp.makeConstraints { (make) in
            make.top.equalTo(textView).offset(8)
            make.left.equalTo(textView).offset(5)
        }
    }
    //准备工具条
    func prepareToobar() {
        //添加控件
        view.addSubview(toolbar)
        
        //自动布局
        toolbar.snp.makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(44)
        }
        
        //添加按钮
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                           ["imageName": "compose_mentionbutton_background"],
                           ["imageName": "compose_trendbutton_background"],
                           ["imageName": "compose_emoticonbutton_background", "actionName": "selectEmoticon"],
                           ["imageName": "compose_add_background"]]
        var items = [UIBarButtonItem]()
        for dict in itemSettings {
            
            items.append(UIBarButtonItem(imageName: dict["imageName"]!, target: self, actionName: dict["actionName"]))
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolbar.items = items
    }
    
    /// 设置导航栏
    func prepareNavgationBar() {
        //1 左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: UIBarButtonItemStyle.plain, target: self, action: #selector(sendStatus))
        
        //2 标题视图
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 36))
        navigationItem.titleView = titleView
        
        //3 添加子控件
        let titleLab = UILabel(title: "发微博", fontSize: 15)
        let nameLab = UILabel(title: UserAccountViewModel.sharedUserAccount.account?.screen_name ?? "", color: UIColor.lightGray, fontSize: 13)
        titleView.addSubview(titleLab)
        titleView.addSubview(nameLab)
        
        titleLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleView)
            make.top.equalTo(titleView)
        }
        nameLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleView)
            make.bottom.equalTo(titleView)
        }
    }
}
