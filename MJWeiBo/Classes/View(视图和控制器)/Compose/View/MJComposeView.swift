//
//  MJComposeView.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/4/26.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit
import pop
class MJComposeView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var returnBtn: UIButton!
    //返回按钮布局
    @IBOutlet weak var returnBtnCons: NSLayoutConstraint!
    //关闭按钮布局
    @IBOutlet weak var closeBtnCons: NSLayoutConstraint!
    
    fileprivate let infoArr = [["imageName":"tabbar_compose_idea","title":"文字","clsName":"MJComposeController"],["imageName":"tabbar_compose_photo","title":"照片/视频"],["imageName":"tabbar_compose_weibo","title":"长微博"],["imageName":"tabbar_compose_lbs","title":"签到"],["imageName":"tabbar_compose_review","title":"点评"],["imageName":"tabbar_compose_more","title":"更多","actionName":"clickMore"],["imageName":"tabbar_compose_transfer","title":"好友圈"],["imageName":"tabbar_compose_wbcamera","title":"微博相机"],["imageName":"tabbar_compose_music","title":"音乐"],["imageName":"tabbar_compose_shooting","title":"拍摄"]]
    
    //动画完成回调Block
    fileprivate var completionBlock:((_ clsName:String?)->())?
    
    class func composeView() -> MJComposeView {
        
        let nib = UINib(nibName: "MJComposeView", bundle: nil)
        
        //xib 加载完成视图，就会调用 awakeFromNib
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! MJComposeView
        return v
    }
    
    override func awakeFromNib() {
        setupUI()
    }
    
    //显示视图
    //OC中的block 如果当前方法，不能执行，通常使用属性记录，在需要的时候执行
    func show(completion:@escaping (_ clsName:String?)->()) {
        
        completionBlock = completion
        //尽量不要总是把视图添加到window上
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        vc.view.addSubview(self)
        
        showCurrentView()
    }
    /// 关闭按钮事件
    @IBAction func close(_ sender: Any) {
        
//        removeFromSuperview()
        hideBtns()
    }
    
    /// 返回按钮事件
    @IBAction func returnClick(_ sender: Any) {
        
        scrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
    
        closeBtnCons.constant = 0
        returnBtnCons.constant = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
            self.returnBtn.alpha = 0
        }, completion: { (_) in
            self.returnBtn.isHidden = true
            self.returnBtn.alpha = 1
        })
    }
    ///按钮监听方法
    @objc fileprivate func clickBtn(selectedBtn:MJComposeBtn) {
//        print("点击 \(btn)")
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        for (i,btn2) in v.subviews.enumerated() {
            //放大、缩小动画
            let scaleAnim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            let scale = (selectedBtn == btn2) ? 2 : 0.3
            let value = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            scaleAnim.toValue = value
            scaleAnim.duration = 0.5
            btn2.pop_add(scaleAnim, forKey: nil)
            
            //透明度动画
            let alphaAnim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnim.toValue = 0.3
            alphaAnim.duration = 0.5
            btn2.pop_add(alphaAnim, forKey: nil)
            
            //添加动画监听，时间是一样的，随便监听一个就好
            if i==0 {
                alphaAnim.completionBlock = {_,_ in
                    print("动画完成")
                    self.completionBlock?(selectedBtn.clsName)
                }
            }
        }
        
        
    }
    /// 跟多按钮监听方法
    @objc fileprivate func clickMore(){
        
        scrollView.setContentOffset(CGPoint(x:scrollView.bounds.width,y:0), animated: true)
        
        returnBtn.isHidden = false
        
        let margin = scrollView.bounds.width / 6
        closeBtnCons.constant += margin
        returnBtnCons.constant -= margin
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }

}
///pop 动画
private extension MJComposeView{
    //MARK: 隐藏按钮
    func hideBtns() {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        for (i,btn) in v.subviews.enumerated().reversed() {
            //反向遍历
            let anim:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = btn.center.y
            anim.toValue = btn.center.y + 400
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(v.subviews.count - i) * 0.025
            
            btn.pop_add(anim, forKey: nil)
            
            if i==0 {
                //动画完成
                anim.completionBlock = {(_,_) in
                    self.hideCurrentView()
                }
            }
            
        }
    }
    
    func hideCurrentView() {
        let anim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = 0.25
        pop_add(anim, forKey: nil)
        
        anim.completionBlock = {_,_ in
            self.removeFromSuperview()
        }
    }
    
    //MARK: 显示按钮
    func showCurrentView() {
        
        let anim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.25
        pop_add(anim, forKey: nil)
        
        showBtns()
    }
    ///弹力显示所有按钮
    func showBtns() {
        
        let v = scrollView.subviews[0]
        //遍历view中所有按钮
        for (i,btn) in v.subviews.enumerated() {
            
            let anim:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = btn.center.y + 400
            anim.toValue = btn.center.y
            // 弹力系数 [0, 20]. Defaults to 4.
            anim.springBounciness = 8
            anim.springSpeed = 8
            
            //设置动画启动时间
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            
            btn.pop_add(anim, forKey: nil)
        }
    }
}

/// private 让extension中所有方法都是私有
private extension MJComposeView{
    
    func setupUI() {
        
        let rect = scrollView.bounds
        for i in 0..<2 {
            let vi = UIView(frame: rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0))
            addBtns(v: vi, idx: i * 6)
            scrollView.addSubview(vi)
        }
        
        scrollView.contentSize = CGSize(width: rect.width * 2, height: 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        
        scrollView.isScrollEnabled = false
    }
    
    ///向 V 中添加视图，按钮的数组索引 从 idx 开始
    func addBtns(v:UIView,idx:Int) {
        
        let count = 6
        for i in idx..<(idx+count) {
            
            if i >= infoArr.count {
                break
            }
            
            let dict = infoArr[i]
            guard let imageName = dict["imageName"] , let title = dict["title"] else {
                continue
            }
            let btn = MJComposeBtn.composeBtn(imageName: imageName, title: title)
            v.addSubview(btn)
            
            if let actionName = dict["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }else{
                btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
            }
            //设置要展现的类名
            btn.clsName = dict["clsName"]
        }
        
        /// 布局按钮
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (v.bounds.width - 3 * btnSize.width)/4
        for (i,btn) in v.subviews.enumerated() {
            
            let y:CGFloat = (i > 2) ? (v.bounds.height - btnSize.height) : 0
            let col = i % 3
            let x = CGFloat(col+1) * margin + CGFloat(col) * btnSize.width
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
        }
    }
}
