//
//  MJHomeViewController.swift
//  MJWeiBo
//
//  Created by YXCZ on 16/12/16.
//  Copyright © 2016年 林民敬. All rights reserved.
//

import UIKit

// 定义全局变量，尽量使用 private 修饰，否则到处都可以访问
private let cellId = "cellId"

class MJHomeViewController: MJBaseViewController {

    ///列表视图模型
    fileprivate lazy var listViewModel = MJStatusListViewModel()
    
    ///加载数据
    override func loadData() {
    
       listViewModel.loadStatus(pullUp: isPullUp) { (isSuccess,isRefresh) in
        
            //结束刷新
            self.refreshControl?.endRefreshing()
            //恢复上啦刷新标记
            self.isPullUp = false
        
            if isRefresh{
                self.tableView?.reloadData()
            }
        }
        
        
    }
    
    func showFriends() {
        print("friend")
        
        let vc = MJDemoViewController()
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

//MARK: - 表格数据源方法实现
extension MJHomeViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MJHomeStatusCell
        cell.statusLabel?.text = listViewModel.statusList[indexPath.row].text
        
        return cell
        
    }
}

// MARK: - 设置界面
extension MJHomeViewController{
    //重写父类的方法
    override func setUpTableView() {
        
        super.setUpTableView()
        navItem.leftBarButtonItem = UIBarButtonItem(title:"好友" , target: self, action: #selector(showFriends))
        
        //注册cell
//        tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellId)
        tableView?.register(UINib(nibName: "MJHomeStatusNormalCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        //设置行高
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        
        tableView?.separatorStyle = .none
        
        self.setupNavTitle()
    }
    
    private func setupNavTitle(){
        let title = MJNetworkManager.shared.userAccount.screen_name;
        
        let btn = MJTitleButton(title: title)
        
        navItem.titleView = btn
        
        btn.addTarget(self, action: #selector(clickTitleBtn(btn:)), for: .touchUpInside)
        
    }
    
    func clickTitleBtn(btn:UIButton)  {
        btn.isSelected = !btn.isSelected
    }
}
