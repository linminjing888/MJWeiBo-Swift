//
//  AppDelegate.swift
//  MJWeiBo
//
//  Created by YXCZ on 16/12/16.
//  Copyright © 2016年 林民敬. All rights reserved.
//  ----------27------------------

import UIKit
import UserNotifications
import SVProgressHUD
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupAdditions()
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = MJMainTabbarController()
        window?.makeKeyAndVisible()
        
        loadAppInfo()
        return true
        
    }
    
    //设置设备方向
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }

}

///设置应用额外信息
extension AppDelegate{
    fileprivate func setupAdditions(){
        //1.设置SVProgressHUD显示最小时间
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        //2.网络加载指示器
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        //3.获取用户授权显示通知
        // #available 自动检测设备版本
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge,.carPlay]) { (success, error) in
                print("授权" + (success ? "成功" : "失败"))
            }
        } else {
            let notifySettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            //Application 为单例
            UIApplication.shared.registerUserNotificationSettings(notifySettings)
        }
    }
}

///从服务器加载应用信息
extension AppDelegate{
    
    //动态加载app 信息
    func loadAppInfo(){
        DispatchQueue.global().async {
            
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
            let data = NSData(contentsOf: url!)
            //写入沙盒 下次启动时使用
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
            data?.write(toFile: jsonPath, atomically: true)
            
            print("应用信息加载完成 \(jsonPath)")
        }
        
    }
}


