//
//  MJEmotionToolBar.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/6/5.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

@objc protocol MJEmotionToolBarDelegate:NSObjectProtocol{
    
    func MJEmotionToolBarDidSelectedWithIndex(toolBar:MJEmotionToolBar, index:Int)
}
//表情键盘 底部工具栏
class MJEmotionToolBar: UIView {

    weak var delegate:MJEmotionToolBarDelegate?
    
    /// 选中分组索引
    var selectedIndex:Int = 0{
        didSet{
            for btn in subviews as! [UIButton] {
                btn.isSelected = false
            }
            (subviews[selectedIndex] as! UIButton).isSelected = true
        }
    }
    
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
    
    /// 点击分组按钮
    @objc fileprivate func clickButton(btn:UIButton)  {
        
        delegate?.MJEmotionToolBarDidSelectedWithIndex(toolBar: self, index: btn.tag)
    }
}

private extension MJEmotionToolBar{
    
    func setupUI() {
        
        let manager = MJEmoticonManager.shared
        for (i,p) in manager.packages.enumerated() {
            let btn = UIButton()
            btn.setTitle(p.groupName, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.setTitleColor(UIColor.darkGray, for: .highlighted)
            btn.setTitleColor(UIColor.darkGray, for: .selected)
            
            let imageName = "compose_emotion_table_\(p.bgImageName ?? "")_normal"
            let imageNameHL = "compose_emotion_table_\(p.bgImageName ?? "")_selected"
            
            var image = UIImage(named: imageName, in: manager.bundle, compatibleWith: nil)
            var imageHL = UIImage(named: imageNameHL, in: manager.bundle, compatibleWith: nil)
            
            let size = image?.size ?? CGSize()
            let inset = UIEdgeInsets(top: size.height * 0.5,
                                     left: size.width * 0.5,
                                     bottom: size.height * 0.5,
                                     right: size.width * 0.5)
            image = image?.resizableImage(withCapInsets: inset)
            imageHL = imageHL?.resizableImage(withCapInsets: inset)
            
            btn.setBackgroundImage(image, for: [])
            btn.setBackgroundImage(imageHL, for: .highlighted)
            btn.setBackgroundImage(imageHL, for: .selected)
            
            btn.sizeToFit()
            addSubview(btn)
            
            btn.tag = i
            btn.addTarget(self, action: #selector(clickButton(btn:)), for: .touchUpInside)
            // 默认选中第0组
            (subviews[0] as! UIButton).isSelected = true
            
        }
    }
}
