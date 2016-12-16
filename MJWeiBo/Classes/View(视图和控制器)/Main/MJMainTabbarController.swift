//
//  MJMainTabbarController.swift
//  MJWeiBo
//
//  Created by YXCZ on 16/12/16.
//  Copyright © 2016年 林民敬. All rights reserved.
//

import UIKit

class MJMainTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpChildController()
        setUpcomposeButton()
    }
   
    // MARK: 监听方法
    // FIXME: 没有实现（提醒）
    func composeStatus()  {
        print("写微博")
    }
    
    // 懒加载
    lazy var composeBtn:UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
    
extension MJMainTabbarController{
    
    //设置撰写按钮
    func setUpcomposeButton()  {
        tabBar.addSubview(composeBtn)
        
        let count = CGFloat(childViewControllers.count)
        //将向内缩进的宽度减小，能够让按钮的宽度变大，盖住容错点
        let w = tabBar.bounds.width / count - 1
        
        //CGRectInset 整数向内缩进，负数向外扩展
        composeBtn.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        
        composeBtn.addTarget(self, action:#selector(composeStatus), for: .touchUpInside)
    }
    
    func setUpChildController() {
            
        let array = [
          ["clsName":"MJHomeViewController","title":"首页","imageName":"home"],
          ["clsName":"MJMessageViewController","title":"消息","imageName":"message_center"],
          ["clsName":"UIViewcontroller"],
          ["clsName":"MJDisCoverViewController","title":"发现","imageName":"discover"],
          ["clsName":"MJPrefileViewController","title":"我","imageName":"profile"],
        ]
        
        var arrM = [UIViewController]()
        for dict in array {
           arrM.append(controller(dict: dict))
        }
        
        viewControllers = arrM
            
        }
    /// 使用字典创建控制器
    /// - parameter dict:信息字典[clsName ,title ,imageName]
    /// - returns : 子控制器
    private func controller(dict:[String:String]) -> UIViewController {
        
        guard let clsName = dict["clsName"],
            let title = dict["title"],
            let imageName = dict["imageName"],
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type
            else {
                return UIViewController()
        }
        
        let vc = cls.init()
        vc.title = title
        
        //设置图像
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named:"tabbar_" + imageName + "_selected" )?.withRenderingMode(.alwaysOriginal)
        
        //设置字体颜色（大小）
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orange], for: .highlighted)
        //默认为 ：12
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 13)], for: UIControlState(rawValue: 0))
        let nav = MJNavigationController(rootViewController: vc)
        return nav
        
    }
    
}

