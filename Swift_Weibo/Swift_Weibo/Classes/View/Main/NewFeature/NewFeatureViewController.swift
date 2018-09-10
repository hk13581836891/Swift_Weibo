//
//  NewFeatureViewController.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/31.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
import SnapKit

//可重用 cellid
private let NewFeatureCellId = "NewFeatureCellId"
//新特性图像数量
private let NewFeatureImageCount = 4

class NewFeatureViewController: UICollectionViewController {
    
    //懒加载属性，必须在控制器实例化之后才会被创建，所以 init函数里的 layout 不能使用懒加载
//    private lazy var layout = UICollectionViewFlowLayout()
    //MARK: - 构造函数
    init(){
        //super.指定的构造函数
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UIScreen.main.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
//        layout.sectionInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        
        super.init(collectionViewLayout: layout)
        //构造函数完成之后内部属性才会被创建，所以 collectionView属性的设置放在 super.init之后
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 给该控制器去掉状态栏 ios 7.0以后，推荐使用该方法隐藏具体某个控制器的状态栏 默认是 no
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //注册可重用 cell
        self.collectionView!.register(NewFeatureCell.self, forCellWithReuseIdentifier: NewFeatureCellId)
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return NewFeatureImageCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:NewFeatureCell = collectionView.dequeueReusableCell(withReuseIdentifier: NewFeatureCellId, for: indexPath) as! NewFeatureCell
    
        cell.backgroundColor = UIColor.randomColor
        cell.imageIndex = indexPath.item
    
        return cell
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //在最后一页调用动画方法， 根据 contentoffset计算页数
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        //如果不是最后一页，则不显示动画
        if page != NewFeatureImageCount - 1 {
            return
        }
        let cell:NewFeatureCell = collectionView?.cellForItem(at: IndexPath(item: page, section: 0)) as! NewFeatureCell
        cell.showButtonAnimation()
    }
}

//MARK: - 新特性 cell
/// 以下写法类似于 oc中在一个.m 文件中写的两个类的实现@implementaition（两个类如果关系紧密,第二个类可以不必写.h文件）
private class NewFeatureCell : UICollectionViewCell {
    
    //图像属性
    var imageIndex:Int = 0 {
        didSet {
            iconView.image = UIImage(named: "new_feature_\(imageIndex + 1)")
            //隐藏按钮
            startButton.isHidden = true
        }
    }
    
    @objc func startBtnClick() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBSwitchRootViewControllerNotification), object: nil)
    }
    
    func showButtonAnimation()  {
        startButton.isHidden = false
        startButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1.6, //动画时长
                       delay: 0,            //延时时间
                       usingSpringWithDamping: 0.6, //弹力系数，0~1，越小越弹
                       initialSpringVelocity: 10, //初始速度，模拟重力加速度
                       options: UIViewAnimationOptions.allowAnimatedContent, //动画选项
                       animations: {
                        self.startButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                        },
                       completion: nil)
    }
    
    //frame 大小是 layout.itemsize 指定的
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI()  {
        addSubview(iconView)
        addSubview(startButton)
        
        iconView.frame = bounds
        startButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).multipliedBy(0.7)
        }
        
        startButton.addTarget(self, action: #selector(startBtnClick), for: UIControlEvents.touchUpInside)
        /*
         响应者链条
         控件无法进行用户交互的五种情况
         1、alpha < 0.01
         2、isHidden = true
         3、控件本身的位置在父视图的外面
         4、userInteractionEnable = false
         5、上面覆盖了一个接收用户交互的控件
         */
        
    }
    //MARK: - 懒加载控件
    //图像
    private lazy var iconView:UIImageView = UIImageView()
    private lazy var startButton:UIButton = UIButton(title: "开始体验", color: UIColor.white, backImageName: "new_feature_finish_button")
    
}







































