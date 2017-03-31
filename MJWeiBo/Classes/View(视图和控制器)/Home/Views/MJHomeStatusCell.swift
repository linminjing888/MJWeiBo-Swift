//
//  MJHomeStatusCell.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/3/30.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

class MJHomeStatusCell: UITableViewCell {

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
    @IBOutlet weak var statusLabel: UILabel!
    ///
    @IBOutlet weak var toolBar: MJStatusToolBar!
    ///配图视图
    @IBOutlet weak var pictureView: MJStatusPictureView!
    ///配图视图 上面间距
    @IBOutlet weak var pictureTopCons: NSLayoutConstraint!
    
    var viewModel:MJStatusViewModel?{
        didSet{
            statusLabel.text = viewModel?.status.text
            nameLabel.text = viewModel?.status.user?.screen_name
            memberIconView.image = viewModel?.memberIcon
            vipIconView.image = viewModel?.vipIcon
            
            iconView .mj_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default"),isAvatar:true)
            
            //设置底部工具栏
            toolBar.viewModel = viewModel
            
            pictureView.heightCons.constant = 0
            pictureTopCons.constant = 0
            
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
