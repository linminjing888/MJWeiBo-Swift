//
//  MJStatusToolBar.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/3/31.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

class MJStatusToolBar: UIView {

    /// 转发
    @IBOutlet weak var repostBtn: UIButton!
    /// 评论
    @IBOutlet weak var commentBtn: UIButton!
    /// 表态
    @IBOutlet weak var likeBtn: UIButton!
    
    var viewModel:MJStatusViewModel?{
        didSet{
            
            repostBtn.setTitle(viewModel?.repostStr, for: [])
            commentBtn.setTitle(viewModel?.commentStr, for: [])
            likeBtn.setTitle(viewModel?.likeStr, for: [])

        }
    }

}
