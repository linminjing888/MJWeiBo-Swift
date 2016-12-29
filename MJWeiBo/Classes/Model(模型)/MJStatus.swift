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
    
    override var description: String{
        return yy_modelDescription()
    }
}
