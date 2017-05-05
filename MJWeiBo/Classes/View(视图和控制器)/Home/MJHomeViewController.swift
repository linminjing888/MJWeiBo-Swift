//
//  MJHomeViewController.swift
//  MJWeiBo
//
//  Created by YXCZ on 16/12/16.
//  Copyright © 2016年 林民敬. All rights reserved.
//

import UIKit

// 定义全局变量，尽量使用 private 修饰，否则到处都可以访问

/// 正常微博 cell id
private let originalCellId = "originalCellId"
/// 转发微博id cell id
private let retweetCellId = "retweetCellId"

class MJHomeViewController: MJBaseViewController {

    ///列表视图模型
    fileprivate lazy var listViewModel = MJStatusListViewModel()
    
    ///加载数据
    override func loadData() {
    
       refreshControl?.beginRefreshing()
       listViewModel.loadStatus(pullUp: isPullUp) { (isSuccess,isRefresh) in
        //FIXME:
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { 
            //结束刷新
            self.refreshControl?.endRefreshing()
            //恢复上啦刷新标记
            self.isPullUp = false
            
            if isRefresh{
                self.tableView?.reloadData()
            }
        })
        
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
        
        let viewModel = listViewModel.statusList[indexPath.row]
        let cellID = (viewModel.status.retweeted_status != nil) ?retweetCellId : originalCellId
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MJHomeStatusCell
        
        cell.viewModel = viewModel
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let viewModel = listViewModel.statusList[indexPath.row]
        return viewModel.rowHeight
    }
}

extension MJHomeViewController:MJHomeStatusCellDelegate{
    
    func MJHomeStatusCellDidSelectedUrling(cell: MJHomeStatusCell, url: String) {
        
        let v = MJWebViewController()
        v.urlString = url
        navigationController?.pushViewController(v, animated: true)
        
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
        tableView?.register(UINib(nibName: "MJHomeStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalCellId)
        
        tableView?.register(UINib(nibName: "MJHomeStatusRetweetCell", bundle: nil), forCellReuseIdentifier: retweetCellId)
        
        //设置行高
        //自动适配行高
//        tableView?.rowHeight = UITableViewAutomaticDimension
//        tableView?.estimatedRowHeight = 300
        
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
