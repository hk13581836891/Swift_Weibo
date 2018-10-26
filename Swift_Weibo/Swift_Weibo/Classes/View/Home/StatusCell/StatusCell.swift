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
            
            pictureView.viewModel = viewModel
            pictureView.snp.updateConstraints { (make) in
                make.height.equalTo(pictureView.bounds.height)
                make.width.equalTo(pictureView.bounds.width)
                
                //如果没有配图，顶部间距设为0
//                make.top.equalTo(contentLab.snp.bottom).offset((viewModel?.thumbnailUrls?.count ?? 0 > 0 ) ? StatusCellMargin : 0)
            }
        }
    }
    
    /// 根据指定的视图模型计算行高
    ///
    /// - Parameter vm: 视图模型
    /// - Returns: 返回视图模型对应的行高
    func rowHeigth(vm:StatusViewModel) -> CGFloat {
        //1、记录视图模型 ->会调用上面的 didSet设置内容以及更新‘约束’
        viewModel = vm;
        //2、强制更新所有约束 -> 所有空间的 frame 都会被计算正确
        contentView.layoutIfNeeded()
        //3、返回底部视图的最大高度
        return bottomView.frame.maxY
    }
    //MARK: - 构造函数
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 懒加载控件
    /// 顶部视图
    private lazy var topView:StatusCellTopView = StatusCellTopView()
    /// 微博正文标签
    lazy var contentLab:UILabel = UILabel(title: "微博正文", fontSize: 15, screenInset:StatusCellMargin)
    /// 配图视图
    lazy var pictureView:StatusPictureView = StatusPictureView()
    /// 底部视图
    lazy var bottomView:StatusCellBottomView = StatusCellBottomView()
    
    func setupUI()  {
        //添加控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLab)
        contentView.addSubview(pictureView)
        contentView.addSubview(bottomView)
        
        //添加约束
        //顶部视图
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(StatusCellMargin * 2 + StatusCellIconWidth)
        }
        //内容标签
        contentLab.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView).offset(StatusCellMargin)
        }
        //配图视图
//        pictureView.snp.makeConstraints { (make) in
//            make.top.equalTo(contentLab.snp.bottom).offset(StatusCellMargin)
//            make.left.equalTo(contentLab)
//            make.width.equalTo(200)
//            make.height.equalTo(80)
//        }
        //底部视图
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(pictureView.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(44)
            
            //指定向下的约束
            //            make.bottom.equalTo(contentView)
        }
    }
}


































