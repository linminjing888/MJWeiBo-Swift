//
//  MJMainTabbarController.swift
//  MJWeiBo
//
//  Created by YXCZ on 16/12/16.
//  Copyright © 2016年 林民敬. All rights reserved.
//  ---------------33

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
        
//        let vc = UIViewController()
//        
//        let nav  = UINavigationController(rootViewController: vc)
//        
//        
//        present(nav, animated: true, completion: nil)
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
        
        //很多应用程序中，界面的创建都依赖于网络的 json
        let array = [
          ["clsName":"MJHomeViewController","title":"首页","imageName":"home","visitorInfo":["imageName":"","message":"关注一些人，有惊喜"]],
          
          ["clsName":"MJMessageViewController","title":"消息","imageName":"message_center","visitorInfo":["imageName":"visitordiscover_image_message","message":"登录后，这里可以收到通知"]],
          
          ["clsName":"UIViewcontroller"],
          
          ["clsName":"MJDisCoverViewController","title":"发现","imageName":"discover","visitorInfo":["imageName":"visitordiscover_image_message","message":"登录后，不会在与事实擦肩而过"]],
          ["clsName":"MJPrefileViewController","title":"我","imageName":"profile","visitorInfo":["imageName":"visitordiscover_image_profile","message":"登录后，你将会展示给别人"]],
        ]
        
        //测试数据格式是否正确 - 转换成Plist文件
        (array as NSArray).write(toFile: "/Users/lmj/Desktop/demo.plist", atomically: true)
        
        var arrM = [UIViewController]()
        for dict in array {
           arrM.append(controller(dict: dict as [String : AnyObject]))
        }
        
        viewControllers = arrM
            
        }
    /// 使用字典创建控制器 反射
    /// - parameter dict:信息字典[clsName ,title ,imageName,visitorInfo]
    /// - returns : 子控制器
    private func controller(dict:[String:AnyObject]) -> UIViewController {
        
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? MJBaseViewController.Type,
        let visitorDic = dict["visitorInfo"] as? [String:String]
        
            else {
                return UIViewController()
        }
        
        //创建视图控制器
        let vc = cls.init()
        vc.title = title
        
        //设置访客视图
        vc.visitorInfoDic = visitorDic
        
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

