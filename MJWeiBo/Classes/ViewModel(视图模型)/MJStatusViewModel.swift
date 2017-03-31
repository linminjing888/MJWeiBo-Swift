//
//  MJStatusViewModel.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/3/30.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import Foundation

/// 单条微博的视图模型
/**
  如果没有任何父类，希望在开发时调试，输出数据信息，需要
 1.遵守 CustomStringConvertible 协议
 2.实现 description 计算型属性
 */
class MJStatusViewModel:CustomStringConvertible{
    
    ///微博模型
    var status:MJStatus
    ///会员图标 - 存储型属性（用内存换CPU）
    var memberIcon:UIImage?
    /// 认证类型 -1：没有认证  0：认证用户 2，3，5：企业认证 220：达人
    var vipIcon:UIImage?
    
    /// 转发字符串
    var repostStr:String?
    ///评论
    var commentStr:String?
    /// 喜欢
    var likeStr:String?
    
    
    /// 构造函数
    ///
    /// - Parameter model: 微博模型
    init(model:MJStatus) {
        self.status = model
        
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! < 7 {
            
            let imgName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberIcon = UIImage(named: imgName)
            
        }
        
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named:"avatar_vip_golden")
        case 2,3,5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        
        ///测试 万
//        model.reposts_count = Int(arc4random_uniform(100000))
        repostStr = countString(count: model.reposts_count, defauleStr: "转发")
        commentStr = countString(count: model.comments_count, defauleStr: "评论")
        likeStr = countString(count: model.attitudes_count, defauleStr: "赞")
    }
    
    func countString(count:Int ,defauleStr:String) -> String {
        
        if count < 1 {
            return defauleStr
        }
        
        if count<10000 {
            return count.description
        }
        
        return String(format: "%.2f 万",Double(count) / 10000)
    }
    
    var description: String{
        return status.description
    }
}
