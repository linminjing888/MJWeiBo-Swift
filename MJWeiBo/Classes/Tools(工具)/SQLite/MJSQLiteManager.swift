//
//  MJSQLiteManager.swift
//  Swift-FMDB
//
//  Created by YXCZ on 17/6/12.
//  Copyright © 2017年 JingJing. All rights reserved.
// ----------------21------------

import Foundation
import FMDB

/// SQLite 管理器
class MJSQLiteManager {
    ///单例
    static let shared = MJSQLiteManager()
    ///数据库队列
    let quene : FMDatabaseQueue
    
    private init() {
    
        //数据库路径 - path
        let dbName = "status.db"
        var path =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent(dbName)
        
        print("路径" + path)
        
        quene = FMDatabaseQueue(path: path)
        
        createTable()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(clearDBCache),
            name: NSNotification.Name.UIApplicationDidEnterBackground,
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func clearDBCache(){
        print("清理数据缓存")
    }
    
}


// MARK: - 微博数据操作
extension MJSQLiteManager{
    
    /// 从数据库加载微博数据数组
    ///
    /// - Parameters:
    ///   - userId: 当前登录的用户账号
    ///   - since_id: 返回ID比since_id大的微博（即比since_id时间晚的微博)
    ///   - max_id: 返回ID小于max_id的微博
    /// - Returns: 微博字典的数组
    func loadStatus(userId:String,since_id:Int64 = 0,max_id:Int64 = 0)->[[String:Any]] {
        
        var sql = "SELECT statusId,userId,status FROM T_Status \n"
        sql += "where UserId = \(userId) \n"
        if since_id>0 {
            sql += "AND statusId > \(since_id) \n"
        }else if max_id>0{
            sql += "AND statusId < \(max_id) \n"
        }
        sql += "ORDER BY statusId DESC LIMIT 20"
        
//        print(sql)
        let array = execRecordSet(sql: sql)
        var result = [[String:AnyObject]]()
        
        for dicc in array {
            
            guard let jsonData = dicc["status"] as? Data,  let jsonDic = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:AnyObject] else {
                continue
            }
            result.append(jsonDic ?? [:])
        }
        return result
    }
    
    
    func updateStatus(userId:String,array:[[String:AnyObject]])  {
       
        /**
         statusId: 要保存的微博账号
         userId: 当前登录用户的id
         status: 完整微博字典的json 二进制数据
         */
         let sql = "INSERT OR REPLACE INTO T_Status(statusId,userId,status) VALUES (?,?,?)"
        
        quene.inTransaction { (db, rollback) in
            
            //遍历数组，逐条插入微博数据
            for dict in array{
                guard let statusId = dict["idstr"] as? String , let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])else {
                    continue
                }
                
                if db?.executeUpdate(sql, withArgumentsIn: [statusId,userId,jsonData]) == false{
                    
                    //需要回滚
                    rollback?.pointee = true
                    break
                }
            }
        }
    }
}


// MARK: - 创建微博数据
extension MJSQLiteManager{
    //查询数据库 返回字典数组
    func execRecordSet(sql:String) -> [[String:Any]] {
        
        var result = [[String:Any]]()
        //执行SQL 查询数组，不会修改数据，所以不需要开启事务
        //事务的目的，是为了保证数据的有效性，一旦失败，回滚到初始状态
        quene.inDatabase { (db) in
            guard let rs = db?.executeQuery(sql, withArgumentsIn: [])else{
                return
            }
            // 遍历结果集合
            while rs.next(){
                //1.列数
                let colCount = rs.columnCount()
                //2.遍历所有咧
                for col in 0..<colCount{
                    //3.列名/key ， 值/value  
                    guard let name = rs.columnName(for: col),let value = rs.object(forColumnIndex: col) else{
                        continue
                    }
                    
//                    print("\(name) -- \(value)")
                    result.append([name:value])
                }
            }
        }
        
        return result
    }
    
    func createTable() {
        //1.SQL语句
        guard let path = Bundle.main.path(forResource: "status.sql", ofType: nil),let sql =  try? String(contentsOfFile: path) else {
            return
        }
        
        //2.执行 FMDB的内部队列，串行队列，同步执行
        //可以保证同一时间，只有一个任务操作数据库，从而保证数据库的读写安全
        quene.inDatabase { (db) in
            //只有在创表的时候，使用执行多条语句，可以一次创建多个数据表
            //在执行增删改的时候，不要使用executeStatements，否则可能会被注入！
            if db?.executeStatements(sql) == true{
                print("success")
            }else{
                print("fail")
            }
        }
        
        print("over")
    }
}
