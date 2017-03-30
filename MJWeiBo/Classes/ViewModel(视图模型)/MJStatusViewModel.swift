//
//  MJStatusViewModel.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/3/30.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import Foundation

/// 单条微博的视图模型
class MJStatusViewModel{
    
    ///微博模型
    var status:MJStatus
    
    
    /// 构造函数
    ///
    /// - Parameter model: 微博模型
    init(model:MJStatus) {
        self.status = model
    }
    
    
}
