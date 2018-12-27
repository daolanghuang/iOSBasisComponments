//
//  HttpUrlGet.swift
//  iOSBasisComponents
//
//  Created by 道浪 on 2018/8/9.
//  Copyright © 2018年 Enn. All rights reserved.
//

import UIKit

enum LKUrlType: String{
    /// 用户中心
    case userCenter = "userCenter"
    /// 上传图片
    case uploadImg = "uploadImg"
    /// 网易云信  医生后台
    case nim = "nim"
    /// 来康后台
    case lkService = "lkService"
    /// 健康档案
    case phr = "phr"
}

public class HttpUrlGet: NSObject {
    /// 获取来康APP相关信息
    ///
    /// - Returns: 返回相关信息
    public class func getLKAppConfigInfo() -> (appCode: String, appKey: String, appSecret: String){
        return (appCode: "9000002", appKey: "rrggwwqmk", appSecret: "a8c70acbce0b25174b5b01ec41a3d664")
    }
    
    /// 获取来康APP用户中心接口地址
    ///
    /// - Returns: 接口请求地址
    public class func getLKUserCenterUrl() -> String{
        return getUrlWith(.userCenter)
    }
    
    /// 获取来康APP上传图片地址
    ///
    /// - Returns: 接口请求地址
    public class func getLKUploadImgUrl() -> String{
        return getUrlWith(.uploadImg)
    }
    
    /// 获取来康APP后台服务地址
    ///
    /// - Returns: 接口请求地址
    public class func getLKAppSeviceUrl() -> String{
        return getUrlWith(.lkService)
    }
    
    /// 获取网易云信(医生后台)地址
    ///
    /// - Returns: 接口请求地址
    public class func getNIMUrl() -> String{
        return getUrlWith(.nim)
    }
    
    /// 获取健康档案接口地址
    ///
    /// - Returns: 接口请求地址
    public class func getPHRUrl() -> String{
        return getUrlWith(.phr)
    }
    
    
    /// 根据URL类型获取URL
    ///
    /// - Parameter type: url类型
    /// - Returns: url
    class func getUrlWith(_ type: LKUrlType) -> String{
        guard let path = UIImage.bundleFile(bundleClass: HttpUrlGet.classForCoder(), bundleName: "LK", fileName: "LKURL", type: "plist") else{
            return ""
        }
        
        guard let dic = NSDictionary.init(contentsOfFile: path) as? Dictionary<String, Any> else{
            return ""
        }
        
        guard let urlDic = dic[type.rawValue] as? Dictionary<String, Any> else{
            return ""
        }
        
        guard let url = urlDic[ibcEnvironment.rawValue] as? String else{
            return ""
        }
        
        return url
    }
}
