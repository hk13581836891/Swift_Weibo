//
//  StatusCellTopView.swift
//  Swift_Weibo
//
//  Created by houke on 2018/9/6.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

/// 顶部视图
class StatusCellTopView: UIView {

    //MARK: 微博视图模型
    var viewModel:StatusViewModel? {
        didSet{
            nameLab.text = viewModel?.status.user?.screen_name
            iconView.setImageWith((viewModel?.userIconUrl)!, placeholderImage: viewModel?.userDefaultImage)
            memberImg.image = viewModel?.userMemberImage
            vipImg.image = viewModel?.userVipImage
            timeLab.text = viewModel?.creatAt
            sourceLab.text = viewModel?.status.source//来源
        }
    }
    
    //MARK: 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 懒加载控件
    /// 头像
    private lazy var iconView:UIImageView = UIImageView(imageName: "avatar_default_big")
    /// 姓名
    private lazy var nameLab:UILabel = UILabel(title: "姓名", fontSize: 14)
    /// 会员图标
    private lazy var memberImg:UIImageView = UIImageView(imageName: "common_icon_membership_level1")
    ///认证图标
    private lazy var vipImg:UIImageView = UIImageView(imageName: "avatar_vip")
    /// 时间标签
    private lazy var timeLab:UILabel = UILabel(title: "时间", color: UIColor.orange, fontSize: 11)
    /// 来源标签
    private lazy var sourceLab:UILabel = UILabel(title: "来源", fontSize: 11)
}

// MARK: - 设置界面
extension StatusCellTopView {
   
    func setupUI()  {
        
        //添加分割视图
        let sepView = UIView()
        sepView.backgroundColor = UIColor.lightGray
        addSubview(sepView)
        
        //添加控件
        addSubview(iconView)
        addSubview(nameLab)
        addSubview(memberImg)
        addSubview(vipImg)
        addSubview(timeLab)
        addSubview(sourceLab)
    
        //添加约束
        sepView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(StatusCellMargin)
        }
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(sepView.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(self).offset(StatusCellMargin)
            make.size.equalTo(CGSize(width: StatusCellIconWidth , height: StatusCellIconWidth))
        }
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(StatusCellMargin)
        }
        memberImg.snp.makeConstraints { (make) in
            make.top.equalTo(nameLab)
            make.left.equalTo(nameLab.snp.right).offset(StatusCellMargin)
        }
        vipImg.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconView.snp.right)
            make.centerY.equalTo(iconView.snp.bottom)
        }
        timeLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(StatusCellMargin)
        }
        sourceLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconView)
            make.left.equalTo(timeLab.snp.right).offset(StatusCellMargin)
        }
    }
}



















