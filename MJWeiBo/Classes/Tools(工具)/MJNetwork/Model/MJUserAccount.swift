//
//  MJUserAccount.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/1/13.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

class MJUserAccount: NSObject {

    
    var access_token :String? 
    var uid :String?
    
    //access_token的生命周期，单位是秒
    var expires_in :TimeInterval = 0{
        
        didSet{
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    
    var expiresDate :Date?
    
    
    override var description: String{
        return yy_modelDescription()
    }
    
}
