//
//  NetworkTools.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/28.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
import AFNetworking

//http 请求方法枚举
enum RequestMethod:String {
    case GET = "GET"
    case POST = "POST"
}

//MARK: - 网络工具
class NetworkTools: AFHTTPSessionManager {
    
    // MARK: - 应用程序信息
    private let appKey = "3672008672"
    private let appSecret = "4474565be8f9e77dfbfff1c25c5d7f28"
    private let reDirectUrl = "http://www.baidu.com"//重定向地址

    ///网络请求完成回调, 类似于 oc的 typeDefine
    typealias HKRequestCallBack = (Any?, Error?) -> ()
    
    //单例
    static let sharedTools:NetworkTools = {
        let tools = NetworkTools(baseURL: nil)
        //设置反序列化数据格式 - 系统会自动将 OC 框架中的 NSSet 转换成 Set
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        return tools
    }()
    
}

// MARK: - 微博数据相关方法
extension NetworkTools {
    
    /// 加载微博数据
    ///
    ///since_id 若指定此参数，则返回 ID比 since_id大的微博，默认为0
    ///max_id 若指定此参数，则返回 ID小于或等于max_id的微博，默认为0
    /// - Parameter finish: 完成回调
    /// - see: [http://open.weibo.com/wiki/2/statuses/home_timeline](http://open.weibo.com/wiki/2/statuses/home_timeline)
    func loadStatus(since_id:Int, max_id:Int, finish:@escaping HKRequestCallBack)  {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        guard let accessToken = UserAccountViewModel.sharedUserAccount.accessToken else {
            //通知调用方，token 无效
            finish(nil, NSError(domain: "cn.houke.error", code: -1001, userInfo: ["message" : "token为空"]) as Error)
            return
        }
        var params = [ "access_token":accessToken]
        
        //判断是否下拉
        if since_id > 0 {
            params["since_id"] = String(since_id)
        }else if max_id > 0 {
            //上拉参数
            params["max_id"] = String(max_id - 1)
        }
        request(method: RequestMethod.GET, URLString: urlString, parameters: params, finished: finish)
    }
}

//MARK: - 用户相关方法
extension NetworkTools {
    
    /// 加载用户信息
    ///
    /// - Parameters:
    ///   - uid: uid
    ///   - finish: 完成回调
    /// - see: [http://open.weibo.com/wiki/2/users/show](http://open.weibo.com/wiki/2/users/show)
    func loadUserInfo(uid:String, finish:@escaping HKRequestCallBack) {
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        guard let accessToken = UserAccountViewModel.sharedUserAccount.accessToken else {
            //通知调用方，token 无效
            finish(nil, NSError(domain: "cn.houke.error", code: -1001, userInfo: ["message" : "token为空"]) as Error)
            return
        }
        let params = ["uid":uid, "access_token":accessToken]
        
        request(method: RequestMethod.GET, URLString: urlString, parameters: params, finished: finish)
    }
}

//MARK: - OAuth 相关方法
extension NetworkTools {
    /// OAuth 授权 url
    /// - see: [http://open.weibo.com/wiki/Oauth2/authorize](http://open.weibo.com/wiki/Oauth2/authorize)
    var oauthULR:URL {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(reDirectUrl)"
        
        return URL(string: urlString)!
    }
    
    /// 加载 AccessToken
    /// - see: [http://open.weibo.com/wiki/Oauth2/access_token](http://open.weibo.com/wiki/Oauth2/access_token)
    func loadAccessToken(code: String, finish:@escaping HKRequestCallBack)  {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id":appKey,
                      "client_secret":appSecret,
                      "grant_type":"authorization_code",
                      "code":code,
                      "redirect_uri":reDirectUrl]
        
        request(method: RequestMethod.POST, URLString: urlString, parameters: params, finished: finish)
    }
}

//MARK: - 封装 AFN 网络方法
extension NetworkTools{
    
      private func request(method:RequestMethod, URLString:String, parameters:[String : Any]?, finished:@escaping HKRequestCallBack)  {

        let progress = {(progress: Progress) in}
        let success = { (task: URLSessionDataTask, result:Any?) in
             finished(result, nil)
        }
        let failure = { (task: URLSessionDataTask?, error:Error) in

            print(error)
            finished(nil, error)
        }


        if method == RequestMethod.GET{
           get(URLString, parameters: parameters, progress: progress, success: success , failure: failure)
        }else{
            post(URLString, parameters: parameters, progress: progress, success: success , failure: failure)
        }

    }
}
































