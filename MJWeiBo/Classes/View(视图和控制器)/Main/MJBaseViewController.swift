//
//  MJBaseViewController.swift
//  MJWeiBo
//
//  Created by YXCZ on 16/12/16.
//  Copyright © 2016年 林民敬. All rights reserved.
//

import UIKit

// Swift中，利用 extension 可以把“函数”按照功能分类管理，便于阅读和维护

// MARK: - 所有主控制器的基类控制器
class MJBaseViewController: UIViewController {

    
    /// 表格视图 如果用户没有登入 就不创建
    var tableView = UITableView()
    
    ///自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    ///自定义导航条目
    lazy var navItem = UINavigationItem()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData()
        
    }
    ///重写 title 的 didSet
    override var title: String?{
        didSet{
            navItem.title = title
        }
    }
    
    ///加载数据 具体实现由子类控制
    func loadData() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - 设置界面
extension MJBaseViewController{
    
    func setupUI() {
        view.backgroundColor = UIColor.cz_random()
        
        //取消自动缩进 - 如果隐藏了导航栏，会缩进 20 个点
        automaticallyAdjustsScrollViewInsets = false
        
        setUpNavigationBar()
        setUpTableView()
        
    }
    
    private func setUpTableView(){
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        view.insertSubview(tableView, belowSubview: navigationBar)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
    }
    
    // --------------10-----------
    
    private func setUpNavigationBar(){
        view.addSubview(navigationBar)
        //将 item 设置给 bar
        navigationBar.items = [navItem]
        //设置 navBar 的渲染颜色
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        //设置 navBar 的字体颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkGray]
    }
    
}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension MJBaseViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
