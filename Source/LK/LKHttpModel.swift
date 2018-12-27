//
//  LKHttpModel.swift
//  EnnewLaikang
//
//  Created by 廖望 on 2018/3/16.
//  Copyright © 2018年 Enn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

open class LKHttpModel: NSObject {
    ///请求状态码
    public var code: Int = -1
    ///请求失败提示语句
    public var message: String = "请求失败"
    ///返回数据
    public var data: JSON!
    ///请求成功状态
    public var isSuccessed: Bool = false
    
    public func desp() -> String{
        return  "{data : \(data)}"
    }
    
    required public override init() {
        super.init()
    }
    
    
    /// 发起网络请求code=200
    ///
    /// - Parameters:
    ///   - url: 请求地址
    ///   - requestMehtod: 请求HTTPMethod
    ///   - params: 请求参数
    ///   - callBack: 请求回调
    public class func request(requestHeaders: Dictionary<String, Any>? = nil, url: String = "", requestMehtod: HTTPMethod, params: Dictionary<String, Any>? = nil, callBack: @escaping ((LKHttpModel) -> Void)) {
        guard IBCReachableUtil.share.isReachable else{
            let httpResult = self.init()
            httpResult.code = -1
            httpResult.message = "网络已断开"
            httpResult.isSuccessed = false
            callBack(httpResult)
            return
        }
        // 请求头
        var headers: HTTPHeaders = [
            "Accept": "application/json",
            "DeviceToken": "0066B062E977645717736C67481F63258A26814AFE9B50CBDF7998F0467D326B144A7D7BF047A1B594A8142693191E90",
            "UserToken": LKUser.shared.userToken
        ]
        
        if requestHeaders != nil{
            for key in requestHeaders!.keys{
                headers.updateValue(requestHeaders![key] as! String, forKey: key)
            }
        }
        // 编码
        var encoding: ParameterEncoding = URLEncoding.methodDependent
        if requestMehtod == .post {
            encoding = URLEncoding.httpBody
        }
        
        Alamofire.request(url, method: requestMehtod, parameters: params, encoding: encoding, headers: headers).validate(statusCode: 200..<300).validate().responseJSON { (response) in
            
            let httpResult = self.init()
            guard response.result.isSuccess else {
                if let errorMessage = response.error?.localizedDescription{
                    httpResult.message = errorMessage
                }
                callBack(httpResult)
                return
            }
            
            guard let value = response.result.value else {
                httpResult.code = -2
                httpResult.message = "返回数据为空"
                callBack(httpResult)
                return
            }
            
            let resultDic = JSON(value)
            httpResult.code = resultDic["code"].intValue
            httpResult.message = resultDic["message"].stringValue
            httpResult.data = resultDic
            if httpResult.code == 200 {
                httpResult.isSuccessed = true
            }
            callBack(httpResult)
        }
    }
    
    /// 发起网络请求code=20000
    ///
    /// - Parameters:
    ///   - url: 请求地址
    ///   - requestMehtod: 请求HTTPMethod
    ///   - params: 请求参数
    ///   - callBack: 请求回调
    public class func requestTwo(requestHeaders: Dictionary<String, Any>? = nil, url: String = "", requestMehtod: HTTPMethod, params: Dictionary<String, Any>? = nil, callBack: @escaping ((LKHttpModel) -> Void)) {
        guard IBCReachableUtil.share.isReachable else{
            let httpResult = self.init()
            httpResult.code = -1
            httpResult.message = "网络已断开"
            httpResult.isSuccessed = false
            callBack(httpResult)
            return
        }
        
        // 请求头
        var headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "DeviceToken": "0066B062E977645717736C67481F63258A26814AFE9B50CBDF7998F0467D326B144A7D7BF047A1B594A8142693191E90",
            "UserToken": LKUser.shared.userToken,
            "Authorization": LKUser.shared.userToken
        ]

        if requestHeaders != nil{
            for key in requestHeaders!.keys{
                headers.updateValue(requestHeaders![key] as! String, forKey: key)
            }
        }
        
