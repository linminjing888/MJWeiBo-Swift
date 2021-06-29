//
//  MJStatusViewModel.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/3/30.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import Foundation

/// 单条微博的视图模型
/**
  如果没有任何父类，希望在开发时调试，输出数据信息，需要
 1.遵守 CustomStringConvertible 协议
 2.实现 description 计算型属性
 */
class MJStatusViewModel:CustomStringConvertible{
    
    ///微博模型
    var status:MJStatus
    ///会员图标 - 存储型属性（用内存换CPU）
    var memberIcon:UIImage?
    /// 认证类型 -1：没有认证  0：认证用户 2，3，5：企业认证 220：达人
    var vipIcon:UIImage?
    
    /// 转发字符串
    var repostStr:String?
    ///评论
    var commentStr:String?
    /// 喜欢
    var likeStr:String?
    
    ///配图尺寸
    var pictureViewSize = CGSize()
    
    ///微博正文文字
    var statusAttrText:NSAttributedString?
    ///转发微博文字
    var retweetAttrText:NSAttributedString?
    
    ///Cell 行高
    var rowHeight:CGFloat = 0
    
    
    ///计算型属性
    var picUrls:[MJStatusPicture]?{
        // 如果有被转发的微博，返回被转发微博的配图
        // 如果没有被转发的微博，返回原创微博的数据
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    
    /// 构造函数
    ///
    /// - Parameter model: 微博模型
    init(model:MJStatus) {
        self.status = model
        
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! < 7 {
            
            let imgName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberIcon = UIImage(named: imgName)
            
        }
        
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named:"avatar_vip_golden")
        case 2,3,5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        
        ///测试 万
//        model.reposts_count = Int(arc4random_uniform(100000))
        repostStr = countString(count: model.reposts_count, defauleStr: "转发")
        commentStr = countString(count: model.comments_count, defauleStr: "评论")
        likeStr = countString(count: model.attitudes_count, defauleStr: "赞")
        
        pictureViewSize = calcPictureViewSize(count:picUrls?.count)
        
        let retweetFont = UIFont.systemFont(ofSize: 14)
        let originFont = UIFont.systemFont(ofSize: 15)
        
        let text = status.retweeted_status?.text ?? ""
        
        let rText = "@" + (status.user?.screen_name ?? "") + "：" + text
        
        retweetAttrText = MJEmoticonManager.shared.emoticonString(string: rText, font: retweetFont)
        statusAttrText = MJEmoticonManager.shared.emoticonString(string:model.text ?? "",font:originFont)
    
        updateRowHeight()
    
    }
    
    /// 计算行高
    func updateRowHeight()  {
        //原创微博 顶部分割视图（12）+ 间距（12）+头像高度（34）+间距（12）+正文高度（计算）+配图视图高度（计算）+间距（12）+底部视图高度（35）
        //转发微博 顶部分割视图（12）+ 间距（12）+头像高度（34）+间距（12）+正文高度（计算）+间距（12）+间距（12）+转发文本高度（计算）+配图视图高度（计算）+间距（12）+底部视图高度（35）
        
        let margin:CGFloat = 12
        let iconHeight:CGFloat = 34
        let toolBarHeight:CGFloat = 35
        let textSize = CGSize(width: UIScreen.cz_screenWidth()-2*margin, height: CGFloat(MAXFLOAT))
        
        var height:CGFloat = 0
        
        //1.计算顶部位置
        height = 2 * margin + iconHeight + margin
        
        //2.正文高度
        if let text = statusAttrText {
        
            height += text.boundingRect(with: textSize, options: [.usesLineFragmentOrigin], context: nil).height
            
        }
        //3.判断是否转发微博
        if status.retweeted_status != nil {
            
            height += 2 * margin
            
            if let text = retweetAttrText  {
                
              height += (text.boundingRect(with: textSize, options: [.usesLineFragmentOrigin], context: nil).height + 2)
            }
        }
        
        //4.配图视图高度
        height += pictureViewSize.height
        height += margin
        height += toolBarHeight
        
        //5.属性记录
        rowHeight = height
    }
    
    /// 根据单个图像，更新配图的大小
    ///
    /// - Parameter image: 网络缓存的单张图像
    func updateSingleImageSize(image:UIImage)  {
        
        var size = image.size
        
        let maxWidth:CGFloat = 200
        let minWidth:CGFloat = 30
        
        //过宽图像处理
        if size.width > maxWidth {
            size.width = maxWidth
            
            size.height = size.width * image.size.height / image.size.width
        }
        //过窄图像处理
        if size.width < minWidth {
            size.width = minWidth
            //图片太长，特殊处理
            size.height = size.width * image.size.height / image.size.width / 4
        }
        //图片过高处理
        if size.height > 200 {
            size.height = 200
        }
        
        size.height += WBStatusPictureOutterMargin
        
        pictureViewSize = size
        //配图视图更新之后，行高也要更新
        updateRowHeight()
        
    }
    
    ///  计算图片高度
    ///
    /// - Parameter count: 图片数量
    /// - Returns: 尺寸
    func calcPictureViewSize(count:Int?) -> CGSize {
        
        if count == 0 || count == nil{
            return CGSize()
        }
        
        let row = (count! - 1)/3 + 1
        
        let height = WBStatusPictureOutterMargin +
            CGFloat(row) * WBstatusPictureItemWidth + CGFloat(row-1)*WBStatusPictureInnerMargin
        
        return CGSize(width: WBStatusPictureViewWidth, height: height)
    }
    
    private func countString(count:Int ,defauleStr:String) -> String {
        
        if count < 1 {
            return defauleStr
        }
        
        if count<10000 {
            return count.description
        }
        
        return String(format: "%.2f 万",Double(count) / 10000)
    }
    
    var description: String{
        return status.description
    }
}
