//
//  CCJSSystemModel.swift
//  Pods
//
//  Created by 道浪 on 2017/9/5.
//
//

import UIKit
import JavaScriptCore
/// 需要访问非本framework资源
public protocol CCSystemModuleDelegate: CCModuleBaseDelegate {
    func getPhotos(callBack: (@escaping (([UIImage]) -> Void)))
    
    func previewImage(imgs: [UIImage])
}
///H5调用方法定义
@objc protocol CCJSSystemModuleDelegate: JSExport{
    /// 获取图片
    ///
    /// - Parameter params:
    func getPhotos()
    
    /// 预览图片
    ///
    /// - Parameter params:
    func previewImage(_ params: JSValue)
}

@objc public class CCJSSystemModel: CCJSModel, CCJSSystemModuleDelegate {
    weak var systemDelegate: CCSystemModuleDelegate?
    /// 获取图片
    ///
    /// - Parameter params:
    public func getPhotos(){
        systemDelegate?.getPhotos { (imgs: [UIImage]) in
            DispatchQueue.global().async {
                var imgs_base64 = [String]()
                for img in imgs{
                    let imgData = img.scaleImage(200)
                    let base64Str = "data:image/jpg;base64," + imgData.base64EncodedString()
                    imgs_base64.append(base64Str)
                }
                
                DispatchQueue.main.async {
                    self.callBack(CCCallBackModel.sucessModel(portName: "getPhotos", data: imgs_base64))
                }
            }
        }
    }
    
    /// 预览图片
    ///
    /// - Parameter params:
    public func previewImage(_ params: JSValue){
        if let imgStrs = params.toArray() as? [String]{
            var imgs = [UIImage]()
            for base64Str in imgStrs{
                // base64 -> Data
                guard let imgData = Data.init(base64Encoded: base64Str) else {
                    continue
                }
                
                guard let img = UIImage.init(data: imgData) else {
                    continue
                }
                imgs.append(img)
            }
            systemDelegate?.previewImage(imgs: imgs)
            
        }else{
            callBack(CCCallBackModel.failModel(portName: "previewImage", errorMessage: "数据解析错误"))
        }
    }
}
