//
//  CCJSHttpModel.swift
//  CCAppManager
//
//  Created by 道浪 on 2017/9/20.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit
import JavaScriptCore
import Alamofire

@objc protocol CCJSModuleHttpDelegate: JSExport {
    
    /// 网络请求
    ///
    /// - Parameter params:
    func httpConnection(_ params: JSValue)
    
    /// 用户权限鉴权
    ///
    /// - Parameter params:
    func authentication(_ params: JSValue)
    
    /// 单点登录
    ///
    /// - Parameter params:
    func sso(_ params: JSValue)
    
    /// 上传图片
    ///
    /// - Parameter params:
    func uploadImage(_ params: JSValue)
}

@objc public class CCJSHttpModel: CCJSModel, CCJSModuleHttpDelegate {
    /// 参数解析
    func analysisJSValue(_ params: JSValue) -> (headers: HTTPHeaders?, httpParams: Dictionary<String, Any>?, url: String?, errorMessage: String){
        var headers: HTTPHeaders?
        var httpParams: Dictionary<String, Any>?
        var url: String?
        var errorMessage = ""
        if let h = params.forProperty("heads").toDictionary() as? [String: String]{
            headers = h
        }else{
            errorMessage = "头文件读取失败"
        }
        
        if let p = params.forProperty("params").toDictionary() as? [String: Any]{
            httpParams = p
        }else{
            errorMessage += ", 参数读取失败"
        }
        
        if let u = params.forProperty("url").toString(){
            url = u
        }else{
            errorMessage += ", 链接读取失败"
        }
        
        return (headers: headers, httpParams: httpParams, url: url, errorMessage: errorMessage)
    }
    /// 网络请求
    ///
    /// - Parameter params:
    public func httpConnection(_ params: JSValue){
        let httpInfos = analysisJSValue(params)
        
        let httpCallBack = { (http: IBCHttp) in
            let response = JSResponse.init(code: http.code == 0 ? 0:-1, message: http.message, data: http.data)
            
            self.callBack(CCCallBackModel.init(portName: "httpConnection", response: response))
        }
        if httpInfos.url == nil || httpInfos.url == ""{
            IBCHttp.request(heards: httpInfos.headers, params: httpInfos.httpParams, callBack: httpCallBack)
        }else{
            IBCHttp.request(heards: httpInfos.headers, url: httpInfos.url!, params: httpInfos.httpParams, callBack: httpCallBack)
        }
    }
    
    /// 用户权限鉴权
    ///
    /// - Parameter params:
    public func authentication(_ params: JSValue){
    }
    
    /// 单点登录
    ///
    /// - Parameter params:
    public func sso(_ params: JSValue){
    }
    
    /// 上传图片
    ///
    /// - Parameter params:
    public func uploadImage(_ params: JSValue){
//        let httpInfos = analysisJSValue(params)
//
//        let httpCallBack = { (http: IBCHttp) in
//            let response = JSResponse.init(code: http.ret == 0 ? 0:1, message: http.msg, data: http.data)
//
//            self.callBack(CCCallBackModel.init(portName: "uploadImage", response: response))
//        }
//        IBCHttp.upload(urlStr: <#T##String#>, uploadData: <#T##Data#>, uploadProgress: <#T##((Progress) -> Void)##((Progress) -> Void)##(Progress) -> Void#>)
    }
}
