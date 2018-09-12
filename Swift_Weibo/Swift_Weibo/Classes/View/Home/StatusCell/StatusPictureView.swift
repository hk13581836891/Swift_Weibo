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
        }
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return calcViewSize()
    }
    
    //MARK: - 构造函数
    init() {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 计算视图大小
extension StatusPictureView {
    
    /// 计算视图大小
    private func calcViewSize() -> CGSize {
        
        let count = viewModel?.thumbnailUrls?.count ?? 0
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        
        if count == 0 {
            return CGSize(width: 0, height: 0)
        }
        
        if count == 1 {
            self.backgroundColor = UIColor.yellow
            let size = CGSize(width: 100, height: 150)
            layout.itemSize = size
            return size
        }
        
        let rowCont:CGFloat = 3
        let itemW = ((UIScreen.main.bounds.size.width - StatusCellMargin * 2) - StatusPictureViewItemMargin * 2) / rowCont
        layout.itemSize = CGSize(width: itemW, height: itemW)
        
        if count == 4 {
            self.backgroundColor = UIColor.red
            let w = itemW * 2 + StatusPictureViewItemMargin
            return CGSize(width: Int(w), height: Int(w))
        }
        
        self.backgroundColor = UIColor.blue
        let w = UIScreen.main.bounds.size.width - StatusCellMargin * 2
        let row = CGFloat((count - 1) / Int(rowCont) + 1)
        let h = row * itemW + (row - 1) * StatusPictureViewItemMargin
        
        return CGSize(width: w, height: h)
    }
}

























