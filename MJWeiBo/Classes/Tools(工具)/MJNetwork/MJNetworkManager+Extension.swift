//
//  MJNetworkManager+Extension.swift
//  MJWeiBo
//
//  Created by YXCZ on 16/12/29.
//  Copyright © 2016年 林民敬. All rights reserved.
//

import Foundation

extension MJNetworkManager{
    
    /// 加载微博数据 字典数组
    ///
    /// - Parameters:
    ///   - since_id: 返回ID比since_id大的微博（即比since_id时间晚的微博)
    ///   - max_id: 返回ID小于或等于max_id的微博
    ///   - completion: 完成回调 (字典数组/是否成功)
    func statusList(since_id:Int64 = 0,max_id:Int64 = 0,completion:@escaping (_ list:[[String:Any]]?,_ isSuccess:Bool)->()) {
        
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let params = ["since_id":"\(since_id)","max_id":"\(max_id>0 ? max_id-1 : 0)"]
        
               
        tokenRequest(method: .GET, URLString: urlString, parameters: params ) { (json, isSuccess) in
            
            //如果 as？失败，result = nil
            let result = (json as? NSDictionary)?["statuses"] as? [[String:Any]]
            
            completion(result, isSuccess)
        }
    }
    
    
    func unreadCount(completion:@escaping (_ count:Int)->()) {
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        let params = ["uid":uid]
        
        tokenRequest(URLString: urlString, parameters: params) { (json, isSuccess) in
            
            let dict = json as? [String:Any]
            let count = dict?["status"] as? Int
            completion(count ?? 0)
        }
        
    }
}

extension MJNetworkManager{
    
    func loadAccessToken(code:String){
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let params = ["client_id":MJAPPKEY,
                      "client_secret":MJAPPSECRET,
                      "grant_type":"authorization_code",
                      "code":code,
                      "redirect_uri":MJREDIRECTURL]
        
        request(method:.POST , URLString:urlString , parameters: params) { (json, isSuccess) in
//            print(json ?? "")
            //字典转模型  可选型 空字典[:]
            self.userAccount.yy_modelSet(with:(json as? [String:Any]) ?? [:])
            
            print(self.userAccount)
            
            self.userAccount.saveAccount()
        }
    }

}
