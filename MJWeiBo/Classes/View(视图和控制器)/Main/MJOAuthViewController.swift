//
//  MJOAuthViewController.swift
//  MJWeiBo
//
//  Created by YXCZ on 16/12/30.
//  Copyright © 2016年 林民敬. All rights reserved.
//

import UIKit
import SVProgressHUD

class MJOAuthViewController: UIViewController {

    fileprivate lazy var webView = UIWebView()
    
    override func loadView() {
        
        view = webView
        view.backgroundColor = UIColor.white
        webView.delegate = self
        webView.scrollView.isScrollEnabled  = false
        
        self.title = "登录新浪微博"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(close), isBack: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autofill))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(MJAPPKEY)&redirect_uri=\(MJREDIRECTURL)"
        
        //"https://api.weibo.com/oauth2/authorize?client_id=292051871&redirect_uri=http://www.hao123.com"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        webView.loadRequest(request)
    }

    @objc fileprivate func close() {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func autofill() {
        let js = "document.getElementById('userId').value = 'minjing_lin@sina.cn';" + "document.getElementById('passwd').value = '*******';"
        webView.stringByEvaluatingJavaScript(from: js)
    }
  }

extension MJOAuthViewController:UIWebViewDelegate{
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        //请求地址是否包含MJREDIRECTURL
//        print("url链接-- \(request.url?.absoluteString)")
        
        if request.url?.absoluteString.hasPrefix(MJREDIRECTURL) == false {
            return true
        }
        if request.url?.query?.hasPrefix("code=") == false {
            
            print("取消授权")
            close()
            return false
        }
        
        //回调地址的"查询字符串"中查找"code"
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? "ss"
        
        if code == "ss" {
            return true
        }
        print("授权码 - \(code)")
        MJNetworkManager.shared.loadAccessToken(code: code)
        
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}
