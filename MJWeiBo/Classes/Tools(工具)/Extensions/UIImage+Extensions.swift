//
//  UIImage+Extensions.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/3/30.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import Foundation


import UIKit

extension UIImage{
    
    func mj_avatarImage(size:CGSize?, backColor:UIColor = UIColor.white,lineColor:UIColor = UIColor.lightGray) -> UIImage? {
        
        var size = size
        if size == nil {
            size = self.size
        }
        
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        //1.开始图像上下文，内存中开辟一个地址，跟屏幕无关
        /**
         1.size：绘图的尺寸
         2.不透明：false（透明） 、 true（不透明）
         3.scale：屏幕分辨率、默认生成的图像使用1.0的分辨率，图片质量不好
         可以指定0，会选择当前设备的屏幕分辨率
         */
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        //0>.背景填充
        backColor.setFill()
        UIRectFill(rect)
        //1>.实例化一个圆形路径
        let path = UIBezierPath(ovalIn: rect)
        //2>.进行路径剪切
        path.addClip()
        
        //2.绘图 drawInRect
        draw(in: rect)
        
        //0>. 绘制内切的圆形
        let ovalPath = UIBezierPath(ovalIn: rect)
        //        ovalPath.lineWidth = 2
        lineColor.setStroke()
        ovalPath.stroke()
        
        //3.取得结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        //4.关闭上下文
        UIGraphicsEndImageContext()
        //5.返回结果
        return result
    }
}
