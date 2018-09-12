//
//  StatusPictureView.swift
//  Swift_Weibo
//
//  Created by houke on 2018/9/11.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

/// 照片之间的间距
private let StatusPictureViewItemMargin: CGFloat = 8

/// 配图视图
class StatusPictureView: UICollectionView {
    
//    var picsSize:CGSize
    
    /// 微博视图模型
    var viewModel:StatusViewModel? {
        didSet{
            sizeToFit()
            print(viewModel?.status.text)
            
            
            //问题描述：创建StatusCell过程中，StatusPictureView的 init()及数据源方法仅在开始调用3次,以后不会再被调用
            //刷新数据 - 为解决tableView的 StatusCell复用时，导致 cell里的StatusPictureView中的UICollectionViewCell也会被复用的问题
            //reloadData() 能使UICollectionViewCell数据源方法在每个StatusCell创建都会被调用
            reloadData()
        }
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return calcViewSize()
    }
    
    //MARK: - 构造函数
    init() {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        //设置间距 - UICollectionView默认 itemSize 50 * 50
        layout.minimumInteritemSpacing = StatusPictureViewItemMargin
        layout.minimumLineSpacing = StatusPictureViewItemMargin
        
        super.init(frame: CGRect(), collectionViewLayout: layout)
        
        //设置数据源, 自己做自己的数据源
        //应用场景：自定义视图的小框架
        dataSource = self
        
        //注册可重用 cell
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: "\(StatusPictureView.self)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 数据源方法
extension StatusPictureView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("!!!!!!!!!!!!!!1")
        print("\(String(describing: viewModel?.thumbnailUrls?.count))")
        return viewModel?.thumbnailUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(StatusPictureView.self)", for: indexPath)
        cell.backgroundColor = UIColor.purple
        
        return cell
        
    }
}

// MARK: - 计算视图大小
extension StatusPictureView {
    
    /// 计算视图大小
    private func calcViewSize() -> CGSize {
        
        let count = viewModel?.thumbnailUrls?.count ?? 0
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        
        //0张图片
        if count == 0 {
            return CGSize(width: 0, height: 0)
        }
        
        //一张图片
        if count == 1 {
            self.backgroundColor = UIColor.yellow
            let size = CGSize(width: 100, height: 150)
            layout.itemSize = size
            return size
        }
        
        let rowCont:CGFloat = 3
        let itemW = ((UIScreen.main.bounds.size.width - StatusCellMargin * 2) - StatusPictureViewItemMargin * 2) / rowCont
        layout.itemSize = CGSize(width: itemW, height: itemW)
        
        //4张图片
        if count == 4 {
            self.backgroundColor = UIColor.red
            let w = itemW * 2 + StatusPictureViewItemMargin
            return CGSize(width: Int(w), height: Int(w))
        }
        
        //其他张数
        self.backgroundColor = UIColor.blue
        let w = UIScreen.main.bounds.size.width - StatusCellMargin * 2
        let row = CGFloat((count - 1) / Int(rowCont) + 1)
        let h = row * itemW + (row - 1) * StatusPictureViewItemMargin
        
        return CGSize(width: w, height: h)
    }
}

























