//
//  MJComposeTextView.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/5/19.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

class MJComposeTextView: UITextView {

    //占位符
    fileprivate lazy var textLabel = UILabel()
    
    override func awakeFromNib() {
        
        self.setupUI()
    }

    @objc fileprivate func textDidChange()  {
        //如果有文本就不显示占位符
        textLabel.isHidden = self.hasText
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    ///计算表情文字
    var emoticonText : String{
        guard let attrStr = attributedText else {
            return ""
        }
        var result = String()
        attrStr.enumerateAttributes(in: NSMakeRange(0, attrStr.length), options:[],  using: { (dict, range, _) in
            
            //            print(dict)
            //            print(range.location)
            //            print(range.length)
            if let attachment = dict["NSAttachment"] as? MJEmoticonAttachment{
                result += attachment.chs ?? ""
            }else{
                let subStr = (attrStr.string as NSString).substring(with: range)
                result += subStr
            }
        })
        
        return result
    }
    
    //向文本视图，插入表情符号
    func insertEmotiicon(em:MJEmoticon?) {
        //em==nil 是删除按钮
        guard em != nil else {
            deleteBackward()
            return
        }
        // emoji 字符串
        if let emoji = em?.emoji,let textRange = selectedTextRange {
            // UITextRange 仅用于此处
            replace(textRange, withText: emoji)
            return
        }
        
        //获取表情中的图像属性文本
        let imageText = em?.imageText(font: font!)
        //获取当前textView属性文本 可变的
        let attrStrM = NSMutableAttributedString(attributedString: attributedText)
        //将图像的属性文本插入到当前的光标位置
        attrStrM.replaceCharacters(in: selectedRange, with: imageText!)
        //记录光标位置
        let range = selectedRange
        //设置文本
        attributedText = attrStrM
        
        //恢复光标位置，length是选中字符的长度，插入文本之后，应该为0
        selectedRange = NSMakeRange(range.location+1, 0)
        
        delegate?.textViewDidChange?(self)
        //执行当前对象 的文本变化方法
        textDidChange()
    }
}

extension MJComposeTextView{
    
    func setupUI() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
        textLabel.text = "分享新鲜事..."
        textLabel.font = self.font
        textLabel.textColor = UIColor.lightGray
        textLabel.sizeToFit()
        
        textLabel.frame.origin = CGPoint(x: 5, y: 8)
        
        self.addSubview(textLabel)
    }
}
