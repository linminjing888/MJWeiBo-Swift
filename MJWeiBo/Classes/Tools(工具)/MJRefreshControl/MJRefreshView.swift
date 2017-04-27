//
//  MJRefreshView.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/4/7.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

/// 自定义刷新控件 UI更新
class MJRefreshView: UIView {

    ///刷新状态
    var refreshStatus:MJRefreshStatus = .Normal{
        didSet{
            switch refreshStatus {
            case .Normal:
                //回复状态
                tipIcon?.isHidden = false
                indicator?.stopAnimating()
                
                tipLabel?.text = "下拉刷新..."
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon?.transform = CGAffineTransform.identity
                })
            case .Pulling:
                tipLabel?.text = "放手刷新..."
                UIView.animate(withDuration: 0.25, animations: { 
                    self.tipIcon?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI+0.001)) //就近原则
                })
            case .WillRefresh:
                tipLabel?.text = "正在刷新..."
                
                tipIcon?.isHidden = true
                indicator?.startAnimating()
            }
        }
    }
    
    var parentHeight:CGFloat = 0
    
    /// 指示图
    @IBOutlet weak var tipIcon: UIImageView?
    /// 指示文字
    @IBOutlet weak var tipLabel: UILabel?
    /// 指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView?
    
    class func refreshView() -> MJRefreshView {
        
        let nib = UINib(nibName: "MJMeiRefreshView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! MJRefreshView
    }
}
