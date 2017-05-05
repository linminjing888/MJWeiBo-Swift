//
//  MJHomeStatusCell.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/3/30.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit


/// 微博cell 的协议
/// 需要设置可选的协议方法
///-- 需要遵守 NSObjectProtocol 协议
///-- 协议需要时 @objc的
///-- 方法需要 @objc optional
@objc protocol MJHomeStatusCellDelegate:NSObjectProtocol {
    @objc optional func MJHomeStatusCellDidSelectedUrling(cell:MJHomeStatusCell,url:String)
}

class MJHomeStatusCell: UITableViewCell {

    ///代理属性
    weak var delegate: MJHomeStatusCellDelegate?
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    /// 名字
    @IBOutlet weak var nameLabel: UILabel!
    /// 会员图标
    @IBOutlet weak var memberIconView: UIImageView!
    ///时间
    @IBOutlet weak var timeLabel: UILabel!
    /// vip
    @IBOutlet weak var vipIconView: UIImageView!
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 正文
    @IBOutlet weak var statusLabel: FFLabel!
    ///
    @IBOutlet weak var toolBar: MJStatusToolBar!
    ///配图视图
    @IBOutlet weak var pictureView: MJStatusPictureView!
    ///转发微博文字  原创微博 无此字段 用 ？
    @IBOutlet weak var retweetTerxtLab: FFLabel?
    
    var viewModel:MJStatusViewModel?{
        didSet{
            nameLabel.text = viewModel?.status.user?.screen_name
            memberIconView.image = viewModel?.memberIcon
            vipIconView.image = viewModel?.vipIcon
            
            iconView .mj_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default"),isAvatar:true)
            
            //设置底部工具栏
            toolBar.viewModel = viewModel
            //图像视图
            pictureView.viewModel = viewModel
            
            statusLabel.attributedText = viewModel?.statusAttrText
            retweetTerxtLab?.attributedText = viewModel?.retweetAttrText
            //微博来源
            sourceLabel.text = viewModel?.status.source

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // 离屏渲染 -- 异步绘制
        self.layer.drawsAsynchronously = true
        
        //栅格化 异步绘制之后，会生成一张独立的图像，cell在屏幕上滚动的时候，本质上滚动的是这张图片
        // cell 优化，图层数量只有一层
        self.layer.shouldRasterize = true
        // 使用 栅格化 必须注意指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
        
        //设置微博文本代理
        statusLabel.delegate = self
        retweetTerxtLab?.delegate = self
        
    }
}

extension MJHomeStatusCell:FFLabelDelegate{
    
    func labelDidSelectedLinkText(_ label: FFLabel, text: String) {
        print(text)
        
        if !text.hasPrefix("http") {
            return
        }
        delegate?.MJHomeStatusCellDidSelectedUrling?(cell: self, url: text)
        
    }
}
