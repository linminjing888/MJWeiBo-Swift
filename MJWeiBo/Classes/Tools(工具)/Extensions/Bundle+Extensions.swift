//
//  Bundle+Extensions.swift
//  反射机制
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 itcast. All rights reserved.
//

import Foundation

extension Bundle {

    // 计算型属性类似于函数，没有参数，有返回值
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}

/*
let infoDict = NSBundle.mainBundle().infoDictionary
if let info = infoDict? {
    // app名称
    let appName = info["CFBundleName"] as String!
    // app版本
    let appVersion = info["CFBundleShortVersionString"] as String!
    // app build版本
    let appBuild = info["CFBundleVersion"] as String!
}
 */
