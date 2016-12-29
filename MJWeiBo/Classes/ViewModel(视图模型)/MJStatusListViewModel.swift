//
//  MJStatusListViewModel.swift
//  MJWeiBo
//
//  Created by YXCZ on 16/12/29.
//  Copyright © 2016年 林民敬. All rights reserved.
//

import Foundation

/*
 父类的选择 swift
 
 - 如果类需要使用 KVC或者字典转模型框架设置对象值，类就需要继承自 NSObject
 - 如果类只包含一些逻辑代码（一些函数），可以不用任何父类，好处：更加轻量级
 
 1.字典转模型
 2.下拉、上啦刷新数据处理
 */
private var maxPullUpTimes = 3

class MJStatusListViewModel {
    
    //模型数组懒加载
    lazy var statusList = [MJStatus]()
    private var pullUpErrorTimes = 0
    
    /// 加载微博列表
    ///
    /// - Parameters:
    ///   - pullUp: 是否上拉刷新标记
    ///   - completion: 网络请求是否成功(网络请求是否成功、是否刷新表格)
    func loadStatus(pullUp:Bool,completion:@escaping (_ isSuccess:Bool,_ isRefresh:Bool)->()) {
        
        if pullUp && (pullUpErrorTimes > maxPullUpTimes) {
            
            completion(true, false)
            
            return
        }
        
        /// since_id 取出数组中第一条微博的id  下拉刷新
        let since_id = pullUp ? 0 : (statusList.first?.id ?? 0)
        
        ///上啦刷新
        let max_id = !pullUp ? 0 :(statusList.last?.id ?? 0)
        
        
        MJNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
          guard  let array = NSArray.yy_modelArray(with:MJStatus.self , json: list ?? []) as? [MJStatus] else{
            
            completion(isSuccess,false)
            return
            
            }
            
            print("刷新 \(array.count) 条数据")
            
            if pullUp{
                //上啦刷新
                self.statusList += array
            }else{
                self.statusList = array + self.statusList
            }
            
            if pullUp && array.count==0{
                self.pullUpErrorTimes += 1
                completion(isSuccess,false)
            }else{
                completion(isSuccess,true)
            }
            
        }
    }
}
