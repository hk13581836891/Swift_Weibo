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

    //单例
    static let sharedTools:NetworkTools = {
        let tools = NetworkTools(baseURL: nil)
        //设置反序列化数据格式 - 系统会自动将 OC 框架中的 NSSet 转换成 Set
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        return tools
    }()
    
}
//MARK: - 封装 AFN 网络方法
extension NetworkTools{
    
    
    func request(method:RequestMethod, URLString:String, parameters:[String : Any]?, finished:@escaping (_:Any?, _:Error?) -> ())  {
    
        let progress = {(progress: Progress) in}
        let success = { (task: URLSessionDataTask, result:Any?) in
             finished(result, nil)
        }
        let failure = { (task: URLSessionDataTask?, error:Error) in
            finished(nil, error)
        }
        
        if method == RequestMethod.GET{
           get(URLString, parameters: parameters, progress: progress, success: success, failure: failure)
        }else{
            post(URLString, parameters: parameters, progress: progress, success: success, failure: failure)
        }
        
    }
}
































