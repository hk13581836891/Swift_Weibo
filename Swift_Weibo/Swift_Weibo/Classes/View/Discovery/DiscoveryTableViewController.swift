//
//  DiscoveryTableViewController.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/20.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

class DiscoveryTableViewController: VisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView?.setupInfo(imageName: "visitordiscover_image_message", title: "登录后，最新、最热微博尽在掌握，不再会与事实潮流擦肩而过")
        
    }

}
