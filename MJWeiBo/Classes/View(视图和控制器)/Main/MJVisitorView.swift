//
//  MJVisitorView.swift
//  MJWeiBo
//
//  Created by YXCZ on 16/12/21.
//  Copyright © 2016年 林民敬. All rights reserved.
//

import UIKit

class MJVisitorView: UIView {

    /// 使用字典设置访客视图的信息 [imageName / message]
    ///提示：如果是首页 imageName =""
    var visitorInfo: [String:String]?{
        didSet{
            guard let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"] else {
                    return
            }
            
            tipLabel.text = message
            
            if imageName == "" {
                
                startAnimation()
                return
            }
            
            iconImage.image = UIImage(named: imageName)
            hourseImage.isHidden = true
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //旋转图标动画
    func startAnimation() {
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 15
        anim.repeatCount = MAXFLOAT
        
        //动画完成不删除 如果iconImage 被释放，动画会一起销毁 
        //此方法对连续动画非常重要
        anim.isRemovedOnCompletion = false
        
        iconImage.layer.add(anim, forKey: nil)
        
    }
    
    //MARK: - 私有控件
    //懒加载
    lazy var iconImage = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    
    lazy var hourseImage = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    
    lazy var tipLabel:UILabel = UILabel.cz_label(
        withText: "关注一些人,回来看看有什么收获",
        fontSize: 14,
        color: UIColor.darkGray)
    
    lazy var registerBtn:UIButton = UIButton.cz_textButton(
        "注册",
        fontSize: 16,
        normalColor: UIColor.orange,
        highlightedColor: UIColor.darkGray,
        backgroundImageName: "common_button_white_disable")
    
    lazy var loginBtn:UIButton = UIButton.cz_textButton(
        "登录",
        fontSize: 16,
        normalColor: UIColor.darkGray,
        highlightedColor: UIColor.darkGray,
        backgroundImageName: "common_button_white_disable")
}

extension MJVisitorView{
    
    func setUpUI() {
        backgroundColor = UIColor.cz_color(withHex: 0xEDEDED)
        
        addSubview(iconImage)
        addSubview(hourseImage)
        addSubview(tipLabel)
        addSubview(registerBtn)
        addSubview(loginBtn)
        
        //取消 autoresizing
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //原生代码自动布局 view1.attr1 = view2.attr2 * multiplier + constant"
        addConstraint(NSLayoutConstraint(
            item: iconImage,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0))
        addConstraint(NSLayoutConstraint(
            item: iconImage,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: -60))
        
        addConstraint(NSLayoutConstraint(
            item: hourseImage,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: iconImage,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0))
        addConstraint(NSLayoutConstraint(
            item: hourseImage,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: iconImage,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0))
        
        addConstraint(NSLayoutConstraint(
            item: tipLabel,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: iconImage,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0))
        addConstraint(NSLayoutConstraint(
            item: tipLabel,
            attribute: .top,
            relatedBy: .equal,
            toItem: iconImage,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 20))
//        addConstraint(NSLayoutConstraint(
//            item: tipLabel,
//            attribute: .width,
//            relatedBy: .equal,
//            toItem: nil,
//            attribute: .notAnAttribute,
//            multiplier: 1.0,
//            constant: 236))
        
        addConstraint(NSLayoutConstraint(
            item: registerBtn,
            attribute: .right,
            relatedBy: .equal,
            toItem: tipLabel,
            attribute: .centerX,
            multiplier: 1.0,
            constant: -20))
        addConstraint(NSLayoutConstraint(
            item: registerBtn,
            attribute: .top,
            relatedBy: .equal,
            toItem: tipLabel,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 20))
        addConstraint(NSLayoutConstraint(
            item: registerBtn,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 100))
        
        addConstraint(NSLayoutConstraint(
            item: loginBtn,
            attribute: .left,
            relatedBy: .equal,
            toItem: tipLabel,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 20))
        addConstraint(NSLayoutConstraint(
            item: loginBtn,
            attribute: .top,
            relatedBy: .equal,
            toItem: tipLabel,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 20))
        addConstraint(NSLayoutConstraint(
            item: loginBtn,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 100))
        
    }
}
