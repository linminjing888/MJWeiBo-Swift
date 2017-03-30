//
//  MJWelcomeView.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/3/24.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit
import SDWebImage

class MJWelcomeView: UIView {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    /// iconImage 底部位置
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    class func welcomeView() -> MJWelcomeView {
        
        let nib = UINib(nibName: "MJWelcomeView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! MJWelcomeView
        // 从 xib 加载的视图 默认是 600 * 600
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let urlString = MJNetworkManager.shared.userAccount.avatar_large , let url = URL(string: urlString)  else {
            return
        }
        
        self.iconImage .sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default"))
        
        self.iconImage.layer.cornerRadius = self.iconImage.bounds.width * 0.5
        self.iconImage.layer.masksToBounds = true
        
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        //视图是使用自动布局来设置的，只是设置了约束
        // - 当视图被添加到窗口上时，根据父视图的大小，计算约束值，更新控件位置
        // - layoutIfNeeded 会直接按照当前的约束值，直接更新控件位置
        // - 执行之前，控件所在位置，就是xib中布局的位置
        self.layoutIfNeeded()
        
        bottomCons.constant = bounds.size.height - 200
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
            //更新约束
                        self.layoutIfNeeded()
        }) { (_) in
            
            UIView.animate(withDuration: 1.0, animations: {
                self.tipLabel.alpha = 1.0
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        }
    }
}
