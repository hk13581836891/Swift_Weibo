//
//  StatusNormalCell.swift
//  Swift_Weibo
//
//  Created by houke on 2018/11/1.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

/// 原创微博
class StatusNormalCell: StatusCell {
    
    /// 微博视图模型
    override var viewModel:StatusViewModel? {
        didSet{
            
            pictureView.snp.updateConstraints { (make) in
                //如果没有配图，顶部间距设为0
            make.top.equalTo(contentLab.snp.bottom).offset((viewModel?.thumbnailUrls?.count ?? 0 > 0 ) ? StatusCellMargin : 0)
            }
        }
    }
    override func setupUI() {
        super.setupUI()
        //配图视图
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLab.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentLab)
            make.width.equalTo(200)
            make.height.equalTo(80)
        }
    }
}
