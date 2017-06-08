//
//  MJComposeController.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/4/28.
//  Copyright © 2017年 林民敬. All rights reserved.
//  撰写微博控制器  54

/**
 加载视图控制器的时候，如果XIB和控制器同名，默认的构造函数，优先加载XIB
 */
import UIKit
import SVProgressHUD

class MJComposeController: UIViewController {

    ///文本编辑视图
    @IBOutlet weak var textView: UITextView!
    ///底部工具栏
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet var sendBtn: UIButton!
    //换行热键  option + 回车
    //如果要修改行间距，可以增加一个空行，设置空行的字体大小
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    //注意防止循环引用
    lazy var emotionView:MJEmotionInputView = MJEmotionInputView.inputView { [weak self](emoticon) in
//        print(emoticon)
        self?.insertEmotiicon(em: emoticon)
    }
    //向文本视图，插入表情符号
    func insertEmotiicon(em:MJEmoticon?) {
        //em==nil 是删除按钮
        guard em != nil else {
            textView.deleteBackward()
            return
        }
        // emoji 字符串
        if let emoji = em?.emoji,let textRange = textView.selectedTextRange {
            // UITextRange 仅用于此处
            textView.replace(textRange, withText: emoji)
            return
        }
        
        //获取表情中的图像属性文本
        let imageText = em?.imageText(font: textView.font!)
        //获取当前textView属性文本 可变的
        let attrStrM = NSMutableAttributedString(attributedString: textView.attributedText)
        //将图像的属性文本插入到当前的光标位置
        attrStrM.replaceCharacters(in: textView.selectedRange, with: imageText!)
        //记录光标位置
        let range = textView.selectedRange
        //设置文本
        textView.attributedText = attrStrM
        
        //恢复光标位置，length是选中字符的长度，插入文本之后，应该为0
        textView.selectedRange = NSMakeRange(range.location+1, 0)
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textView.resignFirstResponder()
    }
    
    @objc fileprivate func close(){
        dismiss(animated: true, completion: nil)
    }

    @IBAction func sendBtnClick(_ sender: Any) {
        
        guard let text = textView.text else {
            return
        }
        
        let image:UIImage? = nil // UIImage(named: "takeout_img_list_loading_pic1")
        
        MJNetworkManager.shared.composeWeiBo(text: text,image:image) { (json, isSuccess) in
//            print(json)
            
            SVProgressHUD.setDefaultStyle(.dark)
            let message = isSuccess ? "发布成功" : "网络不给力"
            SVProgressHUD.showInfo(withStatus:message)
            
            if isSuccess{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                    SVProgressHUD.setDefaultStyle(.light)
                    self.close()
                })
            }
            
        }
    }
    
    func keyboardWillChange(n:NSNotification) {
//        print(n.userInfo)
        
        guard let rect = (n.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue , let duration = (n.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            return
        }
        //设置底部约束的高度
        let offset = view.bounds.height - rect.origin.y
        
        bottomCons.constant = offset
        
        //动画约束
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc fileprivate func emotionKeyboard(){
        
        //视图的宽度可以随便，就是屏幕的宽度
//        let keyboardView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 258))
       
        textView.inputView = (textView.inputView == nil) ? emotionView : nil
       //刷新键盘视图!!
        textView.reloadInputViews()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
//    lazy var sendBtn: UIButton = {
//        let btn = UIButton()
//        
//        btn.setTitle("发布", for: [])
//        btn.setTitleColor(UIColor.white, for: [])
//        btn.setTitleColor(UIColor.gray, for: .disabled)
//
//        btn.setBackgroundImage(UIImage(named: "new_feature_finish_button"), for: [])
//        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: .disabled)
//        
//        btn.frame = CGRect(x: 0, y: 0, width: 45, height: 35)
//        return btn;
//    }()
}

// xib 启用代理，需要吧textView delegate 连线   File‘s owner
extension MJComposeController:UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        sendBtn.isEnabled = textView.hasText
    }
}

private extension MJComposeController{
    
    func setupUI() {
        
        view.backgroundColor = UIColor.white
        setupNavigationBar()
        
        setupToolbar()
    }
    
    func setupToolbar() {
        
        let itemSettings = [["imageName":"compose_toolbar_picture"],
                            ["imageName":"compose_mentionbutton_background"],
                            ["imageName":"compose_emoticonbutton_background","actionName":"emotionKeyboard"],
                            ["imageName":"compose_trendbutton_background"],
                            ["imageName":"compose_toolbar_more"]]
        var items = [UIBarButtonItem]()
        for s in itemSettings {
            guard let imageName = s["imageName"] else {
                continue
            }
            let image = UIImage(named: imageName)
            let imageHL = UIImage(named: imageName + "_highlighted")
            
            let btn = UIButton()
            btn.setImage(image, for: [])
            btn.setImage(imageHL, for: .highlighted)
            btn.sizeToFit()
            
            
            if let actionName = s["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
            items.append(UIBarButtonItem(customView: btn))
            //追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        //删除最后一个弹簧
        items.removeLast()
        toolBar.items = items
    }
    
    func setupNavigationBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendBtn)
        
        navigationItem.titleView = titleLabel
        sendBtn.isEnabled = false
    }
}
