//
//  HKPicturePickerController.swift
//  PhotoSelector
//
//  Created by houke on 2018/11/22.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

/// 最大选择照片数量
private let PicturePickerMaxCount = 8

class HKPicturePickerController: UICollectionViewController {

    //配图数组
    lazy var pictures = [UIImage]()
    //当前选中的照片索引
    var selectedIndex = 0
    
    //MARK: - 构造函数
    init(){
        super.init(collectionViewLayout: PicturePickerLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //在 collectionviewController中 coleectionview ！= view
    //与 tableviewController中 view == tableview 情况不一样
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.backgroundColor = UIColor(white: 0.9, alpha: 1)
        print("test---------")

        // Register cell classes
        self.collectionView!.register(HKPicturePickerCell.self, forCellWithReuseIdentifier: "\(HKPicturePickerCell.self)")

    }
    
    //MARK: - 照片选择器布局
    private class PicturePickerLayout: UICollectionViewFlowLayout {
        
        override func prepare() {
            super.prepare()
            //ios9.0之后，尤其是 ipad 支持分屏，不建议过分依赖 UIScreen 作为布局参照
            //UIScreen.main.scale:屏幕分辨率
            //iphone6s- 2 ；iPhone6s+ 3
            let count:CGFloat = 4
            let margin:CGFloat = UIScreen.main.scale * 4
            let w = ((collectionView?.bounds.width)! - (count + 1) * margin) / count
            
            
            itemSize = CGSize(width: w, height: w)
            minimumLineSpacing = margin
            minimumInteritemSpacing = margin
            sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: 0, right: margin)
        }
        
    }
}

// MARK: - 数据源方法
extension HKPicturePickerController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        //如果达到上限就不显示➕按钮
        return  pictures.count + (pictures.count == PicturePickerMaxCount ? 0 : 1)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(HKPicturePickerCell.self)", for: indexPath) as! HKPicturePickerCell
        cell.pictureDelegate = self
        cell.image = indexPath.item == pictures.count ? nil : pictures[indexPath.item]
        
        return cell
    }
}

// MARK: - PicturePickerCellDelegate
extension HKPicturePickerController : PicturePickerCellDelegate{
    
    func picturePickerCellAddPicture(cell: HKPicturePickerCell) {
        //判断是否允许访问相册
        /**
         photoLibrary: app保存的照片（可以删除） + 同步的照片(不允许删除）
         savedPhotosAlbum: app保存的照片/屏幕截图/拍照
         */
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            print("无法访问照片库")
            return
        }
        //记录当前用户选中的照片索引
        selectedIndex = collectionView?.indexPath(for: cell)?.item ?? 0
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true//允许编辑图片，适合用于头像选择
        present(picker, animated: true, completion: nil)
        
    }
    func picturePickerCellRemovePicture(cell: HKPicturePickerCell) {
        //获取照片索引
        let index = collectionView?.indexPath(for: cell)!
        //刷新视图
        pictures.remove(at: (index?.item)!)
        collectionView?.reloadData()
//        collectionView?.deleteItems(at: [index!])//动画刷新视图
    }
}

// MARK: - UIImagePickerControllerDelegate , UINavigationControllerDelegate
extension HKPicturePickerController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    /// 照片选择完成
    ///
    /// - Parameters:
    ///   - picker: 照片选择控制器
    ///   - info: info字典
    // - 提示：一旦实现代理方法，x必须自己 dismiss
    /**
     如果使用 cocos2dx 开发一个'空白的模板游戏',内存占用70M, iosUI的空白应用程序，大概19M
     一般应用程序，内存在100M 左右可以接受，再高需要注意！
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        //缩小图片 -- ✨控制内存
        let scaleImage = image.scaleToWidth(width: 600)
        
        //将图像添加到数组
        //判断当前选中的索引是否超出数组上限
        if selectedIndex >= pictures.count {
            pictures.append(scaleImage)
        }else{
            pictures[selectedIndex] = scaleImage
        }
        
        collectionView?.reloadData()
        //释放控制器
        dismiss(animated: true, completion: nil)
    }
}
/// 如果协议中包含optional函数，协议需要使用 @objc修饰
@objc protocol PicturePickerCellDelegate:NSObjectProtocol {
    @objc optional func picturePickerCellAddPicture(cell : HKPicturePickerCell)
    @objc optional func picturePickerCellRemovePicture(cell : HKPicturePickerCell)
}
/// 照片选择 cell
class HKPicturePickerCell: UICollectionViewCell {
    
    weak var pictureDelegate:PicturePickerCellDelegate?
    
    var image:UIImage? {
        didSet{
            addBtn.setImage(image ?? UIImage(named: "compose_pic_add"), for: UIControlState.normal)
            removeBtn.isHidden = (image == nil)
        }
    }
    
    
    //MARK: - 监听方法
    @objc func addPicture()  {
        pictureDelegate?.picturePickerCellAddPicture?(cell: self)
    }
    @objc func removePicture()  {
        pictureDelegate?.picturePickerCellRemovePicture?(cell: self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI() {
        contentView.addSubview(addBtn)
        contentView.addSubview(removeBtn)
        removeBtn.isHidden = true
        addBtn.frame = bounds
        removeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.right.equalTo(contentView)
        }
        
        //监听方法
        addBtn.addTarget(self, action: #selector(addPicture), for: UIControlEvents.touchUpInside)
        removeBtn.addTarget(self, action: #selector(removePicture), for: UIControlEvents.touchUpInside)
        
        //设置填充模式
        addBtn.imageView?.contentMode = .scaleAspectFill
    }
    //MARK: - 懒加载控件
    private lazy var addBtn:UIButton = UIButton(imageName: "compose_pic_add", backImageName: "")
    lazy var removeBtn = UIButton(imageName: "compose_photo_close", backImageName: "")
}























