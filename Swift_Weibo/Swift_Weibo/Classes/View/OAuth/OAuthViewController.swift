//
//  OAuthViewController.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/28.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

//用户登录控制器
class OAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    //MARK: - 监听方法
    @objc func close()   {
        dismiss(animated: true, completion: nil)
    }
    
    //自动填充用户名和密码 - web 注入（以代码的方式向 web页面添加内容）
    @objc private func autoFill()  {
        let js = "document.getElementById('userId').value = '13581836891';" + "document.getElementById('passwd').value = 'hk666666';"
        webView.stringByEvaluatingJavaScript(from: js)
    }
    
    //MARK:- 设置界面
    override func loadView() {
        view = webView
        webView.delegate = self
        
        //设置导航栏
        title = "登录新浪文博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", style: UIBarButtonItemStyle.plain, target: self, action: #selector(autoFill))
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //视图最好都指定背景色，如果为 nil,会影响渲染效率
        view.backgroundColor = UIColor.white
        
        //加载页面
        self.webView.loadRequest(URLRequest(url: NetworkTools.sharedTools.oauthULR))
    }

}

extension OAuthViewController:UIWebViewDelegate {
    
    
    /// 将要加载请求的代理方法
    ///
    /// - Parameters:
    ///   - webView:  webView
    ///   - request: 将要加载的请求，
    ///   - navigationType: 导航类型,页面跳转的方式
    /// - Returns:  返回 false不加载，返回true加载
    /// 如果在 ios 的代理方法中有返回 bool,通常返回 true正常，返回 false不能正常工作
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        //如果是百度，则不加载 主机地址:url?.host 查询字符串:url?.query
        //1、判断访问的主机是否是 www.baidu.com
        guard let url = request.url, url.host == "www.baidu.com" else {
            return true
        }
        //2、从百度地址的 url中提取 code= 是否存在
        guard let query = url.query , query.hasPrefix("code=") else {
             print("取消授权")
            return true
        }
        //3、从query 字符串中提取‘code=’后面的授权码
        let code = query.mySubString(from: 5)
        print(code)
        
        //4、加载 accessToken
        UserAccountViewModel.sharedUserAccount.loadAccessToken(code: code) { (isSuccessed) in
            if isSuccessed {
                print("成功了")
                print(UserAccountViewModel.sharedUserAccount.account as Any)
            }else{
                print("失败了")
            }
        }
        return false
    }
}

























































