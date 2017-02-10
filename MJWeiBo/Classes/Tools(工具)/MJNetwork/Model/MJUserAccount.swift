//
//  MJUserAccount.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/1/13.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

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
    
    func saveAccount() {
        
        var dict = (self.yy_modelToJSONObject() as? [String:Any]) ?? [:]
        //移除不需要保存的
        dict.removeValue(forKey: "expires_in")
        //归档
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []), let filePath = ("userAccount.json" as NSString).cz_appendDocumentDir()
            else {
            return
        }
        
        (data as NSData).write(toFile: filePath, atomically: true)
        print("用户账户保存成功 \(filePath)")
        
    }
}
