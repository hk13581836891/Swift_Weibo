//
//  VisitorView.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/21.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
import SnapKit

//通过代理方法传递访客视图监听方法
/// 访客视图的协议
protocol VisitorViewDelegate: NSObjectProtocol {
    //注册
    func visitorViewDidRegister()
    //登录
    func visitorViewDidLogin()
}

///访客视图 - 处理用户未登录的界面
class VisitorView: UIView {

    /// 代理
    weak var delegate: VisitorViewDelegate?
    
    //MARK: - 监听方法
    @objc private func registerBtnClick() {
        delegate?.visitorViewDidRegister()
    }
    @objc private func loginBtnClick() {
        delegate?.visitorViewDidLogin()
    }
    
    //MARK: - 设置视图信息
    /// 设置视图信息
    ///
    /// - Parameters:
    ///   - imageName: 图片名称，首页设置为 nil
    ///   - title: 消息文字
    func setupInfo(imageName:String?, title:String) {
        messageLab.text = title
        
        guard let imgName = imageName else {
            //播放动画
            startAnim()
            return
        }
        
        iconView.image = UIImage(named: imgName)
        homeIconImage.isHidden = true//隐藏小房子
        sendSubview(toBack: maskIconView)//将遮罩隐藏到底层
    }
    
    ///开启首页转轮动画
    func startAnim()  {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = CGFloat.pi * 2
        anim.repeatCount = MAXFLOAT
        anim.duration = 20
        
        //用在不断重复的动画上，当动画绑定的图层对应的视图被销毁，动画会自动释放
        anim.isRemovedOnCompletion = false
        //添加到图层
        iconView.layer.add(anim, forKey: nil)
    }
    //MARK: - 构造函数
    //init with frame 是 UIView的指定构造函数
    //使用纯代码开发使用的
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    //init with coder - 使用 storyboard 或者 xib开发加载的函数
    //使用 sb开始的入口
    required init?(coder aDecoder: NSCoder) {
        //fatalError如果使用 sb 开发，调用这个视图 会直接崩溃
        //fatalError阻止使用 sb使用当前自定义视图
        //如果只希望当前视图被纯代码方式加载，就可以使用fatalError
        //若想使用 sb开发，把当前行注释掉,使用super.init(coder: aDecoder)即可
        // fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setupUI()
    }
    //MARK: - 加载控件
    //UIImageView 使用 image:构造函数创建的 imageView 默认的就是 image的大小
    private lazy var iconView:UIImageView = UIImageView(imageName: "visitordiscover_feed_image_smallicon")
    private lazy var maskIconView:UIImageView = UIImageView(imageName: "visitordiscover_feed_mask_smallicon")
    private lazy var homeIconImage:UIImageView = UIImageView(imageName: "visitordiscover_feed_image_house")
    private lazy var messageLab:UILabel = UILabel(title: "")
    lazy var registerBtn:UIButton = UIButton(title: "注册", color: UIColor.orange, imageName: "common_button_white_disable")
    lazy var loginBtn:UIButton = UIButton(title: "登录", color: UIColor.darkGray, imageName: "common_button_white_disable")
}

 extension VisitorView
{
    ///设置界面
    func setupUI()  {
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(homeIconImage)
        addSubview(messageLab)
        addSubview(registerBtn)
        addSubview(loginBtn)
        registerBtn.addTarget(self, action: #selector(registerBtnClick), for: UIControlEvents.touchUpInside)
        loginBtn.addTarget(self, action: #selector(loginBtnClick), for: UIControlEvents.touchUpInside)
        
        layoutWithSnapKit()
    //设置背景颜色 - 灰度图 R = G = B 在 UI 元素中，大多都使用灰度图或者纯色图（安全色- 在不同设备上视觉效果一致）
    backgroundColor = UIColor(white: 237.0 / 255.0, alpha: 1)
    }
    
    func layoutWithSnapKit() {
        //图标
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-60)
        }
        //小房子
        homeIconImage.snp.makeConstraints { (make) in
            make.center.equalTo(iconView)
        }
        //消息文字
        messageLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(iconView.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 230, height: 36))
        }
        //注册按钮
        registerBtn.snp.makeConstraints { (make) in
            make.left.equalTo(messageLab)
            make.top.equalTo(messageLab.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        //登录按钮
        loginBtn.snp.makeConstraints { (make) in
            make.right.equalTo(messageLab)
            make.top.equalTo(registerBtn)
            make.size.equalTo(registerBtn)
        }
        //遮罩
        maskIconView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.width.equalTo(self)
            make.bottom.equalTo(registerBtn)
        }
    }
        
    func layoutWithSwiftNativeCode() {
        //设置自动布局
        /*
         1\添加约束需要添加到父视图上
         2\字视图最好有一个统一的参照物
         "view1.attr1 = view2.attr2 * multiplier + constant"
         */
        //translatesAutoresizingMaskIntoConstraints 默认是 true,支持使用 setFrame的方式设置控件位置
        //false支持使用自动布局来设置控件位置
        for view in self.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        //图标
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: -60))
        
        //小房子
        addConstraint(NSLayoutConstraint(item: homeIconImage, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: iconView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: homeIconImage, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: iconView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0))
        //消息文字
        addConstraint(NSLayoutConstraint(item: messageLab, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: iconView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: messageLab, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: iconView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 20))
        addConstraint(NSLayoutConstraint(item: messageLab, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 230))
        addConstraint(NSLayoutConstraint(item: messageLab, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 36))
        //注册按钮
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: messageLab, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: messageLab, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 20))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 36))
        //登录按钮
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: messageLab, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: messageLab, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 20))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 36))
        
        //遮罩
        /*VFL:可视化格式语言
         H:水平方向
         V:垂直方向
         I:边界
         []包装控件
         views:一个字典 [名字: 控件名] - VFL 字符串中表示控件的字符串
         metrics:一个字典 [名字: NSNumber] - VFL字符串中表示某一个数组
         */
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[mask]-0-|", options: [], metrics: nil, views: ["mask": maskIconView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[mask]-(btnH)-[regBtn]", options: [], metrics: ["btnH": -36], views: ["mask": maskIconView, "regBtn": registerBtn]))
    }
}


























