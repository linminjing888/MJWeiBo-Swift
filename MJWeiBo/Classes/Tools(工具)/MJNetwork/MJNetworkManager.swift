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

    //在第一次访问时，执行闭包，并且将结果保存在 shared 常量中
    static let shared = MJNetworkManager()
    
    //option + command + /
    //@escaping(逃逸闭包)
    func request(method:MJHTTPMethod,URLString:String,parameters:[String:AnyObject],completion:@escaping (_ json: AnyObject?,_ isSuccess:Bool)->()) {

        
        let success = {(task:URLSessionDataTask,json:Any?)->() in
            completion(json as AnyObject?, true)
        }
        
        let failure = {(task:URLSessionDataTask?,error:Error)->() in
            
            
            completion(nil, false)
        }
        
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }else{
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
        
    }
}
