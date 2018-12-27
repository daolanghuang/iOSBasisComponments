//
//  ImageUtil.swift
//  MailList
//
//  Created by 黄道浪 on 17/3/27.
//  Copyright © 2017年 黄道浪. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos

class ImageUtil: NSObject {
    private let assesName = "CitizenCloud"

    func save(_ images: [String]){
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: {
            
            self.saveAlbumInPhoneAlbum(images)
        })
    }
    func saveImgs(_ images: [UIImage]){
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: {
            
            self.saveImagesInPhoneAlbum(images)
        })
    }
    
    //存储视频
    func saveImagesInPhoneAlbum(_ images: [UIImage]){
        let assetsLibrary = ALAssetsLibrary()
        var hasShowGroup = false
        for image in images{
            assetsLibrary.writeImage(toSavedPhotosAlbum: image.cgImage, metadata: nil) { (url: URL?, error: Error?) in
                assetsLibrary.asset(for: url!, resultBlock: { (asset: ALAsset?) in
                    assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupAlbum, usingBlock: { (group: ALAssetsGroup?, over) in
                        if group != nil{
                            let name = group!.value(forProperty: ALAssetsGroupPropertyName) as? String
                            if name == self.assesName{
                                hasShowGroup = true
                                group!.add(asset)
                                
                                DispatchQueue.main.async(execute: {
                                    print("保存成功 : \(image.description)")
                                })
                            }
                        }else{
                            if !hasShowGroup{
                                PHPhotoLibrary.shared().performChanges({
                                    PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.assesName)
                                }, completionHandler: { (sucess: Bool?, error: Error?) in
                                    if sucess!{
                                        assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupAlbum, usingBlock: { (group: ALAssetsGroup?, over) in
                                            if group != nil{
                                                let name = group!.value(forProperty: ALAssetsGroupPropertyName) as? String
                                                if name == self.assesName{
                                                    hasShowGroup = true
                                                    group!.add(asset)
                                                    
                                                    DispatchQueue.main.async(execute: {
                                                        print("保存成功 : \(image.description)")
                                                    })
                                                }
                                            }
                                        }, failureBlock: { (error: Error?) in
                                            print("插入失败")
                                        })
                                    }
                                })
                            }else{
                                print("已经存在Show")
                            }
                        }
                        
                    }, failureBlock: { (error: Error?) in
                        print("插入失败")
                    })
                }, failureBlock: { (error: Error?) in
                    print("插入失败")
                })
            }
        }
    }
    //在手机相册中创建相册
    func saveAlbumInPhoneAlbum(_ images: [String]){
        let assetsLibrary = ALAssetsLibrary()
        var hasShowGroup = false
        for imagePath in images{
            if imagePath.contains(".jpg"){
                let image = UIImage(contentsOfFile: imagePath)!
                assetsLibrary.writeImage(toSavedPhotosAlbum: image.cgImage, metadata: nil) { (url: URL?, error: Error?) in
                    assetsLibrary.asset(for: url!, resultBlock: { (asset: ALAsset?) in
                        assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupAlbum, usingBlock: { (group: ALAssetsGroup?, over) in
                            if group != nil{
                                let name = group!.value(forProperty: ALAssetsGroupPropertyName) as? String
                                if name == self.assesName{
                                    hasShowGroup = true
                                    group!.add(asset)
                                    
                                    DispatchQueue.main.async(execute: {
                                        print("保存成功 : \(image.description)")
                                    })
                                }
                            }else{
                                if !hasShowGroup{
                                    PHPhotoLibrary.shared().performChanges({
                                        PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.assesName)
                                    }, completionHandler: { (sucess: Bool?, error: Error?) in
                                        if sucess!{
                                            assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupAlbum, usingBlock: { (group: ALAssetsGroup?, over) in
                                                if group != nil{
                                                    let name = group!.value(forProperty: ALAssetsGroupPropertyName) as? String
                                                    if name == self.assesName{
                                                        hasShowGroup = true
                                                        group!.add(asset)
                                                        
                                                        DispatchQueue.main.async(execute: {
                                                            print("保存成功 : \(image.description)")
                                                        })
                                                    }
                                                }
                                            }, failureBlock: { (error: Error?) in
                                                print("插入失败")
                                            })
                                        }
                                    })
                                }else{
                                    print("已经存在Show")
                                }
                            }
                            
                        }, failureBlock: { (error: Error?) in
                            print("插入失败")
                        })
                    }, failureBlock: { (error: Error?) in
                        print("插入失败")
                    })
                }
            }else if imagePath.contains(".MOV"){
                assetsLibrary.writeVideoAtPath(toSavedPhotosAlbum: URL.init(fileURLWithPath: imagePath), completionBlock: { (url: URL?, error: Error?) in
                    assetsLibrary.asset(for: url!, resultBlock: { (asset: ALAsset?) in
                        assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupAlbum, usingBlock: { (group: ALAssetsGroup?, over) in
                            if group != nil{
                                let name = group!.value(forProperty: ALAssetsGroupPropertyName) as? String
                                if name == self.assesName{
                                    hasShowGroup = true
                                    group!.add(asset)
                                    
                                    DispatchQueue.main.async(execute: {
                                        print("保存成功 : \(imagePath)")
                                    })
                                }
                            }else{
                                if !hasShowGroup{
                                    PHPhotoLibrary.shared().performChanges({
                                        PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.assesName)
                                    }, completionHandler: { (sucess: Bool?, error: Error?) in
                                        if sucess!{
                                            assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupAlbum, usingBlock: { (group: ALAssetsGroup?, over) in
                                                if group != nil{
                                                    let name = group!.value(forProperty: ALAssetsGroupPropertyName) as? String
                                                    if name == self.assesName{
                                                        hasShowGroup = true
                                                        group!.add(asset)
                                                        
                                                        DispatchQueue.main.async(execute: {
                                                            print("保存成功 : \(imagePath)")
                                                        })
                                                    }
                                                }
                                            }, failureBlock: { (error: Error?) in
                                                print("插入失败")
                                            })
                                        }
                                    })
                                }else{
                                    print("已经存在Show")
                                }
                            }
                            
                        }, failureBlock: { (error: Error?) in
                            print("插入失败")
                        })
                    }, failureBlock: { (error: Error?) in
                        print("插入失败")
                    })
                })
            }
        }
    }
}
