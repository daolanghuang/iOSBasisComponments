//
//  CCGetPhotos.swift
//  CCAppManager
//
//  Created by 道浪 on 2017/9/21.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit


//MARK: 调用拍照
extension CCWebViewController: CCSystemModuleDelegate{
    public func getPhotos(callBack: @escaping (([UIImage]) -> Void)){
        if photoUtil == nil{
            photoUtil = IBCPhotoUtil.init(showView: self)
        }
        photoUtil.addCallBack(forSelectedPhotos: callBack)
        photoUtil.showAlert()
    }
    
    public func previewImage(imgs: [UIImage]){
        if photoUtil == nil{
            photoUtil = IBCPhotoUtil.init(showView: self)
        }
        self.photoUtil.showImgBrower(imgs: imgs, type: CCImageType.uiImage, position: 0)
    }
}



