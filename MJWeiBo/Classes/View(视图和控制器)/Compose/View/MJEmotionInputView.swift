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
    @IBOutlet weak var toolBar: MJEmotionToolBar!
    /// 分页控件
    @IBOutlet weak var pageControl: UIPageControl!
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
        
        //设置工具栏代理
        toolBar.delegate = self
        
        ///----------设置分页控件的图片
//        print("%@",UIPageControl.cz_ivarsList())
        
        let bundle = MJEmoticonManager.shared.bundle
        
        guard let normalImage = UIImage(named: "compose_keyboard_dot_normal", in: bundle, compatibleWith: nil),
        let selectImage = UIImage(named: "compose_keyboard_dot_selected", in: bundle, compatibleWith: nil) else {
            return
        }
        //使用KVC 设置私有成员属性
        pageControl.setValue(normalImage, forKey: "_pageImage")
        pageControl.setValue(selectImage, forKey: "_currentPageImage")
    }
}


// MARK: - toolBar 代理协议
extension MJEmotionInputView:MJEmotionToolBarDelegate{
    
    func MJEmotionToolBarDidSelectedWithIndex(toolBar: MJEmotionToolBar, index: Int) {
//        print(index)
        let indexPath = IndexPath(item: 0, section: index)
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        /// 回传分组索引
        toolBar.selectedIndex = index
    }
}

extension MJEmotionInputView:UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //获取中心点
        var center = scrollView.center
        center.x += scrollView.contentOffset.x
        
        let paths = collectionView.indexPathsForVisibleItems
        
        var targetIndexPath : IndexPath?
        for indexPath in paths {
            let cell = collectionView.cellForItem(at: indexPath)
            
            if cell?.frame.contains(center) == true {
                targetIndexPath = indexPath
                break
            }
        }
        
        guard let target = targetIndexPath else {
            return
        }
        
        toolBar.selectedIndex = target.section
        
        //设置分页
        pageControl.numberOfPages = collectionView.numberOfItems(inSection: target.section)
        pageControl.currentPage = target.item

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
        
        guard let em = em else {
            return
        }
        
        let indexPath = collectionView.indexPathsForVisibleItems[0]
        if indexPath.section == 0 {
            return
        }
        
        //添加最近使用的表情
        MJEmoticonManager.shared.recentEmoticon(em: em)
        // 刷新数据
        var indexSet = IndexSet()
        indexSet.insert(0)
        collectionView.reloadSections(indexSet)
    }
}
