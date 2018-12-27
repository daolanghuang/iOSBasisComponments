//
//  PermissionsUtil.swift
//  iOSBasisComponents
//
//  Created by 道浪 on 2018/5/3.
//  Copyright © 2018年 Enn. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

open class PermissionsUtil: NSObject {
    /// 校验拍照权限
    ///
    /// - Returns: 权限
    public class func cameraPermissions() -> Bool{
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if(authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted) {
            let util = IBCDialogUtil.init(with: .guide, hintMessage: "未开启相机权限，是否前往开启？")
            util.addCallBack {
                if let url = URL.init(string: UIApplicationOpenSettingsURLString){
                    if UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.openURL(url)
                    }
                }
                
            }
            util.show()
            return false
        }else {
            return true
        }
    }
    
    /// 校验读取相册权限
    ///
    /// - Returns: 权限
    public class func PhotoLibraryPermissions() -> Bool {
        
        let library:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if(library == PHAuthorizationStatus.denied || library == PHAuthorizationStatus.restricted){
            let util = IBCDialogUtil.init(with: .guide, hintMessage: "未开启相册权限，是否前往开启？")
            util.addCallBack {
                if let url = URL.init(string: UIApplicationOpenSettingsURLString){
                    if UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            util.show()
            return false
        }else {
            return true
        }
    }
}
