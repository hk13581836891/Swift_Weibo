//
//  ProfileTableViewController.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/20.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

class ProfileTableViewController: VisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView?.setupInfo(imageName: "visitordiscover_image_profile", title: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
    }

}
