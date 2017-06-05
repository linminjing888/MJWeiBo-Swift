//
//  MJEmotionToolBar.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/6/5.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit
//表情键盘 底部工具栏
class MJEmotionToolBar: UIView {

    override func awakeFromNib() {
        
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let count = subviews.count
        let w = bounds.width / CGFloat(count)
        let rect = CGRect(x: 0, y: 0, width: w, height: bounds.height)
        
        for (i,btn) in subviews.enumerated() {
            btn.frame = rect.offsetBy(dx: CGFloat(i) * w, dy: 0)
        }
    }
}

private extension MJEmotionToolBar{
    
    func setupUI() {
        
        let manager = MJEmoticonManager.shared
        for p in manager.packages {
            let btn = UIButton()
            btn.setTitle(p.groupName, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.setTitleColor(UIColor.darkGray, for: .highlighted)
            btn.setTitleColor(UIColor.darkGray, for: .selected)
            
            let imageName = "compose_emotion_table_\(p.bgImageName)_normal"
            let imageNameHL = "compose_emotion_table_\(p.bgImageName)_selected"
            
            let image = UIImage(named: imageName, in: manager.bundle, compatibleWith: nil)
            
            btn.setBackgroundImage(image, for: [])
            
            
            btn.sizeToFit()
            
            btn.backgroundColor = UIColor.cz_random()
            addSubview(btn)
        }
        
    }
}
