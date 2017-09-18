//
//  MJEmotionTipView.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/6/19.
//  Copyright © 2017年 林民敬. All rights reserved.
//   32

import UIKit
import pop
class MJEmotionTipView: UIImageView {

    fileprivate var preEmoticon:MJEmoticon?
    
    var emoticon : MJEmoticon?{
        didSet{
            if emoticon == preEmoticon {
                return
            }
            preEmoticon = emoticon
            tipButton.setTitle(emoticon?.emoji, for: [])
            tipButton.setImage(emoticon?.image, for: [])
            
            // 表情动画 --弹力动画的结束时间是根据速度自动计算的，不需要指定 duration
            let anim:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = 30
            anim.toValue = 8
            anim.springBounciness = 20
            anim.springSpeed = 20
            tipButton.layer.pop_add(anim, forKey: nil)
        }
    }
    
    fileprivate lazy var tipButton = UIButton()
    
    /// 构造函数
    init() {
        
        let bundle = MJEmoticonManager.shared.bundle
        let image = UIImage(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        
        super.init(image: image)
        //设置锚点
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.2)
        
        tipButton.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        tipButton.frame = CGRect(x: 0, y: 8, width: 36, height: 36)
        tipButton.center.x = bounds.size.width * 0.5
        tipButton.setTitle("ha", for: [])
        tipButton.setTitleColor(UIColor.orange, for: [])
        tipButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        addSubview(tipButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
