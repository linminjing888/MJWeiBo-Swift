//
//  MJStatusPictureView.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/3/31.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

class MJStatusPictureView: UIView {

    ///配图视图高度
   @IBOutlet weak var heightCons:NSLayoutConstraint!
    
    
    var urls:[MJStatusPicture]? {
        didSet{
            
            // 隐藏视图数据
            for v in subviews {
                v.isHidden = true
            }
            
            var index = 0
            for url in urls ?? [] {
                //获取对应索引的 imageView
                let v = subviews[index] as! UIImageView
                
                //四张图的处理
                if index==1 && urls?.count == 4 {
                    index += 1
                }
                
                v.mj_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
                v.isHidden = false
                
                index += 1
            }
        }
    }
    
    
    override func awakeFromNib() {
        setupUI()
    }
}


extension MJStatusPictureView{
    
    
    fileprivate func setupUI() {
        
        backgroundColor = superview?.backgroundColor
        clipsToBounds = true
        
        //超出边界的内容不显示
        let count = 3
        let rect = CGRect(x: 0,
                          y: WBStatusPictureOutterMargin,
                          width: WBstatusPictureItemWidth,
                          height:WBstatusPictureItemWidth )
        
        for i in 0..<count * count {
            
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
            let row = CGFloat(i / count)
            let col = CGFloat(i % count)
            
            let xOffset = col * (WBstatusPictureItemWidth + WBStatusPictureInnerMargin)
            let yOffset = row * (WBstatusPictureItemWidth + WBStatusPictureInnerMargin)
            
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            
            addSubview(iv)
            
        }
    }
}
