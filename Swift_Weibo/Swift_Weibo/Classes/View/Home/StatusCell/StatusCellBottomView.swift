//
//  StatusCellBottomView.swift
//  Swift_Weibo
//
//  Created by houke on 2018/9/6.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

/// 底部视图
class StatusCellBottomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 懒加载控件
    /// 转发
    var retweetedBtn:UIButton = UIButton(title: " 转发", fontSize: 12, imageName: "timeline_icon_retweet")
    /// 评论
    var commentBtn:UIButton = UIButton(title: " 评论", fontSize: 12, imageName: "timeline_icon_comment")
    /// 点赞
    var likeBtn:UIButton = UIButton(title: " 赞", fontSize: 12, imageName: "timeline_icon_unlike")
    
}

// MARK: - 设置界面
extension StatusCellBottomView {
    
    func setupUI()  {
        //添加控件
        addSubview(retweetedBtn)
        addSubview(commentBtn)
        addSubview(likeBtn)
        backgroundColor = UIColor(white: 0.92, alpha: 1)
        //自动布局
        retweetedBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.bottom.equalTo(self)
        }
        commentBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(retweetedBtn.snp.right)
            make.width.equalTo(retweetedBtn)
            make.bottom.equalTo(self)
        }
        likeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(commentBtn.snp.right)
            make.width.equalTo(retweetedBtn)
            make.bottom.equalTo(self)
            
            make.right.equalTo(self)
        }
        
        //3、分割视图
        let sep1 = sepView()
        let sep2 = sepView()
        addSubview(sep1)
        addSubview(sep2)
        
        //布局
        let w = 0.5
        let scale = 0.4
        
        sep1.snp.makeConstraints { (make) in
            make.left.equalTo(retweetedBtn.snp.right)
            make.centerY.equalTo(retweetedBtn)
            make.width.equalTo(w)
            make.height.equalTo(self).multipliedBy(scale)
        }
        sep2.snp.makeConstraints { (make) in
            make.left.equalTo(commentBtn.snp.right)
            make.centerY.equalTo(commentBtn)
            make.width.equalTo(w)
            make.height.equalTo(self).multipliedBy(scale)
        }
    }
    
    
    /// 创建分割视图
    //此处如果使用计算型属性 - 会让代码阅读困难
    private func sepView() -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor.darkGray
        return v
    }
}

























