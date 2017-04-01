//
//  MJCommon.swift
//  MJWeiBo
//
//  Created by YXCZ on 16/12/30.
//  Copyright © 2016年 林民敬. All rights reserved.
//

import Foundation



let MJAPPKEY = "292051871"

let MJAPPSECRET = "8625be95d57d920566f3678a644cc4df"

let MJREDIRECTURL = "http://www.hao123.com"

///用户需要登录通知
let MJUserShouldLoginNotification = "MJUserShouldLoginNotification"

///用户登录成功通知
let MJUserLoginSuccessNotification = "MJUserLoginSuccessNotification"


// MARK : 微博配图视图常量
//外部间距
let WBStatusPictureOutterMargin = CGFloat(12)
//内部间距
let WBStatusPictureInnerMargin = CGFloat(3)
//视图宽度
let WBStatusPictureViewWidth = UIScreen.cz_screenWidth() - 2 * WBStatusPictureOutterMargin
//图片Item默认宽度
let WBstatusPictureItemWidth = (WBStatusPictureViewWidth - 2 * WBStatusPictureInnerMargin)/3
