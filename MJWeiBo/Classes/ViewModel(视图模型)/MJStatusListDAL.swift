//
//  MJStatusListDAL.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/6/15.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import Foundation

//DAL -- Data Access Layer 数据访问层
//使命：负责处理数据库和网络数据，给ListViewModel 返回微博的[字典数组]
class MJStatusListDAL{
    
    /// 从本地数据库或者网络加载数据
    ///
    /// - Parameters:
    ///   - since_id: 下拉刷新id
    ///   - max_id: 上啦刷新id
    ///   - completion: 完成回调(微博字典数组，是否成功)
    class func loadStatus(since_id:Int64 = 0,max_id:Int64 = 0,completion:@escaping (_ list:[[String:Any]]?,_ isSuccess:Bool)->()) {
        
        guard let userId = MJNetworkManager.shared.userAccount.uid else {
            return
        }
        let array = MJSQLiteManager.shared.loadStatus(userId: userId, since_id: since_id, max_id: max_id)
        if array.count>0 {
            completion(array, true)
            return
        }
        MJNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            //判断网络请求是否成功
            if !isSuccess{
                completion(nil, false)
                return
            }
            
            //判断数据
            guard let list = list else{
                completion(nil, isSuccess)
                return
            }
            //加载完成之后，将网络数据同步写入数据库
            MJSQLiteManager.shared.updateStatus(userId: userId, array: list as [[String : AnyObject]])
            
            completion(list, isSuccess)
        }
    }
}
