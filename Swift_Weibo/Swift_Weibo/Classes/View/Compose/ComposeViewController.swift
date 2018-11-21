//
//  ComposeViewController.swift
//  Swift_Weibo
//
//  Created by houke on 2018/11/20.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {

    //表情键盘视图
    private lazy var emojiView = HKEmoticonView {[weak self] (emoticon) in
        
        self?.textView.insertEmoticon(em: emoticon)
    }
    // MARK: - 监听方法
    //关闭
    @objc private func close() {
        //关闭键盘
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    //发布微博
    @objc private func sendStatus() {
        //1 获得文本内容
        let text = textView.emoticonText
        //2 发布微博
        NetworkTools.sharedTools.sendStatuss(status: text) { (result, error) in
//            if error != nil {
//                print("出错了")
//                SVProgressHUD.showInfo(withStatus: "您的网络不给力")
//                return
//            }
            SVProgressHUD.showInfo(withStatus: "安全域名有问题，无法发送")
        }
        
    }
    //选择表情
    @objc private func selectEmoticon() {
        print("选择表情")
        //如果是系统键盘 则 textView.inputView为 nil
        //1 退掉键盘
        textView.resignFirstResponder()
        //2 设置键盘
        textView.inputView = textView.inputView != nil ? nil : emojiView
        //3 重新激活键盘
        textView.becomeFirstResponder()
    }
    // MARK: - 键盘处理
    //键盘变化处理
    @objc private func keyboardChanged(n: Notification)  {
        print(n)
        //1 获取目标 rect - 字典中的结构体是 NSValue
        let rect = (n.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        print(rect)
        
        //2 更新toolbar约束
        toolbar.snp.updateConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(rect.origin.y - view.bounds.height)
        }
        
        //3 toolbar更新完约束如果不加动画效果则会直接布局，而键盘的显示有0.25延时动画，如果不给toolbar增加动画效果，toolbar更新完约束直接显示出来，跟键盘之间产生空白区域
        //动画 - UIView 块动画 本质上是对 CAAnimation 的包装
        let duration = (n.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        //动画曲线
        let curve = (n.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue
        
        UIView.animate(withDuration: duration) {
           //设置动画曲线
            /**
             曲线值 = 7
             - 如果之前的动画没有完成，又启动了其他动画，让动画的图层直接d运动到后续动画的目标位置
             - 一旦设置为7，动画时长无效， 动画时长会同一变成0.5s
             */
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve)!)
            
            //更新约束
            self.view.layoutIfNeeded()
        }
        
        //调试动画时长 - keyPath 将动画添加到图层上
        let ani = toolbar.layer.animation(forKey: "position")
        print("动画时长 \(String(describing: ani?.duration))")
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.allowsEditingTextAttributes = true
        textView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(n:)), name:NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
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


// MARK: - UITextViewDelegate
extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
        placeHolderLab.isHidden = textView.hasText
    }
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
        
        //默认禁用发布微博按钮
        navigationItem.rightBarButtonItem?.isEnabled = false
        
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
