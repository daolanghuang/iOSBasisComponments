//
//  IBCStringTable.swift
//  iOSBasisComponents
//
//  Created by 道浪 on 2017/8/30.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit
import SQLite
import JavaScriptCore

public class IBCStringTable: IBCTableBase {
    /// 只存储string表名
    let identifier: String = {
        return "IBCStringTable"
    }()
    
    let key = Expression<String>("key")
    let value = Expression<String>("value")
    
    public init() {
        super.init(tableName: identifier, columns: [key, value])
    }
    
    /// 查询操作
    ///
    /// - Parameter keyStr: 键
    /// - Returns: 返回查询结果
    public func select(keyStr: String) -> String{
        let alice = table.filter(key == keyStr)
        do{
            guard let items = try db?.prepare(alice) else {
                return ""
            }
            for user in items{
                print("id: \(user[key]), name: \(try user.get(value))")
                // id: 1, name: Optional("Alice"), email: alice@mac.com
                return try user.get(value)
            }
        }catch{
            print("error: select \(error.localizedDescription)")
        }
        
        return ""
        
    }
    
    /// 数据插入
    ///
    /// - Parameters:
    ///   - keyStr: 键
    ///   - valueStr: 值
    /// - Returns: 插入状态
    public func insert(keyStr: String, valueStr: String) -> Bool{
        let insert = table.insert(key <- keyStr, value <- valueStr)
        
        do{
            try db?.run(insert)
            
            return true
        }catch{
            print("error: insert \(error.localizedDescription)")
            
            return false
        }
        
    }
    
    /// 根据键更新数据
    ///
    /// - Parameters:
    ///   - keyStr: 键
    ///   - valueStr: 值
    /// - Returns: 更新状态
    public func update(keyStr: String, valueStr: String) -> Bool{
        let update = table.update(key <- keyStr, value <- valueStr)
        
        do{
            try db?.run(update)
            
            return true
        }catch{
            print("error: update \(error.localizedDescription)")
            
            return false
        }
    }
    
    /// 根据键删除某条记录
    ///
    /// - Parameter keyStr: 键
    /// - Returns: 删除状态
    public func delete(keyStr: String) -> Bool{
        let delete = table.filter(key == keyStr)
        
        do{
            try db?.run(delete.delete())
            
            return true
        }catch{
            print("error: delete \(error.localizedDescription)")
            
            return false
        }
    }
}
