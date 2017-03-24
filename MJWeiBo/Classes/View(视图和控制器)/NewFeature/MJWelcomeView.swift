//
//  MJWelcomeView.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/3/24.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

class MJWelcomeView: UIView {

    class func welcomeView() -> MJWelcomeView {
        
        let nib = UINib(nibName: "MJWelcomeView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! MJWelcomeView
        // 从 xib 加载的视图 默认是 600 * 600
        v.frame = UIScreen.main.bounds
        
        return v
    }

}
