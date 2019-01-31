//
//  WebViewController.swift
//  Swift_Weibo
//
//  Created by houke on 2019/1/30.
//  Copyright © 2019年 houke. All rights reserved.
//

import UIKit

class DetaliViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(lab)
        lab.backgroundColor = UIColor.lightGray
        
        lab.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(50)
            make.top.equalTo(view).offset(100)
            make.height.equalTo(100)
            make.right.equalTo(view).offset(-50)
        }
    }

    private lazy var lab:ProperyLabel = {
        let label = ProperyLabel(title: "点击 http://www.baidu.com", color: UIColor.black, fontSize: 14, screenInset: 0)
        label.prepareTextSystem()
        return label
    }()
  
}
