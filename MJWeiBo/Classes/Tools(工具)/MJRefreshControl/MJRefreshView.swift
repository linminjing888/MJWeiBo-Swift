//
//  MJRefreshView.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/4/7.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

class MJRefreshView: UIView {

    ///刷新状态
    var refreshStatus:MJRefreshStatus = .Normal{
        didSet{
            switch refreshStatus {
            case .Normal:
                tipLabel.text = "下拉刷新..."
            case .Pulling:
                tipLabel.text = "放手刷新..."
            case .WillRefresh:
                tipLabel.text = "正在刷新..."
            }
        }
    }
    
    /// 指示图
    @IBOutlet weak var tipIcon: UIImageView!
    /// 指示文字
    @IBOutlet weak var tipLabel: UILabel!
    /// 指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    class func refreshView() -> MJRefreshView {
        
        let nib = UINib(nibName: "MJRefreshView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! MJRefreshView
    }
}
