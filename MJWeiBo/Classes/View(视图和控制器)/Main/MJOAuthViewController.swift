//
//  MJOAuthViewController.swift
//  MJWeiBo
//
//  Created by YXCZ on 16/12/30.
//  Copyright © 2016年 林民敬. All rights reserved.
//

import UIKit

class MJOAuthViewController: UIViewController {

    fileprivate lazy var webView = UIWebView()
    
    override func loadView() {
        
        view = webView
        
        view.backgroundColor = UIColor.white
        
        self.title = "登录新浪微博"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(close), isBack: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @objc fileprivate func close() {
        dismiss(animated: true, completion: nil)
    }

  }
