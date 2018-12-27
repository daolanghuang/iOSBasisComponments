//
//  Dictionary+Extension.swift
//  iOSBasisComponents
//
//  Created by 道浪 on 2018/4/18.
//  Copyright © 2018年 Enn. All rights reserved.
//

import UIKit

public extension Dictionary{
    func jsonString() -> String {
        if (!JSONSerialization.isValidJSONObject(self)) {
            IBCLog("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: self, options: []) as! NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
}
