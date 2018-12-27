//
//  CCJSModel.swift
//  CCAppManager
//
//  Created by 道浪 on 2017/9/21.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit
import JavaScriptCore

public class CCJSModel: NSObject {
    /// JS运行环境
    fileprivate var jsContext: JSContext!
    
    public init(context: JSContext){
        super.init()
        self.jsContext = context
    }
    
    //通用回调方法
    func callBack(_ callBackModel: CCCallBackModel){
        if let jsValue = jsContext.objectForKeyedSubscript("nativeBridgeCb"){
            if jsValue.isObject{
                var responses = [String: Any]()
                responses.updateValue(callBackModel.portName, forKey: "portName")
                responses.updateValue(callBackModel.response.getDic(), forKey: "response")
                jsValue.call(withArguments: [responses])
            }else{
                print("jsValue = \(jsValue)")
            }
            
        }
    }
}
