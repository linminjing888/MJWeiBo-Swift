//
//  MJRefreshControl.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/4/7.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit
/// 刷新状态切换的临界点
private let refreshOffSet:CGFloat = 120

/// 刷新状态
///
/// - Normal: 普通状态
/// - Pulling: 超过临界点，如果放手，开始刷新
/// - WillRefresh: 用户超过临界点，并且放手
enum MJRefreshStatus {
    case Normal
    case Pulling
    case WillRefresh
}
/// 自定义刷新控件 负责逻辑处理，对外
class MJRefreshControl: UIControl {

    /// 滚动视图的父视图  弱引用
    private weak var scrollView:UIScrollView?
    
    fileprivate lazy var refreshView:MJRefreshView = MJRefreshView.refreshView()
    
    
    /// 构造函数
    init() {
        super.init(frame: CGRect())
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)  //xib 也可以使用
        
        setupUI()
    }
    
    /**
     * will move addSubview 方法会调用
     - 当添加到父视图的时候 ，newSuperview 是父视图（scrollView的子类）
     - 当父视图被移除，newSuperview 是nil
     */
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        
        scrollView = sv
        
        // KVO 监听父视图的 contentOffset
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
        
    }
    
    override func removeFromSuperview() {
        
        //superView 还存在
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
        
        //superView 不存在
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let sv = scrollView else {
            return
        }
        //初始高度就应该是 0
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        if height < 0 {
            return
        }
        //传递高度
        if refreshView.refreshStatus != .WillRefresh {
            refreshView.parentHeight = height
        }
        
        //设置刷新控件的fream
        self.frame = CGRect(x: 0,
                            y: -height,
                            width: sv.bounds.width,
                            height: height)
        
        if sv.isDragging {
            if height > refreshOffSet && (refreshView.refreshStatus == .Normal){
                
                refreshView.refreshStatus = .Pulling
            }else if height <= refreshOffSet && (refreshView.refreshStatus == .Pulling){
                
                refreshView.refreshStatus = .Normal
            }
        }else{
            if refreshView.refreshStatus == .Pulling {
            
                beginRefreshing()
                
                sendActions(for: .valueChanged)
            }
        }
}
    
    func beginRefreshing() {
        print("begin")
        
        guard let sv = scrollView else {
            return
        }
        //判断是否正在刷新，如果正在刷新，直接返回
        if refreshView.refreshStatus == .WillRefresh {
            return
        }
        refreshView.refreshStatus = .WillRefresh
        
        var inset = sv.contentInset
        inset.top += refreshOffSet
        sv.contentInset = inset
        
    }
    
    func endRefreshing() {
        print("end")
        
        guard let sv = scrollView else {
            return
        }
        if refreshView.refreshStatus != .WillRefresh {
            return
        }
        
        refreshView.refreshStatus = .Normal
        var inset = sv.contentInset
        inset.top -= refreshOffSet
        sv.contentInset = inset
    }

}

extension MJRefreshControl{
    
    fileprivate func setupUI() {
        
        //设置 refreshView 超出边界不显示
//        clipsToBounds = true
        
        backgroundColor = superview?.backgroundColor
        
        addSubview(refreshView)
        //自动布局
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant:refreshView.bounds.width ))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))
        
    }
}
