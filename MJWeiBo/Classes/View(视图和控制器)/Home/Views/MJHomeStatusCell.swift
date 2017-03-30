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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
