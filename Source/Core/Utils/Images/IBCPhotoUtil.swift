//
//  CCPhotoUtil.swift
//  iOSBasisComponents
//
//  Created by 道浪 on 2017/9/25.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

public enum CCImageType{
    /// 图片对象
    case uiImage
    /// 图片名称
    case imageName
    /// 本地图片路径
    case imagePath
    /// 网络图片Url
    case imageUrl
}

public struct IBCVideo{
    public var thumbnailImage: UIImage!
    public var videoUrl: String!
}

public class IBCPhotoUtil: NSObject {
    //回调照片
    var callBack: (([UIImage]) -> Void)!
    //回调视频
    var videoCallBack: (([IBCVideo]) -> Void)!
    //最大选择数
    public var maxCount = 9
    //viewcontroller
    weak var controller: UIViewController!
    
    var isVideo: Bool = false
    
    /// 添加选择照片回调
    ///
    /// - Parameter callBack: 照片回调
    public func addCallBack(forSelectedPhotos callBack: @escaping (([UIImage]) -> Void)){
        self.callBack = callBack
    }
    
    /// 添加选择或拍摄视频回调
    ///
    /// - Parameter callBack: 视频回调
    public func addVideoCallBack(_ callBack: @escaping (([IBCVideo]) -> Void)){
        self.videoCallBack = callBack
    }
    
    public init(showView: UIViewController) {
        super.init()
        controller = showView
    }
    deinit {
        print("照片工具类释放了")
    }
    
    /// 显示拍照、相册选择框
    public func showAlert(_ isVideo: Bool = false){
        self.isVideo = isVideo
        
        let sheet = UIAlertController.init(title: "选择获取\(isVideo ? "视频":"照片")方式", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let action1 = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
            
        }
        
        let action2 = UIAlertAction.init(title: "拍摄", style: UIAlertActionStyle.default) {[weak self] (action) in
            self?.takePhoto()
        }
        
        let action3 = UIAlertAction.init(title: "从相册选择", style: UIAlertActionStyle.default) {[weak self] (action) in
            self?.selectImages()
        }
        
        sheet.addAction(action1)
        sheet.addAction(action2)
        sheet.addAction(action3)
        
        controller.present(sheet, animated: true, completion: nil)
    }
    
    /// 显示图片浏览
    public func showImgBrower(imgs: [Any], type: CCImageType, position: Int){
        let imgBrower = ImageBrowerViewController()
        imgBrower.imgs = imgs
        imgBrower.position = position
        imgBrower.imgType = type
        imgBrower.modalTransitionStyle = .crossDissolve
        controller.present(imgBrower, animated: true)
    }
    
    public func takePhoto(){
        guard PermissionsUtil.cameraPermissions() else{
            return
        }
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            let imagePickerController:UIImagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true//true为拍照、选择完进入图片编辑模式
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            if isVideo{
               imagePickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
            }
            
            controller.present(imagePickerController, animated: true)
        }
    }
    public func selectImages(){
        guard PermissionsUtil.PhotoLibraryPermissions() else{
            return
        }
        let vc = SelectPictureViewController()
        vc.callBack = callBack
        vc.maxCount = maxCount
        controller.present(vc, animated: true)
    }
}

extension IBCPhotoUtil: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //MARK:imagePickerController delegate
    public func imagePickerControllerDidCancel(_ picker:UIImagePickerController){
        picker.dismiss(animated: false, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        picker.dismiss(animated: false, completion: nil)
        callBack([image])
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info["UIImagePickerControllerEditedImage"] as? UIImage{
            callBack([img])
        }else if let url = info["UIImagePickerControllerMediaURL"] as? URL{
            var videoStruct = IBCVideo.init()
            videoStruct.videoUrl = url.absoluteString
            videoStruct.thumbnailImage = getThumbnail(url)
            
            videoCallBack([videoStruct])
        }
        
        picker.dismiss(animated: false, completion: nil)
    }
    
    public func getThumbnail(_ url: URL) -> UIImage{
        let avAsset = AVAsset.init(url: url)
        
        //生成视频截图
        let generator = AVAssetImageGenerator(asset: avAsset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(0.0,600)
        var actualTime:CMTime = CMTimeMake(0,0)
        
        if let imageRef: CGImage = try? generator.copyCGImage(at: time, actualTime: &actualTime){
            return UIImage.init(cgImage: imageRef)
        }else{
            return UIImage()
        }
    }
}


