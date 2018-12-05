//
//  HKPhotoBrowerCell.swift
//  Swift_Weibo
//
//  Created by houke on 2018/12/5.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
import SDWebImage

/// 照片查看 cell
class HKPhotoBrowerCell: UICollectionViewCell {
    
    var imageUrl:URL?{
        didSet{
            guard let url = imageUrl else {
                return
            }
            //1、从磁盘获取缩略图图片，在不需要网络加载的前提下显示缩略图
            showImage(url: url, img: nil)
           
            //2 异步加载中图
            DispatchQueue.global().async {
                SDWebImageDownloader.shared().downloadImage(with: self.bmiddleURL(url: url)
                    , options: SDWebImageDownloaderOptions.highPriority, progress: nil, completed: { (image, _, _, _) in
                        print("\(Thread.current)")
                        guard image != nil else {
                           return
                        }
                        self.showImage(url: nil, img: image)
                })
            }
        }
    }
    
    /// 显示图片
    ///
    /// - Parameters:
    ///   - url: 缩略图url
    ///   - img: 中图 image
    func showImage(url:URL?, img:UIImage?)  {
        var image : UIImage?
        if url != nil {
            image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: url!.absoluteString)
        }else{
            image = img
        }
        imageView.image = image
        let size = displaySize(image: image!)
        imageView.frame = CGRect(origin: CGPoint.zero, size: size)//设置大小，否则图片显示不了
        if size.height < UIScreen.main.bounds.height {
            imageView.center = scrollView.center
        }
    }
    /// 根据 scrollView的宽度计算等比例缩放之后的图片尺寸
    ///
    /// - Parameter image: image
    /// - Returns: 缩放后的 size
    func displaySize(image:UIImage) -> CGSize {
        let w:CGFloat = scrollView.bounds.width
        let h:CGFloat = w * image.size.height / image.size.width
        if h > UIScreen.main.bounds.height {
            scrollView.contentSize = CGSize(width: w, height: h)
        }
        return CGSize(width: w, height: h)
    }
    
    /// 返回中等尺寸图片
    ///
    /// - Parameter url: 缩略图 url
    /// - Returns: 中等尺寸 URL
    func bmiddleURL(url:URL) -> URL {
        let urlStr = url.absoluteString
        //把图片地址中的缩略图路径 改成中图
        let url = urlStr.replacingOccurrences(of: "/thumbnail/", with: "/bmiddle/")
        return URL(string: url)!
        
    }
    //MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - 懒加载控件
    private lazy var scrollView:UIScrollView = UIScrollView()
    private lazy var imageView:UIImageView = UIImageView()
    
    private func setupUI(){
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.frame = bounds
    }
}
