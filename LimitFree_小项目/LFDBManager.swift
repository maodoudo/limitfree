//
//  LFDBManager.swift
//  LimitFree_小项目
//
//  Created by 豆豆毛 on 2016/10/8.
//  Copyright © 2016年 豆豆毛vjgj. All rights reserved.
//

import UIKit

class LFDBManager: NSObject {

    private var myQueue : FMDatabaseQueue?
    
    class var sharedManager : LFDBManager? {
    
        struct Static{
            static var onceToken:dispatch_once_t = 0
            static var instance : LFDBManager? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = LFDBManager()
        }
        
        return Static.instance!
    }
    
    override init() {
        //初始化数据库
        //文件路径
        let cachDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last
        let path = cachDir?.stringByAppendingString("/collect.db")
        //创建duilie
        myQueue = FMDatabaseQueue(path: path)
        //创建表格
        myQueue?.inDatabase({
            (database) in
            
            let createSql = "create table if not exists collect (collect integer primary key autoincrement,applicationId varchar(255), name vachar(255), headImage blob)"
            let flag = database.executeUpdate(createSql, withParameterDictionary: nil)
            
            if flag != true {
                print(database.lastErrorMessage())
            }
        })
    }
    
    func addCollect(model:CollectModel,finishClosure:(Bool -> Void)) {
        myQueue?.inDatabase({
            (database) in
            
            let insertSql = "insert into collect (applicationId, name, headImage) values (?,?,?)"
            let data = UIImagePNGRepresentation(model.headImage!)
            let flag = database.executeUpdate(insertSql, withArgumentsInArray: [model.applicationId!,model.name!,data!])
            
            if flag != true {
                print(database.lastErrorMessage())
            }
            
            finishClosure(flag)
        })
    
    }
    
    func isAppFavorite(appId:String,resultClosure :(Bool -> Void)) {
        
        myQueue?.inDatabase({
            (database) in
            
            let sql = "select count(*) as cnt from collect where applicationId = ?"
            let rs = database.executeQuery(sql, withArgumentsInArray: [appId])
            print(rs)
            var cnt : Int32 = 0
            if rs.next() {
                
                cnt = rs.intForColumn("cnt")
            }
            
            if cnt > 0 {
                resultClosure(true)
            }else {
                
                resultClosure(false)
            }
            rs.close()
        })
    }
    
    //查询数据的方法
    func searchAllCollectData(resultClosure: (Array<CollectModel> -> Void)) {
        
        myQueue?.inDatabase({ (database) in
            
            let sql = "select * from collect"
            let rs = database.executeQuery(sql, withArgumentsInArray: nil)
            
            var tmpArray = Array<CollectModel>()
            while rs.next(){
                
                let model = CollectModel()
                model.collectId = Int(rs.intForColumn("collectId"))
                model.applicationId = rs.stringForColumn("applicationId")
                model.name = rs.stringForColumn("name")
                let data = rs.dataForColumn("headImage")
                model.headImage = UIImage(data: data)
                tmpArray.append(model)
                
            }
            
            resultClosure(tmpArray)
            
            rs.close()
        })
    }
    
    func deleteWithAppId(appId:String,resultClosure:(Bool -> Void)) {
        myQueue?.inDatabase({ (database) in
            
            let sql = "delete from collect where applicationId = ?"
            let flag = database.executeUpdate(sql, withArgumentsInArray: [appId])
            if flag != true {
                print(database.lastErrorMessage())
            }
            
            resultClosure(flag)
        })
    }
    
}
