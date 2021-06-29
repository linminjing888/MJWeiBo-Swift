//
//  String+Extension.swift
//  正则表达式
//
//  Created by YXCZ on 17/4/28.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import Foundation


extension String{
    
    //从字符串中提取连接和文本 
    // Swift 提供了‘元组’，同时返回多个参数
    func mj_href() -> (link:String,text:String)? {
        
        //匹配方案(正则表达式)
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        
        //1.创建正则表达式，如果pattern失败，抛出异常
        //2.进行查找，匹配第一项
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) , let result = regx.firstMatch(in:self , options: [], range: NSRange(location: 0, length: count)) else {
            print("没有找到匹配项")
            return nil
        }
        
      
        let link = (self as NSString).substring(with: result.range(at: 1))
        let text = (self as NSString).substring(with: result.range(at: 2))
        
//        print(link + "---" + text)
        return(link,text)

    }
}
