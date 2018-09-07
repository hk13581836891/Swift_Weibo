//
//  Common.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/23.
//  Copyright © 2018年 houke. All rights reserved.
//

//目的：提供全局共享属性或者方法，类似于 pch文件
import UIKit

//MARK: - 全局通知定义
//切换根视图控制器通知 - 一定要够长，要有前缀
let WBSwitchRootViewControllerNotification = "WBSwitchRootViewControllerNotifaction"

//全局外观渲染颜色 - 延展出‘配色’管理类
let WBAppearanceTintColor = UIColor.orange

/// 微博 cell中控件的间距数值
let StatusCellMargin: CGFloat = 15

/// 微博头像宽度
let StatusCellIconWidth:CGFloat = 35

