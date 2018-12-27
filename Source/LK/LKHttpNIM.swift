//
//  NLKHttpNIM.swift
//  EnnewLaikang
//
//  Created by 道浪 on 2018/3/19.
//  Copyright © 2018年 Enn. All rights reserved.
//
import UIKit
import Alamofire

/// CitizenCloud Http Api
open class LKHttpNIM: NSObject {
    /// default -1  fail -2 sucess 0
    /// 请求状态码
    public var code: Int = -1
    /// 请求失败提示语句
    public var message: String = "请求失败"
    /// 请求数据
    public var data: Any!
    /// 请求成功状态：后台返回的成功状态
    public var success: Bool = false
    
    public func desp() -> String{
        return  "{code : \(code), message : \(message), values : \(data), success : \(success)}"
    }
    required override public init() {
        super.init()
    }
    
    
    /// 网络请求
    ///
    /// - Parameters:
    ///   - heards: 头  没有不传或nil
    ///   - url: 请求链接
    ///   - params: 请求参数
    ///   - callBack: CCHttp回调
    public class func request(heards: Dictionary<String, String>? = nil, url: String = "", method: String = "post", params: Dictionary<String, Any>? = nil, isJSON: Bool = true,callBack: @escaping ((LKHttpNIM) -> Void)){
        guard IBCReachableUtil.share.isReachable else{
            let httpResult = self.init()
            httpResult.code = -1
            httpResult.message = "网络已断开"
            httpResult.success = false
            callBack(httpResult)
            return
        }
        
        let urlR = URL(string: url)!
        var urlRequest = URLRequest(url: urlR)
        urlRequest.httpMethod = method
        if params != nil{
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params!, options: [])
            } catch {
                // No-op
                IBCLog("数据转换失败：\(error.localizedDescription)")
            }
        }
        
        //设置contentType为 application/json
        if isJSON{
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest.setValue(LKUser.shared.userToken, forHTTPHeaderField: "UserToken")

        
        if heards != nil{
            for (key, value) in heards!{
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        Alamofire.request(urlRequest).responseJSON { response in
                let http = self.init()
                IBCLog("response.result = \(response)")
                guard response.result.isSuccess else{
                    //未请求到服务器数据
                    http.code = -2
                    if let errorMessage = response.error?.localizedDescription{
                        http.message = errorMessage
                    }
                    
                    callBack(http)
                    return
                }
                
                guard let value = response.result.value else{
                    http.code = -2
                    http.message = "返回数据为空"
                    
                    callBack(http)
                    return
                }
                guard let resultDic = value as? Dictionary<String, Any> else{
                    http.code = -3
                    http.message = "返回数据无法解析"
                    
                    callBack(http)
                    return
                }
                
                if let code = resultDic["c"] as? Int {
                    http.code = code
                }
                
                if let message = resultDic["m"] as? String{
                    http.message = message
                }
                
                http.success = (http.code == 200)
                
                if let data = resultDic["d"] as? Dictionary<String, Any>{
                    http.data = data
                }
                
                callBack(http)
        }
    }
}

