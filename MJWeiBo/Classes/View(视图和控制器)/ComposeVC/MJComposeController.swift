//
//  MJComposeController.swift
//  MJWeiBo
//
//  Created by YXCZ on 17/4/28.
//  Copyright © 2017年 林民敬. All rights reserved.
//  撰写微博控制器

import UIKit

class MJComposeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       self.view.backgroundColor = UIColor.cz_random()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", target: self, action: #selector(close))
    }
    
    @objc fileprivate func close(){
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
