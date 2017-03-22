//
//  MJUserAccount.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/1/13.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

private let accountFile:NSString = "userAccount.json"

class MJUserAccount: NSObject {

    
    var access_token :String? //= "2.00hsqXpF0DC7l_ca9bc4964eCiHeME"
    var uid :String?
    
    //access_token的生命周期，单位是秒
    var expires_in :TimeInterval = 0{
        
        didSet{
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    ///过期日期
    var expiresDate :Date?
    
    override var description: String{
        return yy_modelDescription()
    }
    
    override init(){
        super.init()
        //从磁盘加载保存的文件 -> 字典
        
        guard let path = accountFile.cz_appendDocumentDir(),let data = NSData(contentsOfFile: path),let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String:Any]  else {
            return
        }
        
        //使用字典设置属性值
        yy_modelSet(with: dict ?? [:] )
        
        print("从沙盒加载用户信息\(self)")
        
        //测试账户过期日期
//        expiresDate = Date(timeIntervalSinceNow: -3600*24)
        if expiresDate?.compare(Date()) != .orderedDescending {
            print("账户过期")
            
            access_token = nil
            uid = nil
            //清除账户文件
            try? FileManager.default.removeItem(atPath: path)
        }
        print("正常")
    }
    
    func saveAccount() {
        
        var dict = (self.yy_modelToJSONObject() as? [String:Any]) ?? [:]
        //移除不需要保存的
        dict.removeValue(forKey: "expires_in")
        //归档
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []), let filePath = accountFile.cz_appendDocumentDir()
            else {
            return
        }
        
        (data as NSData).write(toFile: filePath, atomically: true)
        print("用户账户保存成功 \(filePath)")
        
    }
}
