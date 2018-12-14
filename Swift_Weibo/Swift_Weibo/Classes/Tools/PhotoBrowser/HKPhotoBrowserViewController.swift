//
//  HKPhotoBrowserViewController.swift
//  Swift_Weibo
//
//  Created by houke on 2018/12/5.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

/// 照片浏览器
class HKPhotoBrowserViewController: UIViewController {

    /// 照片 URL 数组
    private var urls:[URL]
    
    /// 当前选中照片索引
    var currentIndexPath:IndexPath
    
    //MARK: - 监听方法
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    @objc func save() {
        print("保存照片")
    }
    
    //MARK: - 构造函数 属性都是必选,不用在后续考虑解包的问题
    init(urls:[URL] , indexPath:IndexPath){
        self.urls = urls
        self.currentIndexPath = indexPath
        //调用父类方法
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        var rect = UIScreen.main.bounds
        rect.size.width += 20
        view = UIView(frame: rect)
        view.backgroundColor = UIColor.white
        
        setupUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.urls)
        print(self.currentIndexPath)
    }
    
    //MARK: - 懒加载控件
    private lazy var collectionView:UICollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: HKPhotoBrowerViewLayout())
    private lazy var closeBtn:UIButton = UIButton(title: "关闭", fontSize: 14, color: UIColor.white, imageName: nil, backColor: UIColor.darkGray)
    private lazy var saveBtn:UIButton = UIButton(title: "保存", fontSize: 14, color: UIColor.white, imageName: nil, backColor: UIColor.darkGray)
    
    //MARK: - 自定义流水布局
    private class HKPhotoBrowerViewLayout:UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            
            itemSize = collectionView!.bounds.size
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = .horizontal
            
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
}

// MARK: - 设置 UI
private extension HKPhotoBrowserViewController {
    func setupUI()  {
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        collectionView.frame = view.bounds
        closeBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-StatusCellMargin)
            make.left.equalTo(view).offset(StatusCellMargin)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        saveBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-StatusCellMargin)
            make.right.equalTo(view).offset(-StatusCellMargin)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        
        closeBtn.addTarget(self, action: #selector(close), for: UIControlEvents.touchUpInside)
        saveBtn.addTarget(self, action: #selector(save), for: UIControlEvents.touchUpInside)
        
        prepareCollectionView()
    }
    
    private func prepareCollectionView() {
        collectionView.register(HKPhotoBrowserCell.self, forCellWithReuseIdentifier: "\(HKPhotoBrowserCell.self)")
        
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension HKPhotoBrowserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(HKPhotoBrowserCell.self)", for: indexPath) as! HKPhotoBrowserCell
        cell.backgroundColor = UIColor.black
        cell.imageUrl = urls[indexPath.item]
        return cell
    }
}



















