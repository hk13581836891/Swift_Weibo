
//
//  DetailViewController.swift
//  Swift_Demo1
//
//  Created by houke on 2018/8/15.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

@objcMembers class DetailViewController: UIViewController {
    
    var savedCallBack:(()->())?
    
    var person:Person?
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var ageText: UITextField!
    
    //文本变化
    @IBAction func textChanged() {
        //两个输入框都有值，才能保存
        navigationItem.rightBarButtonItem?.isEnabled = nameText.hasText && ageText.hasText
    }
    
    
    @IBAction func save(_ sender: Any) {
        //1、使用 UI 更新模型
        person?.name = nameText.text
        person?.age = Int(ageText.text!) ?? 0//第一个！保证字符串一定有内容；第二个！保证一定能转换成整数
        print(person)
        //2、完成回调，通知控制器刷新数据 - 闭包!
        //？表示闭包不存在就不执行
        //如果用！强行解包,如果没有设置数据，会崩溃
        savedCallBack?()
        
        //关闭控制器
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameText.text = person?.name
        ageText.text = "\(person?.age ?? 0)"
        //激活按钮
        textChanged()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
