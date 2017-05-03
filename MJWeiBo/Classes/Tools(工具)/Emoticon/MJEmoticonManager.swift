//
//  MJEmoticonManager.swift
//  图文混编-表情
//
//  Created by YXCZ on 17/5/2.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

class MJEmoticonManager {
    
    ///表情管理器的单例
    static let shared = MJEmoticonManager()
    ///表情包懒加载数组
    lazy var packages = [MJMoticonPackage]()
    
    /// 构造函数 ，如果在 init 之前增加 private修饰符，可以让调用着必须通过 shared 访问对象
    /// OC 要重写 allocWithZone 方法
    private init(){
        loadPackages()
    }
}

// MARK: -- 表情字符串的处理
extension MJEmoticonManager{
    
    /// 将给定的子字符串转换成属性文本
    ///
    /// - Parameter string: 完整字符串
    /// - Returns: 属性文本
    func emoticonString (string:String , font:UIFont) -> NSAttributedString {
        
        let attrString = NSMutableAttributedString(string: string)
        
        //建立正则表达式，过滤所有的表情文字
        // [] () 都是正则表达式关键字 如果参与匹配，需要转义
        let pattern = "\\[.*?\\]"
        
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return attrString
        }
        // 匹配所有项
        let matches = regx.matches(in: string, options: [], range: NSRange(location: 0, length: attrString.length))
        
        // 遍历所有匹配结果  倒序替换属性文本
        for m in matches.reversed() {
            
            let r = m.rangeAt(0)
//            print(r.location)
//            print(r.length)
            let subStr = (attrString.string as NSString).substring(with: r)
            // 查找对应的表情符号
            if let em = MJEmoticonManager.shared.findEmoticons(string: subStr) {
                //使用表情符号的属性文本，替换原有的属性文本内容
                attrString.replaceCharacters(in: r, with: em.imageText(font: font))
            }
//            print(subStr)
            //统一设置一遍字符串的属性:字体 颜色
            attrString.addAttributes([NSFontAttributeName:font], range: NSRange(location: 0, length: attrString.length))
            
        }
        
        return attrString
        
    }
    
    // 根据 string 在所有的表情符号中查找对应的表情模型对象
    func findEmoticons(string:String) -> MJEmoticon? {
        //遍历表情包
        for p in packages {
            //在表情包中过滤 string
            //方法1
//            let results = p.emoticons.filter({ (em) -> Bool in
//                return em.chs == string
//            })
            //方法2 尾随闭包
//            let results = p.emoticons.filter() { (em) -> Bool in
//                return em.chs == string
//            }
            
            //方法3 如果闭包中只有一句，并且是返回
            //1. 闭包格式定义可以省略
            //2. 参数省略之后，使用$0,$1....一次代替所有参数
//            let results = p.emoticons.filter() {
//                return $0.chs == string
//            }
            
            //方法4 如果闭包中只有一句，并且是返回
            //1. 闭包格式定义可以省略
            //2. 参数省略之后，使用$0,$1....一次代替所有参数
            //3. return 也可以省略
            let results = p.emoticons.filter() { $0.chs == string }

            if results.count==1 {
                return results[0]
            }
        }
        return nil
    }
}
// MARK: -- 表情包数据的处理
private extension MJEmoticonManager{
    
    func loadPackages() {
        
        //读取 emoticons.plist 只要按照bundle 默认的目录结构设定，就可以直接读取 Resource 目录下的文件
        guard let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path),
            let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
            let array = NSArray(contentsOfFile: plistPath) as? [[String:String]],
            let models = NSArray.yy_modelArray(with: MJMoticonPackage.self, json: array) as? [MJMoticonPackage]
            
            else{
                
            return
        }
        //设置表情包数据
        //用 += 不需要在次给 packages 分配空间，直接追加数据
        packages += models
        
        print(packages)
        
    }
}
