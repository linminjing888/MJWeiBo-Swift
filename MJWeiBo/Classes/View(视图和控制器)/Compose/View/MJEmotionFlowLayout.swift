//
//  MJEmotionFlowLayout.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/6/6.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

class MJEmotionFlowLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        itemSize = collectionView.bounds.size
        //设定滚动方向
        //水平方向滚动，cell垂直方向布局
        scrollDirection = .horizontal
    }
}
