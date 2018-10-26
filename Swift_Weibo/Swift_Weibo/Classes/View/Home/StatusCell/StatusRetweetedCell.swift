//
//  StatusRetweetedCell.swift
//  Swift_Weibo
//
//  Created by houke on 2018/10/10.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

/// 转发微博的 cell
class StatusRetweetedCell: StatusCell {

    /// 微博视图模型
    //如果继承父类的属性 需要 override, 不需要 super ,先执行父类的 didSet,再执行子类的didSet
    override var viewModel:StatusViewModel? {
        didSet{
            //转发微博的文字
            retweetedLabel.text = viewModel?.retweetedText
            
            pictureView.snp.updateConstraints { (make) in
                //如果没有配图，顶部间距设为0
                make.top.equalTo(retweetedLabel.snp.bottom).offset((viewModel?.thumbnailUrls?.count ?? 0 > 0 ) ? StatusCellMargin : 0)
            }
        }
    }
    
    //MARK: - 懒加载控件
    /// 背景按钮
    private lazy var backButton : UIButton = {
         let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return btn
    }()
    
    /// 转发标签
    private lazy var retweetedLabel:UILabel = UILabel(title: "转发微博转发微博转发微博转发微博转发微博转发微博转发微博转发微博转发微博转发微博转发微博转发微博", color: UIColor.darkGray, fontSize: 14, screenInset: StatusCellMargin)
    
    // MARK: - 设置界面
    @objc override func setupUI() {
        super.setupUI()
        //添加控件
        contentView.insertSubview(backButton, belowSubview: pictureView)
        contentView.insertSubview(retweetedLabel, aboveSubview: backButton)
        //自动布局
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentLab.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(bottomView.snp.top)
        }
        retweetedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backButton.snp.top).offset(StatusCellMargin)
            make.left.equalTo(backButton.snp.left).offset(StatusCellMargin)
        }
        //配图视图
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(retweetedLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(retweetedLabel.snp.left)
            make.width.equalTo(200)
            make.height.equalTo(80)
        }
        
    }
   
}

extension StatusRetweetedCell {
    
}























