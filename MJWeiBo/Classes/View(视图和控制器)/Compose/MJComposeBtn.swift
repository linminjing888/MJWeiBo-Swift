//
//  MJComposeBtn.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/4/27.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

class MJComposeBtn: UIControl {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    ///控制器类属性
    var clsName: String?
    
    class func composeBtn(imageName:String,title:String) -> MJComposeBtn {
        
        let nib = UINib(nibName: "MJComposeBtn", bundle: nil)
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! MJComposeBtn
        
        btn.imageView.image = UIImage(named: imageName)
        btn.titleLabel.text = title
        return btn
    }
}
