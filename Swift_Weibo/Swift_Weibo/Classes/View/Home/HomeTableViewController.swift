//
//  HomeTableViewController.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/20.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 微博 cell可重用标识符
private let StatusCellNormalId = "StatusCellNormalId"

class HomeTableViewController: VisitorTableViewController {
    
    /// 微博数据列表模型
    private lazy var listViewModel = StatusListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserAccountViewModel.sharedUserAccount.userLogon {
            visitorView?.setupInfo(imageName: nil, title: "关注一些人，回这里看看有什么惊喜")
            return
        }
        prepareTableView()
        loadData()
    }
    
    func prepareTableView()  {
        
        tableView.register(StatusCell.self, forCellReuseIdentifier: "\(StatusCell.self)")
        
        //预估行高
        tableView.estimatedRowHeight = 200
        //自动计算行高 - 需要一个自上而下的自动布局的控件，指定一个向下的约束
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func loadData()  {
        
        listViewModel.loadStatus { (isSuccessed) in
            
            print(Thread.current)
            if !isSuccessed {
               SVProgressHUD.showInfo(withStatus: "加载数据错误，稍后再试")
                return
            }
            self.tableView.reloadData()
        }
    }
       
}

// MARK: - 数据源方法
extension HomeTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listViewModel.statusList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(StatusCell.self)", for: indexPath) as! StatusCell
//        cell.textLabel?.text = listViewModel.statusList[indexPath.row].status.user?.screen_name
        cell.viewModel = listViewModel.statusList[indexPath.row]
        return cell
    }
}

































