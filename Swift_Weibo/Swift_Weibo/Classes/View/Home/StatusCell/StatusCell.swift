//
//  StatusCell.swift
//  Swift_Weibo
//
//  Created by houke on 2018/9/6.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit


///微博 cell
class StatusCell: UITableViewCell {
    
    
    /// 微博视图模型
    var viewModel:StatusViewModel? {
        didSet{
            topView.viewModel = viewModel
            
            contentLab.text = viewModel?.status.text
        }
    }
    
    //MARK: - 构造函数
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 懒加载控件
    /// 顶部视图
    private lazy var topView:StatusCellTopView = StatusCellTopView()
    /// 微博正文标签
    private lazy var contentLab:UILabel = UILabel(title: "微博正文", fontSize: 15, screenInset:StatusCellMargin)
    /// 底部视图
    private lazy var bottomView:StatusCellBottomView = StatusCellBottomView()
}

extension StatusCell {
    
    private func setupUI()  {
        //添加控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLab)
        contentView.addSubview(bottomView)
        
        //添加约束
        //顶部视图
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(StatusCellMargin + StatusCellIconWidth)
        }
        //内容标签
        contentLab.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView).offset(StatusCellMargin)
        }
        
        //底部视图
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLab.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(44)
            
            //指定向下的约束
            make.bottom.equalTo(contentView).offset( -StatusCellMargin)
        }
    }
}

































