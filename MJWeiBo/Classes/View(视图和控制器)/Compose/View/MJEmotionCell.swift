//
//  MJEmotionCell.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/6/6.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit


@objc protocol MJEmotionCellDelegate:NSObjectProtocol{
    
    func MJEmotionCellDidSelectedEmoticon(cell:MJEmotionCell,em:MJEmoticon?)
}
/// 表情界面的cell
/// 每一个cell和collectionView一样的大小
/// 每一个cell中用九宫格的算法，自行添加20个表情
/// 最后一个位置防止删除按钮
class MJEmotionCell: UICollectionViewCell {
    ///代理
    weak var delegate:MJEmotionCellDelegate?
    var emoticons:[MJEmoticon]? {
        didSet{
            print("表情包\(emoticons?.count)")
            
            for v in contentView.subviews {
                v.isHidden = true
            }
            contentView.subviews.last?.isHidden = false
            for (i,em) in (emoticons ?? []).enumerated() {
                
                if let btn = contentView.subviews[i] as? UIButton {
                    //设置图像--如果image为nil，会清空图像，避免cell复用
                    btn.setImage(em.image, for: [])
                    //设置emoji表情 - 如果title为nil，会清空title，避免cell复用
                    btn.setTitle(em.emoji, for: [])
                    btn.isHidden = false
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func selectedBtnEmoticon(button:UIButton) {
        
        let tag = button.tag
        var em:MJEmoticon?
        if tag < (emoticons?.count)! {
            em = emoticons?[tag]
        }
        
        //em 选中的模型 ，如果为nil 对应的是删除按钮
//        print(em)
        delegate?.MJEmotionCellDidSelectedEmoticon(cell: self, em: em)
        
    }
//    override func awakeFromNib() {
//        setupUI()
//    }
}

extension MJEmotionCell{
    
    // - 从XIB加载 bounds 是XIB 中定义的大小，不是size的大小
    // - 从纯代码创建，bounds 就是布局属性中设置的 itemsize
    func setupUI() {
        
        let rowCount = 3
        let colCount = 7
        
        let leftMargin:CGFloat = 8
        let bottomMargin:CGFloat = 16
        
        let w = (bounds.width - 2 * leftMargin)/CGFloat(colCount)
        let h = (bounds.height - bottomMargin)/CGFloat(rowCount)
        
        for i in 0..<21 {
            
            let row = i / colCount
            let col = i % colCount
            
            let btn = UIButton()
            let x = leftMargin + CGFloat(col) * w
            let y = h * CGFloat(row)
            btn.frame = CGRect(x: x, y: y, width: w, height: h)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            contentView.addSubview(btn)
            
            btn.tag = i
            btn.addTarget(self, action: #selector(selectedBtnEmoticon(button:)), for: .touchUpInside)
        }
        
        let btn = contentView.subviews.last as! UIButton
        let image = UIImage(named: "compose_emotion_delete_highlighted", in: MJEmoticonManager.shared.bundle, compatibleWith: nil)
        btn.setImage(image, for: [])
        
    }
}
