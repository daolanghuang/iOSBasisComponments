//
//  IBCHttp.swift
//  iOSBasisComponents
//
//  Created by 道浪 on 2017/8/25.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit
import Alamofire

public enum ImageType: String{
    case jpg = "JPEG"
    case png = "PNG"
    case mp4 = "MP4"
}

public struct IBCUploadFile{
    /// 名称
    public var name: String!
    /// 上传类型： JPEG/PNG/MP4
    public var type: ImageType = .jpg
    /// 本地连接地址
    public var localUrl: URL!
    /// data
    public var data: Data!
    
    public init(name: String, type: ImageType, localUrl: URL?, data: Data?) {
        self.name = name
        self.type = type
        self.localUrl = localUrl
        self.data = data
    }
}

/// CitizenCloud Http Api
open class IBCHttp: NSObject {
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
    ///   - callBack: IBCHttp回调
    public class func request(heards: Dictionary<String, String>? = nil, url: String = "", method: String = "post", params: Dictionary<String, Any>? = nil, isJSON: Bool = true,callBack: @escaping ((IBCHttp) -> Void)){
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
        if let userToken = UserDefaults.standard.value(forKey: "UserToken") as? String{
            urlRequest.setValue(userToken, forHTTPHeaderField: "userToken")
        }
        
        if let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String{
            urlRequest.setValue(deviceToken, forHTTPHeaderField: "deviceToken")
        }
        
        if heards != nil{
            for (key, value) in heards!{
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        Alamofire.request(urlRequest).responseJSON { response in
            let http = self.init()
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
            
            http.data = resultDic["d"]
            
            http.success = (http.code == 200)
            
            callBack(http)
        }
    }
    /// 默认图片上传
    ///
    /// - Returns:
    public class func upload(urlStr: String, datas: [IBCUploadFile], callBack:@escaping((IBCHttp) -> Void), isJson: Bool = false, uploadProgress: @escaping ((Progress) -> Void) = {(progress) in }){
        let urlR = URL(string: urlStr)!
        var urlRequest = URLRequest(url: urlR)
        urlRequest.httpMethod = "POST"
        
        //设置contentType为 application/json
        if isJson{
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        //回调Model
        let http = self.init()
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for file in datas{
                if file.localUrl != nil{
                    multipartFormData.append(file.localUrl, withName: file.name, fileName: file.name, mimeType: file.type.rawValue)
                }else if file.data != nil{
                    multipartFormData.append(file.data, withName: file.name, fileName: file.name, mimeType: file.type.rawValue)
                }
            }
        }, with: urlRequest, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("progress = \(progress)")
                    uploadProgress(progress)
                })
                upload.responseJSON { response in
                    
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
                    
                    if let code = resultDic["code"] as? Int {
                        http.code = code
                    }
                    
                    if let message = resultDic["message"] as? String{
                        http.message = message
                    }
                    
                    if let success = resultDic["success"] as? Bool{
                        http.success = success
                    }
                    if let data = resultDic["data"] as? Dictionary<String, Any>{
                        http.data = data
                    }else{
                        if let data = resultDic["Data"] as? Dictionary<String, Any>{
                            http.data = data
                        }
                    }
                    
                    
                    callBack(http)
                }
            case .failure(let encodingError):
                print(encodingError)
                
                http.code = -1
                http.message = encodingError.localizedDescription
                callBack(http)
            }
        })
    }
    
    /// 下载文件
    ///
    /// - Returns: 
    public class func download(urlStr: String, callBack:@escaping((IBCHttp) -> Void), downloadProgress: @escaping ((Progress) -> Void) = {(progress) in }){
        //回调Model
        let http = self.init()
        
        var filePath = ""
        
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            filePath = "download/\(response.suggestedFilename!)"
            let fileURL = documentsURL.appendingPathComponent(filePath)
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download(urlStr, to: destination).response { (response) in
            print(response)
            
            if let path = response.destinationURL?.path {
                let model = IBCFileModel()
                model.fileUrl = urlStr
                model.filePath = filePath
                
                IBCFileModel.saveToUserDefault(model)
                
                print("path = \(path)")
                
                http.success = true
                http.message = path
                callBack(http)
                
                
            }else{
                http.success = false
                if let errorMessage = response.error?.localizedDescription{
                    http.message = errorMessage
                }
                
                callBack(http)
            }
        }
    }
    
}

