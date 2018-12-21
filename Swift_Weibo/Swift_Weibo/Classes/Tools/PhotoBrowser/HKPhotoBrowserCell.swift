//
//  HKPhotoBrowerCell.swift
//  Swift_Weibo
//
//  Created by houke on 2018/12/5.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

protocol HKPhotoBrowserCellDelegate:NSObjectProtocol {
    func photoBrowserCellDidTapImage()
}
/// 照片查看 cell
class HKPhotoBrowserCell: UICollectionViewCell {
    
    weak var photoDelegate:HKPhotoBrowserCellDelegate?
    
    //MARK: - 监听方法
    @objc private func tapImage() {
        photoDelegate?.photoBrowserCellDidTapImage()
    }
    //手势识别是对 touch的一个封装，UIScrollView支持捏合手势，一般做过手势监听的控件，都会屏蔽掉 touch事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch")
    }
    
    //MARK: - 图像地址
    var imageUrl:URL?{
        didSet{
            guard let url = imageUrl else {
                return
            }
            //0 重设 scrollview 的内容属性
            resetScroll()
            
            let placeholderImage = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: url.absoluteString)
            //1、从磁盘获取缩略图图片，在不需要网络加载的前提下显示缩略图
            imageViewShowImage(image: placeholderImage)
            placeholder.isHidden = false
            placeholder.progress = 0;
          
            //2 异步下载中图 -
            /*
             如果使用 sd_setImageWithURL异步加载方法，则一旦设置了 url,就会清除之前的图片，如果之前的图片也是异步加载，但是没有完成，则取消之前的异步操作.因为在 tableview中快速滑动时，数据频换替换这样可以直接取消部分没有加载完成的图片资源
             */
            //如果 url对应的图像已经被缓存，直接从磁盘读取，不会再走网络加载
            //几乎所有的第三方框架，进度回调都是异步的:
            //原因- 不是所有的程序都需要进度回调;进度回调的频率非常高，如果在主线程，会造成主线程卡顿
            //使用进度回调，要求界面上跟进进度变化的 UI 不多，而且不会频繁更新
            imageView.sd_setImage(with: self.bmiddleURL(url: url),
            placeholderImage: placeholderImage,
            options: [SDWebImageOptions.retryFailed, SDWebImageOptions.refreshCached],
            progress: { (current, total, _) in//progress在非主线程
                //更新进度
                DispatchQueue.main.async {
                    self.placeholder.progress = CGFloat(current) / CGFloat(total)
                }
            }) { (image, _, _, _) in//完成后回到主线程
                guard image != nil else {
                    SVProgressHUD.showInfo(withStatus: "网络不给力")
                    return
                }
                self.placeholder.isHidden = true
                self.imageViewShowImage(image: image)
            }
        }
    }
    
    /// 重设内容属性
    private func resetScroll()  {
        /// 重设imageView的内容属性- scrollView在处理缩放的时候，是调整代理方法返回视图的 transform来实现的 
        imageView.transform = CGAffineTransform.identity
        /// 重设 scrollview的内容属性
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentSize = CGSize.zero
        scrollView.contentOffset = CGPoint.zero
    }
    /// 显示图片
    ///
    /// - Parameters:
    ///   - url: 缩略图url
    ///   - img: 中图 image
//    func placeholderShowImage(image:UIImage?)  {
//        placeholder.image = image
//        let size = displaySize(image: image!)
//        //设置大小，否则图片显示不了
//        if size.height < scrollView.bounds.height {
//            //如果设置 frame的 y值，一旦缩放，会影响滚动范围
//            placeholder.frame = CGRect(origin: CGPoint(x: 0, y: 0), size:size)
//            let y = (scrollView.bounds.height - size.height) * 0.5
//            //内容边距 - 会调整控件位置，但是不会影响控件的滚动
//            scrollView.contentInset = UIEdgeInsets(top:y, left: 0, bottom: 0, right: 0)
//        }else{
//            placeholder.frame = CGRect(origin: CGPoint(x: 0, y: 0), size:size)
//            scrollView.contentInset = UIEdgeInsets(top:-20, left: 0, bottom: 0, right: 0)
//            scrollView.contentSize = size
//        }
//    }
    func imageViewShowImage(image:UIImage?)  {
        imageView.image = image
        let size = displaySize(image: image!)
        //设置大小，否则图片显示不了
        if size.height < scrollView.bounds.height {
            //如果设置 frame的 y值，一旦缩放，会影响滚动范围
            imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size:size)
            placeholder.frame = CGRect(origin: CGPoint(x: 0, y: 0), size:size)
            let y = (scrollView.bounds.height - size.height) * 0.5
            //内容边距 - 会调整控件位置，但是不会影响控件的滚动
            scrollView.contentInset = UIEdgeInsets(top:y, left: 0, bottom: 0, right: 0)
        }else{
            imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size:size)
            placeholder.frame = CGRect(origin: CGPoint(x: 0, y: 0), size:size)
            scrollView.contentInset = UIEdgeInsets(top:-20, left: 0, bottom: 0, right: 0)
            scrollView.contentSize = size
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
    
    private func setupUI(){
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(placeholder)
        
        var rect = bounds
        rect.size.width -= 20
        scrollView.frame = rect
        
        //设置 scrollView缩放
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        
        //添加手势识别
        let tapImageView = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapImageView)
    }
    //MARK: - 懒加载控件
    lazy var scrollView:UIScrollView = UIScrollView()
    lazy var imageView:UIImageView = UIImageView()
    //占位图像
    private lazy var placeholder:HKPhotoBrowserProgressView = HKPhotoBrowserProgressView.init(frame:CGRect.zero);
//    private lazy var placeHolder:HKPhotoBrowserProgressView = HKPhotoBrowserProgressView.init(frame:CGRect(origin: CGPoint.zero, size: CGSize(width: 80, height: 80)))
}

// MARK: - UIScrollViewDelegate
extension HKPhotoBrowserCell : UIScrollViewDelegate {
    //返回被缩放的视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    /// 缩放完成后执行一次
    ///
    /// - Parameters:
    ///   - scrollView: scrollView
    ///   - view: view 被缩放的视图
    ///   - scale: scale 被缩放的比例
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        //缩放过程中 bounds不会改变
        print("缩放完成 \(view) \(view?.bounds) \(view?.frame)")
        var offsetY = (scrollView.bounds.height - (view?.frame.size.height)!) * 0.5
        offsetY = offsetY < 0 ? -20 : offsetY;
        //在最小缩放比例minimumZoomScale为1的情况下，offsetX可以不做设置
        var offsetX = (scrollView.bounds.width - (view?.frame.size.width)!) * 0.5
        offsetX = offsetX < 0 ? 0 : offsetX;
        
        scrollView.contentInset = UIEdgeInsets(top:offsetY , left: offsetX, bottom: 0, right: 0)
        
        /*图片放大超过屏幕宽高或者说超过scrollView.bounds的宽高后，scrollView的 contenSize则发生变化
          再结合 collectionCell复用机制，如果不把scrollView的 contenSize复位，滑动到后面的图片时，图片整体的显示效果则会出问题
         */
    }
    //只要缩放就会调用
    /**
     CGAffineTransform(a: 0.5, b: 0.0, c: 0.0, d: 0.5, tx: 0.0, ty: 0.0) 散列矩阵
     
     a d => 缩放比例
     a b c d => 共同决定旋转
     tx ty => 设置位移
     定义控件位置 frame = center + bounds * transform
     */
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
         print(imageView.transform)
    }
}
