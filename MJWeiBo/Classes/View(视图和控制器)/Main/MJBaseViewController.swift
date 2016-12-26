//
//  MJBaseViewController.swift
//  MJWeiBo
//
//  Created by YXCZ on 16/12/16.
//  Copyright © 2016年 林民敬. All rights reserved.
//

import UIKit

// Swift中，利用 extension 可以把“函数”按照功能分类管理，便于阅读和维护
//注意：
//1.extension 中不能有属性
//2.extension 中不能重写“父类”本类的方法；重写父类的方法是子类的职责，扩展是对类的扩展

// MARK: - 所有主控制器的基类控制器
class MJBaseViewController: UIViewController {

    ///用户登入标记
    var userLogon = false
    /// 方可视图字典
    var visitorInfoDic :[String:String]?
    
    /// 表格视图 如果用户没有登入 就不创建
    var tableView: UITableView?
    ///刷新控件
    var refreshControl: UIRefreshControl?
    ///上拉刷新标记
    var isPullUp = false
    
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
        //如果子类不实现此方法，默认关闭刷新控件
        refreshControl?.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - 设置视图监听方法
extension MJBaseViewController{
    func login(){
        print("登录")
    }
    
    func register(){
        print("注册")
    }
}

// MARK: - 设置界面
extension MJBaseViewController{
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        
        //取消自动缩进 - 如果隐藏了导航栏，会缩进 20 个点
        automaticallyAdjustsScrollViewInsets = false
        
        setUpNavigationBar()
        
        userLogon ? setUpTableView() : setUpVisitorView()
        
    }
    ///表格视图 -- 用户登录之后执行
    func setUpTableView(){
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        
        ///设置刷新控件
        refreshControl = UIRefreshControl()
        tableView?.addSubview(refreshControl!)
        
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    ///访客视图
    private func setUpVisitorView(){
        
        let visitorView = MJVisitorView(frame: view.bounds)
        
        view.insertSubview(visitorView, belowSubview: navigationBar)
        visitorView.visitorInfo = visitorInfoDic
        
        //添加按钮监听方法
        visitorView.loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        visitorView.registerBtn.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        //设置导航条按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
        
    }
    
    private func setUpNavigationBar(){
        view.addSubview(navigationBar)
        //将 item 设置给 bar
        navigationBar.items = [navItem]
        //设置 navBar 的渲染颜色
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        //设置 navBar 的字体颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkGray]
        //
        navigationBar.tintColor = UIColor.orange 
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //判断 indexPath 是否是最后一行
        let row = indexPath.row
        
        let section = tableView.numberOfSections - 1
        
        if row < 0 && section < 0 {
            return
        }
        
        let count = tableView.numberOfRows(inSection: section)
        
        //如果是最后一行，同时没有正在上啦刷新
        if row == (count-1) && !isPullUp {
            
            isPullUp = true
            //开始刷新 加载数据
            loadData()
        }
    }

}
