//
//  MJStatusListViewModel.swift
//  MJWeiBo
//
//  Created by YXCZ on 16/12/29.
//  Copyright © 2016年 林民敬. All rights reserved.
//

import Foundation
import SDWebImage
/*
 父类的选择 swift
 
 - 如果类需要使用 KVC或者字典转模型框架设置对象值，类就需要继承自 NSObject
 - 如果类只包含一些逻辑代码（一些函数），可以不用任何父类，好处：更加轻量级
 
 1.字典转模型
 2.下拉、上啦刷新数据处理
 */
private var maxPullUpTimes = 3

class MJStatusListViewModel {
    
    //微博视图模型数组懒加载
    lazy var statusList = [MJStatusViewModel]()
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
        let since_id = pullUp ? 0 : (statusList.first?.status.id ?? 0)
        
        ///上啦刷新
        let max_id = !pullUp ? 0 :(statusList.last?.status.id ?? 0)
        
        MJStatusListDAL.loadStatus(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
//        }
//        MJNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            if !isSuccess{
                completion(false,false)
                
                return
            }
            //1.定义结果可变数组
            var array = [MJStatusViewModel]()
            
            //2.遍历服务器返回的字典数组，字典转模型
            for dict in list ?? []{
                //创建微博模型--如果创建失败，则继续遍历
               guard let model = MJStatus.yy_model(with: dict) else{
                    continue
                }
                
                array.append(MJStatusViewModel(model: model))
            }
//             print(array)
//            print("刷新 \(array.count) 条数据")
            
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
                
                //闭包可以当做参数传递
                self.cacheSingleImage(list: array,finished: completion)
                //真正有数据的回调
//                completion(isSuccess,true)
            }
            
        }
    }
    
    /// 缓存本次微博数据中的单张数组
    ///
    /// - Parameter list: 本次下载的视图模型数组
    private func cacheSingleImage(list:[MJStatusViewModel],finished:@escaping (_ isSuccess:Bool,_ isRefresh:Bool)->()) {
        
        //1.>调度组
        let group = DispatchGroup()
        
        //数据长度
        var length = 0
        
        ///option + command + 左 折叠
        for vm in list {
            if vm.picUrls?.count != 1 {
                continue
            }
            
            guard  let picStr = vm.picUrls?[0].thumbnail_pic ,
            let url = URL(string: picStr) else {
                continue
            }
            
//            print("要缓存的URL \(url)")
            //2.>入组
            group.enter()
            ///图像下载完成之后，自动保存到沙盒中，文件路径是url的md5
            SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
            
                //将图像转换为二进制数据
                if let image = image,
                    let data = UIImagePNGRepresentation(image){
                    // NSdata 是 length属性
                    length += data.count
                    
                    //图像缓存成功，更新配图视图的大小
                    vm.updateSingleImageSize(image: image)
                }
                
//                print("缓存的图像\(image) \(length)")
                //3.>出组
                group.leave()
            })
            
        }
        //4.>监听调度组情况
        group.notify(queue: DispatchQueue.main) {
            
            print("图像下载完成\(length / 1024)KB")
            finished(true,true)
        }
        
    }
}
