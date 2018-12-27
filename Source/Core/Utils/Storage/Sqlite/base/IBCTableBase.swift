//
//  IBCTableBase.swift
//  iOSBasisComponents
//
//  Created by 道浪 on 2017/8/30.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit
import SQLite

open class IBCTableBase: NSObject {
    /// 数据库引用
    public let db: Connection? = {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        do{
            let db = try Connection("\(path)/db.sqlite3")
            
            return db
        }catch{
            print("error: dbinit \(error.localizedDescription)")
            return nil
        }
    }()
    
    public var table: Table!
    
    public init(tableName: String, columns: [Any]) {
        super.init()
        
        table = Table(tableName)
        do{
            try db?.run(table.create(ifNotExists: true, block: { (table) in
                for i in 0 ..< columns.count{
                    if columns[i] is Expression<Int>{
                        table.column(columns[i] as! Expression<Int>, primaryKey: i == 0)
                    }else if columns[i] is Expression<String>{
                        table.column(columns[i] as! Expression<String>, primaryKey: i == 0)
                    }else if columns[i] is Expression<Bool>{
                        table.column(columns[i] as! Expression<Bool>, primaryKey: i == 0)
                    }else if columns[i] is Expression<Double>{
                        table.column(columns[i] as! Expression<Double>, primaryKey: i == 0)
                    }
                }
            }))
        }catch{
            
            print("error: init \(error.localizedDescription)")
        }
    }
    
    
    /// 将数据库查询到的数据转为Dic
    open func getDic(row: Row) -> Dictionary<String, Any>{
        return Dictionary<String, Any>()
    }
    
    /// 将model转为[Setter]
    open func getSet(model: IBCModelBase) -> [Setter]{
        return [Expression<String>("defaultKey") <- "defaultValue"]
    }
    
    /// 查询分组
    ///
    /// - Parameter
    /// - Returns: 分组信息
    open func select() -> [Dictionary<String, Any>]{
        var arrays = [Dictionary<String, Any>]()
        
        do{
            guard let items = try db?.prepare(table) else {
                return arrays
            }
            
            for item in items{
                arrays.append(getDic(row: item))
            }
        }catch{
            print("error: select \(error.localizedDescription)")
        }
        
        return arrays
        
    }
    
    /// 条件查询
    ///
    /// - Parameter datas: 数据集
    /// - Returns: 状态集合
    open func selectWith(filter: Expression<Bool>) -> [Dictionary<String, Any>]{
        var arrays = [Dictionary<String, Any>]()
        
        let alice = table.filter(filter)
        do{
            guard let items = try db?.prepare(alice) else {
                return arrays
            }
            
            for item in items{
                arrays.append(getDic(row: item))
            }
        }catch{
            print("error: select \(error.localizedDescription)")
        }
        
        return arrays
    }
    
    /// 数据插入
    ///
    /// - Parameter datas: 分组集
    /// - Returns: 返回插入状态
    open func insert(datas: [IBCModelBase]) -> [Bool]{
        var results = [Bool]()
        
        for model in datas{
            let insert = table.insert(getSet(model: model))
            
            do{
                try db?.run(insert)
                
                results.append(true)
            }catch{
                results.append(false)
                print("\(model.description)插入失败: \(error.localizedDescription)")
            }
        }
        return results
    }
    
    /// 数据更新
    ///
    /// - Parameter datas: 更新数据集
    /// - Returns: 更新状态集合
    open func update(data: IBCModelBase, filter: Expression<Bool>) -> Bool{
        let alice = table.filter(filter)
        let update = alice.update(getSet(model: data))
        
        do{
            try db?.run(update)
            
            return true
        }catch{
            print("\(data.desp())更新失败: \(error.localizedDescription)")
            
            return false
        }
    }
    
    /// 数据删除
    ///
    /// - Parameter datas: 删除数据集
    /// - Returns: 删除状态集合
    open func delete(datas: [IBCModelBase], filter: Expression<Bool>) -> [Bool]{
        var results = [Bool]()
        
        for model in datas{
            let delete = table.filter(filter).delete()
            
            do{
                try db?.run(delete)
                
                results.append(true)
            }catch{
                results.append(false)
                print("\(model.description)删除失败: \(error.localizedDescription)")
            }
        }
        return results
    }
    
    /// 数据删除
    ///
    /// - Parameter datas: 删除数据集
    /// - Returns: 删除状态集合
    open func delete(datas: [IBCModelBase], filters: [Expression<Bool>]) -> [Bool]{
        var results = [Bool]()
        
        for i in 0 ..< datas.count{
            let delete = table.filter(filters[i]).delete()
            
            do{
                try db?.run(delete)
                
                results.append(true)
            }catch{
                results.append(false)
                print("\(datas[i].description)删除失败: \(error.localizedDescription)")
            }
        }
        
        return results
    }
    
    /// 条件删除
    ///
    /// - Parameter filter: 条件
    /// - Returns: 成功状态
    open func delete(filter: Expression<Bool>) -> Bool{
        let delete = table.filter(filter).delete()
        
        do{
            try db?.run(delete)
            
            return true
        }catch{
            return false
        }
    }
    
    /// 删除所有
    ///
    /// - Returns: 成功状态
    open func deleteAll() -> Bool{
        do{
            try db?.run(table.delete())
            return true
        }catch{
            return false
        }
    }
}

