//
//  MessageTableViewController.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/20.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

class MessageTableViewController: VisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView?.setupInfo(imageName: "visitordiscover_image_message", title: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
    }

}
