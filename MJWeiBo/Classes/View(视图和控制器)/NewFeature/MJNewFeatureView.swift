//
//  MJNewFeatureView.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/3/24.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

class MJNewFeatureView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBAction func BtnClicked(_ sender: UIButton) {
        removeFromSuperview()
    }
    
    class func newFeatureView() -> MJNewFeatureView {
        
        let nib = UINib(nibName: "MJNewFeatureView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! MJNewFeatureView
        // 从 xib 加载的视图 默认是 600 * 600
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let count = 4
        let rect = UIScreen.main.bounds
        
        for i in 0..<4 {
            let imgName = "new_feature_\(i+1)"
            let imgVi = UIImageView(image: UIImage(named: imgName))
            
            imgVi.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            scrollView.addSubview(imgVi)
        }
        
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        enterBtn.isHidden = true
        pageControl.numberOfPages = count
    }
}
extension MJNewFeatureView:UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        if page == scrollView.subviews.count {
            removeFromSuperview()
        }
        
        enterBtn.isHidden = (page != scrollView.subviews.count - 1)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        enterBtn.isHidden = true
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        pageControl.currentPage = page
        
        //分页控制器隐藏
        pageControl.isHidden = (page == scrollView.subviews.count)
    }
}
