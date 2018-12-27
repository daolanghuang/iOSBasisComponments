//
//  UIImage+CCExtension.swift
//  CitizenCloud
//
//  Created by 道浪 on 2017/8/16.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit

public extension UIImage{
    /// 截取指定位置
    ///
    /// - Parameters:
    ///   - image: 目标Image
    ///   - rect: 截取区域
    /// - Returns: 返回截图
    public class func cutImageWithRect(_ image: UIImage, rect: CGRect) -> UIImage{
        var cgImage: CGImage!
        if image.cgImage == nil{
            if let ciImage = image.ciImage{
                cgImage = CIContext.init().createCGImage(ciImage, from: ciImage.extent)
            }else{
                return UIImage()
            }
        }else{
            cgImage = image.cgImage
        }
        if let imageRef = cgImage.cropping(to: rect){
            return UIImage(cgImage: imageRef)
        }
        
        return UIImage()
    }
    
    /// 将图片压缩到指定大小
    ///
    /// - Parameter size: 指定大小（KB）
    /// - Returns: 返回Data类型数据
    func scaleImage(_ size: Int) -> Data{
        var imagedata = UIImageJPEGRepresentation(self, 1)!
        let imgLength = imagedata.count/1024
        if  imgLength > size{
            imagedata = UIImageJPEGRepresentation(self, CGFloat(size)/CGFloat(imgLength))!
        }
        return imagedata
    }
    
    /// 将图片压缩到指定尺寸
    ///
    /// - Parameter size: 指定尺寸
    /// - Returns: 返回Image对象
    func scaleImageWithSize(_ reSize: CGSize) -> UIImage{
        // 打开图片编辑模式
        
        UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale)
        
        // 修改图片长和宽
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: reSize))
        
        // 生成新图片
        
        let img_new = UIGraphicsGetImageFromCurrentImageContext()!
        
        // 关闭图片编辑模式
        
        UIGraphicsEndImageContext()
        return img_new
    }
    
    /// 将颜色转换为图片
    ///
    /// - Parameter color: 返回生成图像（Optional）
    class func initWithColor(_ color: UIColor, height: CGFloat = 1) -> UIImage?{
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: height)
        UIGraphicsBeginImageContext(CGSize.init(width: 1, height: height))
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        //        context?.makeImage()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    /// 获取不同framework中的图片文件
    ///
    /// - Parameters:
    ///   - bundleClass: 目标FrameWork中的任意class
    ///   - bundleName: 目标FrameWork名称
    ///   - imageName: 目标图片名（注意要加@2x）
    ///   - type: 图片类型，默认PNG
    /// - Returns: 返回Optional（UIImage）
    class func bundleImage(bundleClass: AnyClass, bundleName: String, imageName: String, type: String = "png") -> UIImage?{
        var imgName = imageName
        if !imgName.contains("@2x"){
            imgName = "\(imgName)@2x"
        }
        
        let podBundle = Bundle.init(for: bundleClass)
        guard let bundleUrl = podBundle.url(forResource: bundleName, withExtension: "bundle") else{
            print("bundleName = \(bundleName), imageName = \(imgName), bundleUrl 获取失败")
            return nil
        }
        
        guard let bundle = Bundle.init(url: bundleUrl) else{
            print("bundleName = \(bundleName) 未找到")
            return nil
        }
        
        guard let path = bundle.path(forResource: imgName, ofType: type) else{
            print("bundleName = \(bundleName), imgName = \(imgName), 图片未找到")
            return nil
        }
        
        var img = UIImage.init(contentsOfFile: path)
        
        if img == nil{
            img = UIImage.init(named: imgName.replacingOccurrences(of: "@2x", with: ""))
        }
        
        return img
    }
    
    /// 获取不同framework中的文件路径
    ///
    /// - Parameters:
    ///   - bundleClass: 目标FrameWork中的任意class
    ///   - bundleName: 目标FrameWork名称
    ///   - fileName: 目标图片名（注意要加@2x）
    ///   - type: 图片类型，默认PNG
    /// - Returns: 返回Optional（UIImage）
    class func bundleFile(bundleClass: AnyClass, bundleName: String, fileName: String, type: String = "plist") -> String?{
        let podBundle = Bundle.init(for: bundleClass)
        guard let bundleUrl = podBundle.url(forResource: bundleName, withExtension: "bundle") else{
            print("bundleName = \(bundleName), imageName = \(fileName), bundleUrl 获取失败")
            return nil
        }
        
        guard let bundle = Bundle.init(url: bundleUrl) else{
            print("bundleName = \(bundleName) 未找到")
            return nil
        }
        
        guard let path = bundle.path(forResource: fileName, ofType: type) else{
            print("bundleName = \(bundleName), fileName = \(fileName), 文件未找到")
            return nil
        }
        
        return path
    }
}

