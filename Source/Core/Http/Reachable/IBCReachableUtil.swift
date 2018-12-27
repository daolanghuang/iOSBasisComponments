//
//  IBCReachableUtil.swift
//  iOSBasisComponents
//
//  Created by 道浪 on 2018/8/9.
//  Copyright © 2018年 Enn. All rights reserved.
//

import UIKit
import Alamofire

/// 网络监听
public class IBCReachableUtil: NSObject {
    public static let share = IBCReachableUtil()
    /// 网络是否可用
    public var isReachable: Bool = true
    /// 是否为wifi网络
    public var isWifi: Bool = true
    /// 网络监听
    var manager = NetworkReachabilityManager(host: "www.baidu.com")
    /// 网络监听key
    let NLKReachabilityChangedNotification = NSNotification.Name.init("NLKReachabilityChangedNotification")
    /// 开始网络监听
    public func monitorNet()  {
        if manager == nil{
            manager = NetworkReachabilityManager(host: "www.baidu.com")
        }
        manager?.listener = { status in
            switch status {
            case .notReachable:
                self.isReachable = false
                break
            case .unknown:
                self.isReachable = true
                self.isWifi = false
                break
            case .reachable(.ethernetOrWiFi):
                //NetworkReachabilityManager.ConnectionType
                self.isReachable = true
                self.isWifi = true
                break
            case .reachable(.wwan):
                self.isWifi = false
                self.isReachable = true
                break
            }
            
            if self.isReachable{
                NotificationCenter.default.post(name: self.NLKReachabilityChangedNotification, object: nil)
            }
            
            IBCLog("网络状态: \(status)")
        }
        manager?.startListening()//开始监听网络
        guard manager != nil else{
            return
        }
        isReachable = manager!.isReachable
    }
    
    fileprivate override init() {
        super.init()
    }
    
}
