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
//    static let shared = MJNetworkManager()
    static let shared:MJNetworkManager = {
        let instance = MJNetworkManager()
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return instance;
    }()
    
    //懒加载
    lazy var userAccount = MJUserAccount()
    
    var userLogon:Bool{
        return userAccount.access_token != nil
    }
    
    // 专门负责拼接 token 的网络请求方法
    // name 上传文件使用的字段名，默认为nil，不上传文件
    // data 上传文件的二进制数据，默认为nil，不上传文件
    func tokenRequest(method:MJHTTPMethod = .GET,URLString:String,parameters:[String:Any]?,name:String? = nil,data:Data? = nil,completion:@escaping (_ json: Any?,_ isSuccess:Bool)->()) {
        
        //判断token是否nil
        guard let token = userAccount.access_token else {
            
            // 发送通知，提示用户登入
            print("没有 token 需要登录")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: MJUserShouldLoginNotification), object: nil)
            
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
        
        if let name = name,let data = data {
            //上传文件
            upload(URLString: URLString, parameters: parameters!, name: name, data: data, completion: completion)
        }else{
            request(method: method, URLString: URLString, parameters: parameters!, completion:completion)
        }
       
    }
    
    /// 上传
    ///
    /// - Parameters:
    ///   - URLString: URLString
    ///   - parameters: 参数
    ///   - name: 上传数据的服务器字段‘pic’
    ///   - data: 要上传的二进制数据
    ///   - completion: 完成回调
    func upload(URLString:String,parameters:[String:Any],name:String,data:Data,completion:@escaping (_ json: Any?,_ isSuccess:Bool)->()) {
        
        post(URLString, parameters: parameters, constructingBodyWith: { (formData) in
            //保存服务器的文件名，大多说服务器可以乱写
            // mimeType :告诉服务器上传文件类型，如果不告诉，可以使用 application/octet-stream image/png  image/jpg image/gif
            formData.appendPart(withFileData: data, name: name, fileName: "xxx", mimeType: "application/octet-stream")
            
        }, progress:nil, success: { (task, json) in
            
            completion(json, true)
        }) { (task, error) in
            
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("Token 过期了")
                
                //发送通知（本方法不知道被谁调用，谁接收到通知谁处理）
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: MJUserShouldLoginNotification), object:"bad token")
            }
            
            print("网络请求失败 \(error)")
            completion(nil, false)
        }
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
                
                //发送通知（本方法不知道被谁调用，谁接收到通知谁处理）
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: MJUserShouldLoginNotification), object:"bad token")
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
