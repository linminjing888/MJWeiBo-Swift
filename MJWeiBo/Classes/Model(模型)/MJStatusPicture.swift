//
//  MJStatusPicture.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/4/1.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

class MJStatusPicture: NSObject {

    var thumbnail_pic:String?{
        didSet{
//            print(thumbnail_pic ?? "")
            
            // 设置大尺寸图片
            largePic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/large/")
            
            thumbnail_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
        }
    }
    
    // 大尺寸图片
    var largePic: String?
    
    override var description: String{
        return yy_modelDescription()
    }
    
}
