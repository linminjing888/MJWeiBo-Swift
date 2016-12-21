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

    ///微博数据数组
    lazy var statusList = [String]()
    
    ///加载数据
    override func loadData() {
        
        //模拟“延时”加载数据
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            for i in 0..<15 {
                if self.isPullUp{
                    self.statusList.append("上拉\(i)")
                }else{
                    self.statusList.insert(i.description, at: 0)
                }
            }
            
            self.refreshControl?.endRefreshing()
            self.isPullUp = false
            self.tableView?.reloadData()
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
        return statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = statusList[indexPath.row]
        
        return cell
        
    }
}

// MARK: - 设置界面
extension MJHomeViewController{
    //重写父类的方法
    override func setupUI() {
        super.setupUI()
        
        navItem.leftBarButtonItem = UIBarButtonItem(title:"好友" , target: self, action: #selector(showFriends))
        tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellId)
        
    }
}
