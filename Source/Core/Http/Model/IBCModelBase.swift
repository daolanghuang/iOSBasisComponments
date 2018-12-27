//
//  IBCModelBase.swift
//  MyFactory
//
//  Created by 黄道浪 on 17/10/26.
//  Copyright © 2017年 道浪. All rights reserved.
//

import UIKit

@objcMembers
open class IBCModelBase: NSObject {
    public override init() {
        super.init()
    }
    public func desp() -> String{
        return "values = \(values())"
    }
    public init(dic: Dictionary<String, Any>){
        super.init()
        
        //KVC是OC特有的机制 OC可以和swift共存
        //在运行时 给'对象' 转发 setValue: forKey:
        //KVC 通过键值编码 给对象的属性设置初始值
        setValuesForKeys(dic)
    }
    
    open override func setValue(_ value: Any?, forKey key: String) {
        guard value != nil else{
            return
        }
        guard !(value is NSNull) else{
            return
        }
        super.setValue(get(value: value), forKey: key)
    }
    
    //过滤掉 不存的在属性对应的key
    open override func setValue(_ value: Any?, forUndefinedKey key: String) {
        // print(value,key)
    }
    
    
    public func values() -> [String:Any] {
        var res = [String:Any]()
        let obj = Mirror(reflecting:self)
        for (_, attr) in obj.children.enumerated() {
            if let name = attr.label {
                // Ignore special properties and lazy vars
                if ignoredKeys().contains(name) || name.hasSuffix(".storage") {
                    continue
                }
                res[name] = get(value:attr.value)
            }
        }
        return res
    }
    
    public func get(value:Any) -> Any {
        if value is String {
            return value as! String
        } else if value is Int {
            return value as! Int
        } else if value is Float {
            return value as! Float
        } else if value is Double {
            return value as! Double
        } else if value is Bool {
            return value as! Bool
        } else if value is Date {
            return value as! Date
        } else if value is NSData {
            return value as! NSData
        } else if value is Dictionary<String, Any>{
            return value as! Dictionary<String, Any>
        } else if value is [Int]{
            return value as! [Int]
        }
        else if value is [Float]{
            return value as! [Float]
        }
        else if value is [NSNumber]{
            let v = value as! [NSNumber]
            var vF = [Float]()
            for item in v{
                vF.append(item.floatValue)
            }
            return vF
        }
        return "nil"
    }
    
    public func ignoredKeys() -> [String] {
        return []
    }
}

