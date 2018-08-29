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
           get(URLString, parameters: parameters, progress: progress, success: success, failure: failure)
        }else{
            post(URLString, parameters: parameters, progress: progress, success: success, failure: failure)
        }
        
    }
}
































