//
//  MJMeiRefreshView.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/4/26.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

class MJMeiRefreshView: MJRefreshView {

    @IBOutlet weak var buildingImage: UIImageView!
    @IBOutlet weak var earthImage: UIImageView!
    @IBOutlet weak var takeoutImage: UIImageView!
    
    
    /// 父视图高度
    override var parentHeight: CGFloat{
        didSet{
            // 28- 120
            // 0.2 - 1
            if parentHeight < 28 {
                return
            }
            var scale:CGFloat
            if parentHeight > 120 {
                scale = 1
            }else{
                scale = 1 - ((120-parentHeight)/(120-28))
            }
            takeoutImage.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    
    override func awakeFromNib() {
        
        let bImage1 = #imageLiteral(resourceName: "takeout_img_refresh_building_1")
        let bImage2 = #imageLiteral(resourceName: "takeout_img_refresh_building_2")
        buildingImage.image = UIImage.animatedImage(with: [bImage1,bImage2], duration: 0.5)
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = -2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 5
        anim.isRemovedOnCompletion = false
        earthImage.layer.add(anim, forKey: nil)
        
        //袋鼠
        let tImage1 = #imageLiteral(resourceName: "takeout_img_list_loading_pic1")
        let tImage2 = #imageLiteral(resourceName: "takeout_img_list_loading_pic2")
        takeoutImage.image = UIImage.animatedImage(with: [tImage1,tImage2], duration: 0.5)
        
        //1>设置锚点
        takeoutImage.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        //2>设置center
        let x = self.bounds.width * 0.5
        let y = self.bounds.height - 28
        takeoutImage.center = CGPoint(x: x, y: y)
    }
    
}
