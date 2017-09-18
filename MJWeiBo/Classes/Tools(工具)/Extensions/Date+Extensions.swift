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
/// 当前日期对象
let calendar = Calendar.current


extension Date{
    
    /// 计算与当前系统时间偏差 delta：秒数的日期字符串
    ///在 swift 中 ，如果要定义结构体的’类‘函数，要用static修饰->静态函数
    static func mj_dataString(delta:TimeInterval) -> String {
        
        let date = Date(timeIntervalSinceNow: delta)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
    
    static func mj_sinaDate(string:String)->Date?{
        
        dateFormatter.dateFormat = "EEE MM dd HH:mm:ss zzz yyyy"
        return dateFormatter.date(from: string)
    }
    
    
    var dateDescription:String{
        if calendar.isDateInToday(self) {
            let delta = -Int(self.timeIntervalSinceNow)
            if delta < 60 {
                return "刚刚"
            }
            if delta < 3600 {
                return "\(delta/60)分钟前"
            }
            return "\(delta / 3600)小时前"
        }
        var fmt = " HH:mm"
        if calendar.isDateInYesterday(self) {
            fmt = "昨天" + fmt
        }else{
            fmt = "MM-dd" + fmt
            let year = calendar.component(.year, from: self)
            let thisYear = calendar.component(.year, from: Date())
            if year != thisYear {
                fmt = "yyyy-" + fmt
            }
        }
        dateFormatter.dateFormat = fmt
        
        return dateFormatter.string(from: self);
    }
    
}
