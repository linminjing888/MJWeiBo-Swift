//
//  MJComposeTextView.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/5/19.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

class MJComposeTextView: UITextView {

    //占位符
    fileprivate lazy var textLabel = UILabel()
    
    override func awakeFromNib() {
        
        self.setupUI()
    }

    @objc fileprivate func textDidChange(n:Notification)  {
        //如果有文本就不显示占位符
        textLabel.isHidden = self.hasText
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MJComposeTextView{
    
    func setupUI() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
        textLabel.text = "分享新鲜事..."
        textLabel.font = self.font
        textLabel.textColor = UIColor.lightGray
        textLabel.sizeToFit()
        
        textLabel.frame.origin = CGPoint(x: 5, y: 8)
        
        self.addSubview(textLabel)
    }
}
