//
//  MJEmotionInputView.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/6/5.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

class MJEmotionInputView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBar: UIView!
    
    class func inputView() -> MJEmotionInputView {
        
        let nib = UINib(nibName: "MJEmotionInputView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! MJEmotionInputView
        
        return v
    }
}
