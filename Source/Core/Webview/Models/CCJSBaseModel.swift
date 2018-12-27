//
//  CCJSBaseModel.swift
//  CCAppManager
//
//  Created by 道浪 on 2017/8/29.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit
import JavaScriptCore
import SQLite
import Alamofire


public protocol CCModuleBaseDelegate: NSObjectProtocol {
    
}

@objc protocol CCJSModuleBaseDelegate: JSExport {
    
    /// 拨打电话
    ///
    /// - Parameter value:
    /// phone 电话号码    string
    func callUp(_ value: JSValue)
    
    /// 数据库操作
    ///
    /// - Parameter value:
    /// handleType    操作类型    string    select/add/update/delete
    /// objs    操作对象集合    array<object>
    func dbhandle(_ value: JSValue)
    
    /// 获取地理位置信息
    func location()
    
    /// 获取网络环境
    func networkStatus()
    
    /// 运行环境
    func operatingEnvironment()
    
    
}


@objc public class CCJSBaseModel: CCJSModel, CCJSModuleBaseDelegate{
    
    weak var baseModelDelegate: CCModuleBaseDelegate?
    
    public func cc_save(_ key: String, _ value: String) -> Bool{
        let util = IBCStringTable.init()
        let status = util.insert(keyStr: key, valueStr: value)
        return status
    }
    
    public func cc_get(_ key: String) -> String{
        let util = IBCStringTable.init()
        let queryData = util.select(keyStr: key)
        return queryData
    }
    
    public func cc_update(_ key: String, _ value: String) -> Bool{
        let util = IBCStringTable.init()
        let status = util.update(keyStr: key, valueStr: value)
        return status
    }
    
    public func cc_delete(_ key: String) -> Bool{
        let util = IBCStringTable.init()
        let status = util.delete(keyStr: key)
        return status
    }
    
    
    
    /// 拨打电话
    ///
    /// - Parameter value:
    /// phone 电话号码    string
    public func callUp(_ value: JSValue){
        let _ = DispatchQueue.main.async {
            UIApplication.shared.openURL(URL.init(string: "tel:\(value.forProperty("phone").toString()!)")!)
        }
        let response  = JSResponse.init(code: 0, message: "", data:[])
        self.callBack(CCCallBackModel.init(portName: "callUp", response: response))
    }
    
    /// 数据库操作
    ///
    /// - Parameter value:
    /// handleType    操作类型    string    select/add/update/delete
    /// objs    操作对象集合    array<object>
    public func dbhandle(_ value: JSValue){
        let handleType = value.forProperty("handleType").toString()!
        let dataArray = value.forProperty("objs").toArray()!
        var resultArray = Array<Any>()
        for queryItem in dataArray {
            let queryDic = queryItem as! Dictionary<String,Any>
            let itemKey = queryDic.keys.first!
            let itemValue = queryDic.values.first!
            switch handleType {
            case "select":
                resultArray.append(self.cc_get(queryDic.keys.first!))
            case "add":
                resultArray.append(self.cc_save(itemKey, itemValue as! String))
            case "update":
                resultArray.append(self.cc_update(itemKey, itemValue as! String))
            case "delete":
                resultArray.append(self.cc_delete(itemKey))
            default:
                break
            }
        }
        let response  = JSResponse.init(code: 0, message: "", data: resultArray)
        self.callBack(CCCallBackModel.init(portName: "dbhandle", response: response))
    }
    
    /// 获取地理位置信息
    public func location(){
        let location = CCLocationModel.sharedLocationModel.getCurrentLocation()
        var response = JSResponse.init(code: -1, message: "定位失败", data: [])
        if location != nil {
            response = JSResponse.init(code: 0, message: "", data: ["latitude":location?.latitude,"longitude":location?.longitude])
        }
        self.callBack(CCCallBackModel.init(portName: "location", response: response))
    }
    
    /// 获取网络环境
    public func networkStatus(){
        var response = JSResponse.init(code: -1, message: "获取网络环境失败", data: [])
        if IBCReachableUtil.share.isReachable {
            if IBCReachableUtil.share.isWifi {
                response = JSResponse.init(code: 0, message: "", data: ["networkStatus":"wifi"])
            }else{
                response = JSResponse.init(code: 0, message: "", data: ["networkStatus":"4g"])
            }
        } else {
            response = JSResponse.init(code: 0, message: "", data: ["networkStatus":"无网络"])
        }
        self.callBack(CCCallBackModel.init(portName: "networkStatus", response: response))
    }
    
    /// 运行环境
    public func operatingEnvironment(){
        let deviceModel = UIDevice.current.model
        let deviceSys = UIDevice.current.systemVersion
        let response = JSResponse.init(code: 0, message: "", data: ["deviceType":deviceModel,"osVersion":deviceSys,"environment":ibcEnvironment.rawValue])
        self.callBack(CCCallBackModel.init(portName: "operatingEnvironment", response: response))
    }
}


