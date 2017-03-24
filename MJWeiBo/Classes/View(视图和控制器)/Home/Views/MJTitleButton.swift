//
//  MJTitleButton.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/3/23.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

class MJTitleButton: UIButton {

    ///重载构造函数
    /// - title 如果为nil 显示“首页”
    /// -不为nil 就显示title和img
    init(title:String?) {
        super.init(frame: CGRect())
        
        if title == nil {
            setTitle("首页", for: [])
        }else{
            setTitle(title, for: [])
            
            setImage(UIImage(named:"navigation_down"), for: [])
            setImage(UIImage(named:"navigation_up"), for: .selected)
        }
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: [])
        
        //设置大小
        sizeToFit()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///重新布局子视图
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel,let imageView = imageView else {
            return
        }
        print("\(titleLabel) \(imageView)")
        titleLabel.frame.origin.x = 0;
        imageView.frame.origin.x = titleLabel.bounds.width;
        
//        titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
//        imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width, dy: 0)
    }

}
