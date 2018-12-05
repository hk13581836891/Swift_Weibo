//
//  StatusPictureView.swift
//  Swift_Weibo
//
//  Created by houke on 2018/9/11.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
import SDWebImage

/// 照片之间的间距
private let StatusPictureViewItemMargin: CGFloat = 8

/// 配图视图
class StatusPictureView: UICollectionView {
    
//    var picsSize:CGSize
    
    /// 微博视图模型
    var viewModel:StatusViewModel? {
        didSet{
            backgroundColor = UIColor.clear
            sizeToFit()
            
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
        delegate = self
        
        //注册可重用 cell
        register(StatusPictureViewCell.self, forCellWithReuseIdentifier: "\(StatusPictureViewCell.self)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 数据源方法
extension StatusPictureView : UICollectionViewDataSource , UICollectionViewDelegate {
    
    
    /// 选中照片
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //传递当前 URL数组/ 当前用户选中索引
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBStatusSelectedPhotoNotification), object: self, userInfo: [WBStatusSelectedPhotoIndexPathKey:indexPath, WBStatusSelectedPhotoURLsKey:viewModel!.thumbnailUrls!])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.thumbnailUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(StatusPictureViewCell.self)", for: indexPath) as! StatusPictureViewCell
        cell.imgurl = viewModel?.thumbnailUrls?[indexPath.item]
        
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
            var size = CGSize(width: 0, height: 0)
            if let key = viewModel?.thumbnailUrls?.first?.absoluteString {
                
                //利用 SDWebImage价差本地缓存的图像 - key:是 url的完成字符串
               let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: key)
                size = image?.size ?? size
            }
            //过窄处理 - 针对长图
            size.width = size.width < 40 ? 40 :size.width
            //过宽的图片
            if size.width > 300 {
                let w:CGFloat = 300
                let h = size.height * w / size.width
                size = CGSize(width: w, height: h)
            }
            //配图视图的大小
            layout.itemSize = size
            return size
        }
        
        let rowCont:CGFloat = 3
        let itemW = ((UIScreen.main.bounds.size.width - StatusCellMargin * 2) - StatusPictureViewItemMargin * 2) / rowCont
        layout.itemSize = CGSize(width: itemW, height: itemW)
        
        //4张图片
        if count == 4 {
            let w = itemW * 2 + StatusPictureViewItemMargin + 2
            return CGSize(width: Int(w), height: Int(w))
        }
        
        //其他张数
        let w = UIScreen.main.bounds.size.width - StatusCellMargin * 2
        let row = CGFloat((count - 1) / Int(rowCont) + 1)
        let h = row * itemW + (row - 1) * StatusPictureViewItemMargin
        
        return CGSize(width: w, height: h)
    }
}


// MARK: - 配图 cell
private class StatusPictureViewCell : UICollectionViewCell {
    
    var imgurl:URL?{
        didSet{
            /* SDWebImageOptions.refreshCached 第一次发起网络请求时，把缓存图片的一个 hash值发送给服务器，服务器对比 hash值，如果和服务器内容一致，服务器返回的状态码是304，表示服务器内容么有变化，如果不是304，则会再次发起网络请求，获得更新后的内容。
             */
            imgView.sd_setImage(with: imgurl, placeholderImage: nil, //在调用 oc框架时，可/必选项不严格
                options: [SDWebImageOptions.retryFailed , //SD超时时长15s,一旦超时会记入黑名单，下次不再下载，而retryFailed则是让下载失败的图片不计入黑名单,失败后会再次请求下载
                 SDWebImageOptions.refreshCached],//如果 URL 不变，图片变了，则能及时请求新图片，而不用缓存旧图片
                                completed: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(imgView)
        //需要设置自动布局- 提示：因为 cell会变化，另外，不同的 cell大小可能不一样
        imgView.snp.makeConstraints { (make) in
//            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0)) 以下二者效果一样
            make.edges.equalTo(contentView.snp.edges)
        }
    }
    // MARK: - 懒加载控件
    private lazy var imgView : UIImageView = {
        let imgView = UIImageView()
        //设置填充模式
        imgView.contentMode = .scaleAspectFill
        //裁切图片
        imgView.clipsToBounds = true
        return imgView
    }()
}
























