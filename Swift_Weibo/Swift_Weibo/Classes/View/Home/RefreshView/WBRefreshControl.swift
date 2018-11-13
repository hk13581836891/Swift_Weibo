//
//  WBRefreshControl.swift
//  Swift_Weibo
//
//  Created by houke on 2018/11/2.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

private let WBRefreshControlOffset:CGFloat = -60

/// 自定义刷新控件 - 负责处理刷新逻辑
class WBRefreshControl: UIRefreshControl {
    
    //MARK: - 重写系统方法
    override func endRefreshing() {
        super.endRefreshing()
        //停止动画
        refreshView.stopAnimation()
    }
    //主动触发开始刷新动画 - 不会触发监听
    override func beginRefreshing() {
        super.beginRefreshing()
        refreshView.startAnimation()
    }
    //MARK: - kvo监听方法
    /**
     1、始终待在屏幕上
     2、下拉时，frame的 y一直变小，向上推 y一直变大
     3、默认的 y 是0
  */
    //箭头旋转标记
//    private var rotateFlag = false
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if frame.origin.y > 0 {
            return
        }
        //判断是否正在刷新
        if isRefreshing {
            refreshView.startAnimation()
            return
        }
        if frame.origin.y < WBRefreshControlOffset && !refreshView.rotateFlag {
            print("翻过来")
            refreshView.rotateFlag = true
        }else if (frame.origin.y >= WBRefreshControlOffset - 0.5 ) && refreshView.rotateFlag {
            print("转过去")
            refreshView.rotateFlag = false
        }
        print("---frame\(frame)")
    }
    
    //MARK: - 构造函数
    override init() {
        super.init()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI()  {
        //隐藏转轮
        tintColor = UIColor.clear
        
        addSubview(refreshView)
        
        //自动布局 - 从 xib加载的控件需要指定大小约束
        refreshView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.size.equalTo(refreshView.bounds.size)
        }
        //使用 kvo监听位置变化 - 主队列，当主线程有任务，就不调度队列中的任务执行
        //让当前运行循环中所有代码执行完毕后，运行循环结束前，开始监听
        //方法触发会在下一次运行循环开始
        DispatchQueue.main.async {
            self.addObserver(self, forKeyPath: "frame", options: [], context: nil)
        }
    }
    deinit {
        //删除 kvo 监听方法
        self.removeObserver(self, forKeyPath: "frame")
    }
    //MARK: - 懒加载控件
    private lazy var refreshView = WBRefreshView.refreshView()
}

/// 刷新视图 - 负责处理‘动画显示’
class WBRefreshView: UIView {
    
    /// 旋转标记
    var rotateFlag = false{
        didSet{
            var angle = CGFloat(Double.pi) + 0.5
            angle = self.rotateFlag ? angle - 0.50001 : 0;
            
            rotateTipIcon(angle: angle)
        }
    }
    
    @IBOutlet weak var loadingIconView: UIImageView!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var tipIconView: UIImageView!
    /// 从 nib加载视图
    class func refreshView() -> WBRefreshView {
        //推荐使用UINib 的方法是加载 nib
        let nib = UINib(nibName: "WBRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! WBRefreshView
    }
    func rotateTipIcon(angle : CGFloat)  {
        //旋转动画 特点：顺时针优先 + 就近原则
        UIView.animate(withDuration: 0.5) {
            self.tipIconView.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    /// 播放加载动画
    func startAnimation()  {
        tipView.isHidden = true
        
        //判断动画是否已经被添加
        let key = "transform.rotation"
        if loadingIconView.layer.animation(forKey: key) != nil {
            return
        }
        print("加载动画播放")

        let anim = CABasicAnimation(keyPath: key)
        anim.toValue = CGFloat(Double.pi * 2)
        anim.repeatCount = MAXFLOAT
        anim.duration = 0.5
        anim.isRemovedOnCompletion = false
        loadingIconView.layer.add(anim, forKey: key)
    }
    
    /// 停止加载动画
    func stopAnimation() {
        tipView.isHidden = false
        loadingIconView.layer.removeAllAnimations()
    }
}
