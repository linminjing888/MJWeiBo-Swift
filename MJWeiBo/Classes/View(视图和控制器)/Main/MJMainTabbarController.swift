//
//  MJMainTabbarController.swift
//  MJWeiBo
//
//  Created by YXCZ on 16/12/16.
//  Copyright © 2016年 林民敬. All rights reserved.
//  -----------------33------------------

import UIKit
import SVProgressHUD

class MJMainTabbarController: UITabBarController {

    
    fileprivate var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpChildController()
        setUpcomposeButton()
        setUpTimer()
        
        setupNewFeature()
        
        delegate = self
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLogon), name: NSNotification.Name(rawValue: MJUserShouldLoginNotification), object: nil)
        
    }
    
    // MARK: 监听方法
    @objc fileprivate func userLogon(n:Notification){
        //判断 n.object是否有值，如有，token过期，提示用户重新登录
        
        var time = DispatchTime.now()
        if n.object != nil{
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "用户登录已经超时，需要重新登录")
            time = DispatchTime.now()+2
        }
        
        DispatchQueue.main.asyncAfter(deadline:time) {
            SVProgressHUD.setDefaultMaskType(.clear)
            let nav = UINavigationController(rootViewController: MJOAuthViewController())
            
            self.present(nav, animated: true, completion: nil)
        }
    }
    
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
    
    deinit {
        timer?.invalidate()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

/// 设置新特性
extension MJMainTabbarController{
    fileprivate func setupNewFeature() {
        
        ///如果没登陆就不显示新特性
        if !MJNetworkManager.shared.userLogon {
            return
        }
        
        let vi = isNewVersion ? MJNewFeatureView.newFeatureView() : MJWelcomeView.welcomeView()
        view.addSubview(vi)
    }
    
    ///构造函数：给属性分配空间 （计算型属性）
    fileprivate var isNewVersion :Bool{
        
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        //去保存在 Document 目录中的版本号
        let path = ("version" as NSString).cz_appendDocumentDir() ?? ""
        
        let sandboxVersion = (try? String(contentsOfFile: path)) ?? ""
        
        try? currentVersion?.write(toFile: path, atomically: true, encoding: .utf8)

        print(path)
        
        return currentVersion != sandboxVersion
    }
    
}

extension MJMainTabbarController{
    func setUpTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer(){
        
        if !MJNetworkManager.shared.userLogon {
            return
        }
        
        MJNetworkManager.shared.unreadCount { (count) in
            print("\(count) 条新微博")
            self.tabBar.items?[0].badgeValue = count>0 ? "\(count)" :nil
            
            //需要申请通知权限
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}

extension MJMainTabbarController:UITabBarControllerDelegate{
    
    //将要切换 tabbarItem
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        
        print(" 切换到 \(viewController)")
        let idx = (childViewControllers as NSArray).index(of: viewController)
        
        //当前索引是首页，同时idx 也是首页，重复点击首页按钮
        if selectedIndex == 0 && idx == selectedIndex {
            
            let nav = childViewControllers[0] as! MJNavigationController
            let vc = nav.childViewControllers[0] as! MJHomeViewController
            //表格滚动到原点
            vc.tableView?.setContentOffset(CGPoint(x:0,y:-64), animated: true)
            //刷新数据
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                vc.loadData()
            })
            //清除tabbarItem 的badge
            vc.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
            
        }
        
        
        // isMember 是这个类，且不包含子类
        return !viewController.isMember(of: UIViewController.self)
    }
}

extension MJMainTabbarController{
    
    //设置撰写按钮
    func setUpcomposeButton()  {
        tabBar.addSubview(composeBtn)
        
        let count = CGFloat(childViewControllers.count)
        //将向内缩进的宽度减小，能够让按钮的宽度变大，盖住容错点
        //用代理方法的话 可以不减少宽度
        let w = tabBar.bounds.width / count - 1
        
        //CGRectInset 整数向内缩进，负数向外扩展
        composeBtn.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        
        composeBtn.addTarget(self, action:#selector(composeStatus), for: .touchUpInside)
    }
    
    func setUpChildController() {
        
        //获取沙盒json 路径
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
        // 加载data
        var data = NSData(contentsOfFile: jsonPath)
        
        //判断json 是否有内容
        if data == nil {
            
            //从bundle 加载配置的 json
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
        }
        
        //反序列化转换成数组  throw 抛出异常
        //try ? 如果解析成功，就有值，否则，为nil
        guard let array = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as? [[String:AnyObject]]
            else {
            return
        }
        
        //很多应用程序中，界面的创建都依赖于网络的 json
//        let array = [
//          ["clsName":"MJHomeViewController","title":"首页","imageName":"home","visitorInfo":["imageName":"","message":"关注一些人，有惊喜"]],
//          
//          ["clsName":"MJMessageViewController","title":"消息","imageName":"message_center","visitorInfo":["imageName":"visitordiscover_image_message","message":"登录后，这里可以收到通知"]],
//          
//          ["clsName":"UIViewcontroller"],
//          
//          ["clsName":"MJDisCoverViewController","title":"发现","imageName":"discover","visitorInfo":["imageName":"visitordiscover_image_message","message":"登录后，不会在与事实擦肩而过"]],
//          ["clsName":"MJPrefileViewController","title":"我","imageName":"profile","visitorInfo":["imageName":"visitordiscover_image_profile","message":"登录后，你将会展示给别人"]],
//        ]
//
        
        //测试数据格式是否正确 - 转换成Plist文件
//        (array as NSArray).write(toFile: "/Users/lmj/Desktop/demo.plist", atomically: true)
        
        //数组 -> json 序列化
//        let data = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
//        (data as NSData).write(toFile: "/Users/lmj/Desktop/demo.json", atomically: true)
        
        var arrM = [UIViewController]()
        for dict in array! {
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

