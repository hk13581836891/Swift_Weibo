//
//  HomeTableViewController.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/20.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

class HomeTableViewController: VisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView?.setupInfo(imageName: nil, title: "关注一些人，回这里看看有什么惊喜")
    }

}

