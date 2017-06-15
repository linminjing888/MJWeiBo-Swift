//
//  MJEmoticon.swift
//  图文混编-表情
//
//  Created by YXCZ on 17/5/2.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit
import YYModel

class MJEmoticon: NSObject {

    /// 表情类型 false--图片 / true--emoji
    var type = false
    /// 表情文字
    var chs: String?
    ///表情图片名称
    var png: String?
    ///emoji的十六进制编码
    var code: String?{
        didSet{
            guard let code = code else {
                return
            }
            //实例化字符串扫描
            let scanner = Scanner(string: code)
            //从code中扫描十六机制的数值
            var result : UInt32 = 0
            scanner.scanHexInt32(&result)
            //使用 UInt32的数组，生成一个UTF8的字符
            let c = Character(UnicodeScalar(result)!)
            emoji = String(c)
        }
    }
    
    // emoji 的字符串
    var emoji:String?
    /// 图片路径
    var directory:String?
    ///计算型属性
    var image:UIImage?{
        if type {
            return nil
        }
        
        guard let directory = directory,
            let png = png,
            let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path)
            else {
            return nil
        }
        
        return UIImage(named:"\(directory)/\(png)", in: bundle, compatibleWith: nil)
        
    }
    
    func imageText(font:UIFont) -> NSAttributedString {
        //判断图像是否存在
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        //创建文本附件
        let attachment = MJEmoticonAttachment()
        attachment.chs = chs
        attachment.image = image
        let height = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        //返回图片文本属性
        let attriStrM = NSMutableAttributedString(attributedString:NSAttributedString(attachment: attachment))
        //插入字符的显示，跟随前一个字符的属性，但是本身没有属性
        //设置图像文字的属性
        attriStrM.addAttributes([NSFontAttributeName:font], range: NSMakeRange(0, 1))
        
        return attriStrM
        
    }
    
    
    override var description: String{
        return yy_modelDescription()
    }
    
}
