//
//  MJWebViewController.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/5/5.
//  Copyright © 2017年 林民敬. All rights reserved.
//

import UIKit

class MJWebViewController: MJBaseViewController {

    fileprivate lazy var webView = UIWebView(frame: UIScreen.main.bounds)
    
    var urlString: String? {
        didSet{
            guard let urlString = urlString,
                let url = URL(string: urlString) else {
                return
            }
           webView.loadRequest(URLRequest(url: url))
        }
    }
    
}

extension MJWebViewController{
    override func setUpTableView() {
        
        view.insertSubview(webView, belowSubview: navigationBar)
        webView.backgroundColor = UIColor.white
        
        webView.scrollView.contentInset.top = navigationBar.bounds.height
    }
}
