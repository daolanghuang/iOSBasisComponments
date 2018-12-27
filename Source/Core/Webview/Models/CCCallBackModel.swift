//
//  CCCallBackModel.swift
//  CCAppManager
//
//  Created by 道浪 on 2017/9/22.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit

struct JSResponse{
    /// code = 0 成功，code = 1 失败
    var code: Int
    /// 错误提示信息
    var message: String
    /// 返回数据集
    var data: Any

    
    func getDic() -> [String: Any]{
        return ["code": code, "message": message, "data": data]
    }
}

class CCCallBackModel: NSObject {
    /// 方法名
    var portName: String!
    /// 返回数据
    var response: JSResponse!
    
    override init() {
        super.init()
    }
    
    init(portName: String, response: JSResponse) {
        super.init()
        
        self.portName = portName
        self.response = response
    }
    
    
    //成功回调
    class func sucessModel(portName: String, data: Any) -> CCCallBackModel{
        
        return CCCallBackModel.init(portName: portName, response: JSResponse.init(code: 0, message: "", data: data))
    }
    //失败回调
    class func failModel(portName: String, errorMessage: String) -> CCCallBackModel{
        
        return CCCallBackModel.init(portName: portName, response: JSResponse.init(code: -1, message: errorMessage, data: NSObject()))
    }
}
