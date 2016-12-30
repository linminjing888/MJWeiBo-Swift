//
//  MJNetworkManager.swift
//  MJWeiBo
//
//  Created by YXCZ on 16/12/26.
//  Copyright © 2016年 林民敬. All rights reserved.
//

import UIKit
import AFNetworking

enum MJHTTPMethod {
    case GET
    case POST
}

class MJNetworkManager: AFHTTPSessionManager {

    ///在第一次访问时，执行闭包，并且将结果保存在 shared 常量中
    static let shared = MJNetworkManager()
    
    ///访问令牌
    var accessToken:String? // = "2.00hsqXpF0DC7l_ca9bc4964eCiHeME"
    
    var uid:String? = "5365823342"
    
    var userLogon:Bool{
        return accessToken != nil
    }
    
    
    func tokenRequest(method:MJHTTPMethod = .GET,URLString:String,parameters:[String:Any]?,completion:@escaping (_ json: Any?,_ isSuccess:Bool)->()) {
        
        guard let token = accessToken else {
            
            // FIXME: 发送通知，提示用户登入
            print("没有 token 需要登入")
            
            completion(nil, false)
            return
        }
        
        //判断 参数字典是否存在，如果为nil，应该新建一个字典
        var parameters = parameters
        if parameters == nil {
            parameters = [String:Any]()
        }
        
        // 设置参数字典
        parameters!["access_token"] = token
        
        request(method: method, URLString: URLString, parameters: parameters!, completion:completion)
       
    }
    
    
    //option + command + /
    //@escaping(逃逸闭包)
    /// 封装AFNetworking GET/POST
    ///
    /// - Parameters:
    ///   - method: GET/POST
    ///   - URLString: URLString
    ///   - parameters: 参数字典
    ///   - completion: 完成回调JSON（字典/数组） 是否成功
    func request(method:MJHTTPMethod = .GET,URLString:String,parameters:[String:Any],completion:@escaping (_ json: Any?,_ isSuccess:Bool)->()) {

        //成功
        let success = {(task:URLSessionDataTask,json:Any?)->() in
            completion(json, true)
        }
        
        //失败
        let failure = {(task:URLSessionDataTask?,error:Error)->() in
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("Token 过期了")
                
                // FIXME: 发送通知（本方法不知道被谁调用，谁接收到通知谁处理）
            }
            
            print("网络请求失败 \(error)")
            completion(nil, false)
        }
        
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }else{
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
        
    }
}
