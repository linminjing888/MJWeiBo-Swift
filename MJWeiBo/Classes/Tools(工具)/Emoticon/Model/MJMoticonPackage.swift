
//
//  MJMoticonPackage.swift
//  图文混编-表情
//
//  Created by YXCZ on 17/5/2.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

class MJMoticonPackage: NSObject {

    ///表情包分组名
    var groupName: String?
    ///toolBar 背景图
    var bgImageName:String?
    
    ///目录 从目录下加载 info.plist 可以创建表情模型数组
    var directory:String?{
        didSet{
            guard let directory = directory,
                let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
                let bundle = Bundle(path: path),
                let infoPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
                let array = NSArray(contentsOfFile: infoPath) as? [[String:String]],
                let models = NSArray.yy_modelArray(with: MJEmoticon.self, json: array) as? [MJEmoticon]else {
                return
            }
            
            for m in models {
                m.directory = directory
            }
//            print(models)
            //设置表情模型数组
            emoticons += models
            
        }
    }
    
    ///懒加载的表情模型空数组
    ///使用懒加载可以避免后续的解包
    lazy var emoticons = [MJEmoticon]()
    
    override var description: String{
        return yy_modelDescription()
    }
    
}