        Alamofire.request(url, method: requestMehtod, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).validate().responseJSON { (response) in
            
            let httpResult = self.init()
            guard response.result.isSuccess else {
                if let errorMessage = response.error?.localizedDescription{
                    httpResult.message = errorMessage
                }
                callBack(httpResult)
                return
            }
            
            guard let value = response.result.value else {
                httpResult.code = -2
                httpResult.message = "返回数据为空"
                callBack(httpResult)
                return
            }
            
            let resultDic = JSON(value)
            httpResult.code = resultDic["code"].intValue
            httpResult.message = resultDic["message"].stringValue
            httpResult.data = resultDic
            if httpResult.code == 20000 {
                httpResult.isSuccessed = true
            }
            callBack(httpResult)
        }
    }
    
    
    /// 请求来康网评估的
    ///
    /// - Parameters:
    ///   - url: 请求地址
    ///   - requestMehtod: 请求HTTPMethod
    ///   - params: 请求参数
    ///   - callBack: 请求回调
    public class func requestLaiKangWang(url: String = "", requestMehtod: HTTPMethod, params: Dictionary<String, Any>? = nil, callBack: @escaping ((LKHttpModel) -> Void)) {
        guard IBCReachableUtil.share.isReachable else{
            let httpResult = self.init()
            httpResult.code = -1
            httpResult.message = "网络已断开"
            httpResult.isSuccessed = false
            callBack(httpResult)
            return
        }
        // 请求头
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "DeviceToken": "0066B062E977645717736C67481F63258A26814AFE9B50CBDF7998F0467D326B144A7D7BF047A1B594A8142693191E90",
            "UserToken": LKUser.shared.userToken
        ]
        // 编码
        var encoding: ParameterEncoding = URLEncoding.methodDependent
        if requestMehtod == .post {
            encoding = URLEncoding.httpBody
        }
        
        Alamofire.request(url, method: requestMehtod, parameters: params, encoding: encoding, headers: headers).validate(statusCode: 200..<300).validate().responseJSON { (response) in
            
            let httpResult = self.init()
            guard response.result.isSuccess else {
                if let errorMessage = response.error?.localizedDescription{
                    httpResult.message = errorMessage
                }
                callBack(httpResult)
                return
            }
            
            guard let value = response.result.value else {
                httpResult.code = -2
                httpResult.message = "返回数据为空"
                callBack(httpResult)
                return
            }
            
            let resultDic = JSON(value)
            httpResult.code = resultDic["code"].intValue
            httpResult.message = resultDic["message"].stringValue
            httpResult.data = resultDic
            if httpResult.code == 10000 {
                httpResult.isSuccessed = true
            }
            callBack(httpResult)
        }
    }
    
    
    
    
    /// 上传图片
    ///
    /// - Parameters:
    ///   - img: 图片
    ///   - imgName: 图片名字
    ///   - url: 上传地址
    ///   - callBack: 回调
    public class func uploadImages(img: UIImage, imgName: String, url: String, callBack: @escaping ((LKHttpModel) -> Void)) {
        guard IBCReachableUtil.share.isReachable else{
            let httpResult = self.init()
            httpResult.code = -1
            httpResult.message = "网络已断开"
            httpResult.isSuccessed = false
            callBack(httpResult)
            return
        }
        // 请求头
        let headers: HTTPHeaders = [
            "Accept": "*/*",
            "Content-Type": "multipart/form-data",
            "DeviceToken": "0066B062E977645717736C67481F63258A26814AFE9B50CBDF7998F0467D326B144A7D7BF047A1B594A8142693191E90",
            "UserToken": LKUser.shared.userToken
        ]
        
        Alamofire.upload(multipartFormData: { (mutalbeData) in
            let imgData = img.scaleImage(300)
            mutalbeData.append(imgData, withName: "file", fileName: imgName, mimeType: "image/jpeg")
        }, to: url, headers: headers) { (encodingResult) in
            switch encodingResult {
            case .success(request: let uploadRequest, _, _) :
                uploadRequest.responseJSON(completionHandler: { (response) in
                    let httpResult = self.init()
                    guard response.result.isSuccess else {
                        if let errorMessage = response.error?.localizedDescription{
                            httpResult.message = errorMessage
                        }
                        callBack(httpResult)
                        return
                    }
                    guard let value = response.result.value else {
                        httpResult.code = -2
                        httpResult.message = "返回数据为空"
                        callBack(httpResult)
                        return
                    }
                    let resultDic = JSON(value)
                    httpResult.code = resultDic["code"].intValue
                    httpResult.message = resultDic["message"].stringValue
                    httpResult.data = resultDic
                    if httpResult.code == 200 {
                        httpResult.isSuccessed = true
                    }
                    callBack(httpResult)
                })
            case .failure(let error):
                let httpResult = self.init()
                httpResult.message = error.localizedDescription
                callBack(httpResult)
            }
        }
        
    }
    
    /// 请求推送后台code=200
    ///
    /// - Parameters:
    ///   - url: 请求地址
    ///   - requestMehtod: 请求HTTPMethod
    ///   - params: 请求参数
    ///   - callBack: 请求回调
    public class func requestPush(url: String = "", requestMehtod: HTTPMethod, params: Dictionary<String, Any>? = nil, callBack: @escaping ((LKHttpModel) -> Void)) {
        guard IBCReachableUtil.share.isReachable else{
            let httpResult = self.init()
            httpResult.code = -1
            httpResult.message = "网络已断开"
            httpResult.isSuccessed = false
            callBack(httpResult)
            return
        }
        
        Alamofire.request(url, method: requestMehtod, parameters: params, encoding: URLEncoding.default, headers: nil).validate(statusCode: 200..<300).validate().responseJSON { (response) in
            
            let httpResult = self.init()
            guard response.result.isSuccess else {
                if let errorMessage = response.error?.localizedDescription{
                    httpResult.message = errorMessage
                }
                callBack(httpResult)
                return
            }
            
            guard let value = response.result.value else {
                httpResult.code = -2
                httpResult.message = "返回数据为空"
                callBack(httpResult)
                return
            }
            
            let resultDic = JSON(value)
            httpResult.code = resultDic["c"].intValue
            httpResult.message = resultDic["m"].stringValue
            httpResult.data = resultDic
            if httpResult.code == 200 {
                httpResult.isSuccessed = true
            }
            callBack(httpResult)
        }
 
 
    }
    
}
