//
//  TableViewController.swift
//  Swift_Demo1
//
//  Created by houke on 2018/8/13.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var persons: [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("22")
        loadData { array in
            print("------------")
            self.persons = array
            self.tableView.reloadData()
        }
    }
    //从一个 vc跳转到另一个 vc调用的方法
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //1、拿到目标控制器
        guard let detailvc = segue.destination as? DetailViewController else {
            return
        }
        //2、获取用户当前选中行数据
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        //3、根据 indexPath获取 person数据
        print(persons![indexPath.row])
        
        //4、传递数据
        detailvc.person = persons![indexPath.row]
//        detailvc.savedCallBack = {
//            //刷新表格
//            self.tableView.reloadData()
//        }
        //简写 - 传递了一个‘可以执行的’函数
        detailvc.savedCallBack = self.tableView.reloadData
    }
}
//MARK: - 数据源方法
extension TableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PersonCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PersonCell
        cell.person = persons![indexPath.row]
        //persons 可以强行解包 原因：只有 persons有数据，才会调用这个数据源方法
//        cell.textLabel?.text = persons![indexPath.row].name
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
}

//MARK: - 数据处理
//extension类似于 OC 中的分类，可以将控制器的代码分组，便于维护和管理
extension TableViewController{
    
    //加载数据 字典数组->模型数组
    func loadData(completed:@escaping ([Person]) ->())  {
        DispatchQueue.global().async {
            print("模拟耗时操作")
            //拼接个人信息
            //1、创建数组
            var dataList = [Person]()
            //2、循环生成模拟数据
            for i in 0..<30 {
                let name = "姓名 \(i)"
                let age =  arc4random() % 20
                let dict:[String : Any] = ["name": name, "age":age]
                //字典转模型，追加到数组
                dataList.append(Person(dict: dict))
            }
            //3、测试数据
            print(dataList)
            DispatchQueue.main.async {
                print("完成回调")
                completed(dataList)
            }
        }
    }
}
































