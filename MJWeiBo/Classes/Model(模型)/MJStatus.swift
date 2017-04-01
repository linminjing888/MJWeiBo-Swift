//
//  MJStatus.swift
//  MJWeiBo
//
//  Created by YXCZ on 16/12/29.
//  Copyright © 2016年 林民敬. All rights reserved.
//

import UIKit
import YYModel

class MJStatus: NSObject {

    /// Int 类型 在64位的机器上是64位，在32位的机器上 就是32位
    ///如果不写 Int64 在ipad2、iphone4/4s/5/5c 都无法运行
    var id:Int64 = 0
    
    ///微博信息
    var text:String?
    ///转发数
    var reposts_count : Int = 0
    /// 评论数
    var comments_count : Int = 0
    ///	表态数
    var attitudes_count : Int = 0
    
    var user:WBUser?
    ///微博配图数组
    var pic_urls:[MJStatusPicture]?
    
    
    override var description: String{
        return yy_modelDescription()
    }
    ///类函数 告诉第三方框架 YY_model 如果遇到数组类型的属性，数组中存放的对象是什么类
    class func modelContainerPropertyGenericClass() -> [String:AnyClass] {
        return["pic_urls":MJStatusPicture.self]
    }
}
