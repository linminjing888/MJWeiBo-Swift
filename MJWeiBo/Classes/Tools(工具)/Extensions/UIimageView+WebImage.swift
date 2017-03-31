//
//  UIimageView+WebImage.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/3/31.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import SDWebImage

extension UIImageView{
    
    
    /// 隔离 SDWebImage
    ///
    /// - Parameters:
    ///   - urlString: urlString
    ///   - placeholderImage: 占位图像
    ///   - isAvatar: 是否是头像
    
    func mj_setImage(urlString:String?,placeholderImage:UIImage?,isAvatar:Bool = false) {
        
        guard let urlString = urlString,
            let url = URL(string:urlString) else {
            
            image = placeholderImage
            return
        }
        
        sd_setImage(with: url, placeholderImage: placeholderImage, options: []) { [weak self] (image, _, _, _) in
            
            //判断是否是头像
            if isAvatar{
                self?.image = image?.mj_avatarImage(size: self?.bounds.size)
            }
        }

    }
}
