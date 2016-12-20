//
//  MJNavigationController.swift
//  MJWeiBo
//
//  Created by YXCZ on 16/12/16.
//  Copyright © 2016年 林民敬. All rights reserved.
//

import UIKit

class MJNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //隐藏系统自带navigationBar
        navigationBar.isHidden = true
    }
    
    
    //重写 push 方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        //不是栈底控制器才需要隐藏，根控制器不需要处理
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
            if let vc = viewController as? MJBaseViewController {
                
                var title = "返回"
                
                if childViewControllers.count == 1  {
                    title = childViewControllers.first?.title ?? "返回"
                }
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(popToParent),isBack:true)
            }
        
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
    func popToParent(){
        popViewController(animated: true)
    }
    

}
