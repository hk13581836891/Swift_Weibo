//
//  HKPhotoBrowserViewController.swift
//  Swift_Weibo
//
//  Created by houke on 2018/12/5.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
import SVProgressHUD

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
        //1 拿到图片
        let cell = collectionView.visibleCells[0] as! HKPhotoBrowserCell
        //imageView中很可能会因为网络问题没有图片 -> 下载需要提示
        guard let image = cell.imageView.image else {
            return
        }
        //2 保存图片
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    // 3 实现相应的函数
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        let message = error == nil ? "保存成功" : "保存失败"
        SVProgressHUD.showInfo(withStatus: message)
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
    //和 xib&sb 是等价的，主要职责创建视图层次结构，loadView 函数执行完毕，view上的元素要全部创建完成
    //如果 view == nil ，系统会在调用 view的 getter方法时，自动调用 loadview，创建 view
    override func loadView() {
        var rect = UIScreen.main.bounds
        rect.size.width += 20
        view = UIView(frame: rect)
        view.backgroundColor = UIColor.white
        
        setupUI()
    }
    //是视图加载完成被调用，loadView执行完毕后执行
    //主要做数据加载或其他处理
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.urls)
        print(self.currentIndexPath)
        //让 collectionView滚动到指定位置
        collectionView.scrollToItem(at: currentIndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
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
            make.right.equalTo(view).offset(-StatusCellMargin - 20)
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
        cell.photoDelegate = self//设置代理
        return cell
    }
}

// MARK: - HKPhotoBrowserCellDelegate
extension HKPhotoBrowserViewController:HKPhotoBrowserCellDelegate{
    func photoBrowserCellDidTapImage() {
        //关闭控制器
        close()
    }
}

// MARK: - HKPhotoBrowserDismissDelegate
extension HKPhotoBrowserViewController:HKPhotoBrowserDismissDelegate{
    func imageViewForDismiss() -> UIImageView {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        //从当前显示的 cell中获取图像
        let cell = collectionView.visibleCells[0] as! HKPhotoBrowserCell
        iv.image = cell.imageView.image
        
        //设置转换 - 坐标转换（由父视图进行）
        iv.frame = cell.scrollView.convert(cell.imageView.frame, to: UIApplication.shared.keyWindow)
        return iv
    }
    
    func indexPathForDismiss() -> IndexPath {
        return collectionView.indexPathsForVisibleItems[0]
    }
    
    
}















