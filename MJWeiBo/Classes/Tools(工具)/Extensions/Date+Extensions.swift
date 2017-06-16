//
//  Date+Extensions.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/6/16.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import Foundation

/// 日期格式化 - 不要频繁的释放和创建，会影响性能
let dateFormatter = DateFormatter()

extension Date{
    
    /// 计算与当前系统时间偏差 delta：秒数的日期字符串
    ///在 swift 中 ，如果要定义结构体的’类‘函数，要用static修饰->静态函数
    static func mj_dataString(delta:TimeInterval) -> String {
        
        let date = Date(timeIntervalSinceNow: delta)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
    
}
