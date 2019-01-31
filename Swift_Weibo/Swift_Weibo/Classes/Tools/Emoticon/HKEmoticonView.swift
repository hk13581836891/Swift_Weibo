//
//  HKEmoticonView.swift
//  HKEmojiKeyboard
//
//  Created by houke on 2018/11/14.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

//MARK: - 表情键盘视图
class HKEmoticonView: UIView {
    
    //选中表情回调
    private var selectedEmoticonCallBack:(_: HKEmoticon) -> ()
    
    
    //MARK: - 监听方法
    @objc private func toobarItemClick(item:UIBarButtonItem) {
        collectionView.scrollToItem(at: IndexPath.init(row: 0, section: item.tag), at: UICollectionView.ScrollPosition.left, animated: true)
    }
    
    //MARK: - 构造函数
    init(selectedEmoticon:@escaping (_: HKEmoticon) -> ()){
        //记录闭包属性
        selectedEmoticonCallBack = selectedEmoticon
        
        //调用父类的构造方法
        var rect = UIScreen.main.bounds
        rect.size.height = 226
        super.init(frame: rect)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 懒加载控件
    lazy var collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmojiLayout())
    lazy var toolbar = UIToolbar()
    //表情包数组
    private lazy var packages = HKEmoticonManager.sharedManager.packages
    //MARK: - 表情布局（类中类- 只允许被包含的类使用）
    class EmojiLayout : UICollectionViewFlowLayout{
        
        //collectionview第一次布局的时候被自动调用
        //collectionview 的尺寸已经设置好 216 toolbar 36,如果 iPhone6+，屏幕宽度是414，如果 toolbar 设为默认高度44，则只能显示两行，所以toolbar 高度设为36
        override func prepare() {
            super.prepare()
            let col:CGFloat = 7
            let row:CGFloat = 3
            
            let w = (collectionView?.bounds.width ?? UIScreen.main.bounds.width ) / col
            let margin = ((collectionView?.bounds.height ?? 180) - row * w ) * 0.499
            
            itemSize = CGSize(width: w, height: w)
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            sectionInset = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
            scrollDirection = .horizontal
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
}

// MARK: - 设置界面
//private 修饰的 extension 内部所有的函数都是私有的
private extension HKEmoticonView {
    
    func setupUI() {
        addSubview(toolbar)
        addSubview(collectionView)
        
        toolbar.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(44)
        }
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom:36, right: 0))
        }
        
        prepareToolbar()
        prepareCollectionView()
    }
    
    //准备工具栏
    func prepareToolbar() {
        
        toolbar.tintColor = UIColor.lightGray
        //设置按钮内容
        var items = [UIBarButtonItem]()
        
        //toolbar 中，通常是一组宏能相近的操作，只是操作的类型不同，通常利用tag区分
        var index = 0
        for p in packages {
            items.append(UIBarButtonItem(title: p.group_name_cn, style: UIBarButtonItem.Style.plain, target: nil, action:#selector(toobarItemClick(item:))))
            items.last?.tag = index
            index = index + 1
            //添加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        
        toolbar.items = items
    }
    
    //准备 collectionview
    func prepareCollectionView()  {
        collectionView.backgroundColor = UIColor.white
        
        //注册 cell
        collectionView.register(EmojiViewCell.self, forCellWithReuseIdentifier: "\(EmojiViewCell.self)")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //主线程中的任务在第一次运行循环结束后，下一个运行循环开始即执行以下代码
        DispatchQueue.main.async {
            //直接显示默认页
            self.collectionView.scrollToItem(at: IndexPath.init(row: 0, section: 1), at: UICollectionView.ScrollPosition.left, animated: false)
        }
    }
   
}

// MARK: - UICollectionViewDataSource
extension HKEmoticonView:UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //获取表情模型
        let em = packages[indexPath.section].emoticons[indexPath.item]
        //执行’回调‘
        selectedEmoticonCallBack(em)
        
        //添加最近表情
        //第0个分组不参加排序
        if indexPath.section > 0 {
            HKEmoticonManager.sharedManager.addFavorite(em: em)
        }
    }
    
    //返回分组数量 - 表情包的数量
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packages.count
    }
    //返回每个表情包中表情的数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(EmojiViewCell.self)"
            , for: indexPath) as! EmojiViewCell
//        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.red : UIColor.green
        cell.emoticon = packages[indexPath.section].emoticons[indexPath.item]
        return cell
    }
}

//MARK: - 表情视图 cell
private class EmojiViewCell : UICollectionViewCell {
    
    //表情模型
    var emoticon : HKEmoticon?{
        didSet{
            emojiBtn.setImage(UIImage(contentsOfFile: emoticon!.imagePath), for: UIControl.State.normal)
            emojiBtn.setTitle(emoticon?.emoji, for: UIControl.State.normal)
            
            //设置删除按钮
            if (emoticon?.isRemoved)! {
                emojiBtn.setImage(UIImage(contentsOfFile: Bundle.main.bundlePath + "/HKEmoticons.bundle/" + "compose_emotion_delete@2x.png"), for: UIControl.State.normal)
            }
        }
    }

    //MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(emojiBtn)
        
        emojiBtn.backgroundColor = UIColor.white
        emojiBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        emojiBtn.frame = bounds.insetBy(dx: 4, dy: 4)
        //设置 emoji的字体大小跟高度一致
        emojiBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        emojiBtn.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - 懒加载控件
    lazy var emojiBtn = UIButton()
}




























