//
//  MJEmotionInputView.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/6/5.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

fileprivate let cellID = "cellID"

class MJEmotionInputView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBar: UIView!
    
    fileprivate var selectedEmoticonCallBack:((_ emoticon:MJEmoticon?)->())?
    class func inputView(selectedEmoticon:@escaping (_ emoticon:MJEmoticon?)->()) -> MJEmotionInputView {
        
        let nib = UINib(nibName: "MJEmotionInputView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! MJEmotionInputView
        v.selectedEmoticonCallBack = selectedEmoticon
        
        return v
    }
    
    override func awakeFromNib() {
        
//        let nib = UINib(nibName: "MJEmotionCell", bundle: nil)
//        collectionView.register(nib, forCellWithReuseIdentifier: cellID)
        collectionView.register(MJEmotionCell.self, forCellWithReuseIdentifier: cellID)
    }
}


extension MJEmotionInputView:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MJEmoticonManager.shared.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MJEmoticonManager.shared.packages[section].numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MJEmotionCell
        
        cell.emoticons = MJEmoticonManager.shared.packages[indexPath.section].emoticons(page: indexPath.item)
        cell.delegate = self
        
        return cell
    }
}

extension MJEmotionInputView:MJEmotionCellDelegate{
    func MJEmotionCellDidSelectedEmoticon(cell: MJEmotionCell, em: MJEmoticon?) {
//        print(em)
        selectedEmoticonCallBack?(em)
    }
}
