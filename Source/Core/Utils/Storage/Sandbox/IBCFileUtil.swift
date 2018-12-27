//
//  NLKFileUtil.swift
//  EnnewLaikang
//
//  Created by 道浪 on 2018/3/9.
//  Copyright © 2018年 Enn. All rights reserved.
//

import UIKit

/// 文件存储工具类, 用法：NLKFileUtil.init(catalog: "paipai")
public class IBCFileUtil: NSObject {
    /// 存储目录
    fileprivate var catalog: String = ""
    
    
    /// 根据存储目录实例化文件工具类
    ///
    /// - Parameter catalog: 文件夹名称，如：paipai
    public init(catalog: String) {
        super.init()
        self.catalog = "/\(catalog)"
    }

    /// 保存图片至沙盒中
    ///
    /// - Parameter imgs: 图片对象
    /// - Returns: 返回存储路径
    public func saveImageToSandbox(imgs: [UIImage]) -> [String]{
        var paths = [String]()
        
        var i = 0
        let nowTime = Int(Date().timeIntervalSince1970*1000)
        for img in imgs{
            let filePath = getFilePath(fileName: "\(Int(nowTime + i)).jpg")
            
            let data = UIImageJPEGRepresentation(img, 1)
            do{
                try data?.write(to: URL.init(fileURLWithPath: filePath))
                paths.append(filePath)
            }catch{
                IBCLog("存储失败: \(error.localizedDescription)")
            }
            i += 1
        }
        
        return paths
    }
    
    /// 文件存储至沙盒
    ///
    /// - Parameters:
    ///   - data: 文件流
    ///   - fileName: 文件名
    ///   - fileType: 文件类型
    /// - Returns: 存储路径
    public func saveFileToSanbox(_ data: Data, fileName: String = "", fileType: String) -> String{
        var newFileName = fileName
        if fileName == ""{
            newFileName = "\(Int(Date().timeIntervalSince1970*1000))"
        }
        let filePath = getFilePath(fileName: "\(newFileName).\(fileType)")
        
        do{
            try data.write(to: URL.init(fileURLWithPath: filePath))
            return filePath
        }catch{
            IBCLog("存储失败: \(error.localizedDescription)")
        }
        return ""
    }
    
    /// 保存model数组
    ///
    /// - Parameter models: 需要保存的model数组
    /// - Returns: 返回文件存储路径  失败为空
    public func saveArrayToSanBox(models: [IBCModelBase], fileName: String) -> String{
        var array: [Dictionary<String, Any>] =  [Dictionary<String, Any>]()
        
        for model in models{
            array.append(model.values())
        }
        
        let filePath = getFilePath(fileName: fileName)
        
        let sucess = (array as NSArray).write(toFile: filePath, atomically: true)
        
        if sucess{
            IBCLog("文件存储成功： \(fileName)")
            return filePath
        }else{
            IBCLog("文件存储失败： \(fileName)")
            return ""
        }
    }

    /// 保存dic数组
    ///
    /// - Parameter dics: 需要保存的dic数组
    /// - Returns: 返回文件存储路径  失败为空
    public func saveArrayToSanBox(dics: [Dictionary<String, Any>], fileName: String) -> String{
        let filePath = getFilePath(fileName: fileName)
        
        let sucess = (dics as NSArray).write(toFile: filePath, atomically: true)
        
        if sucess{
            IBCLog("文件存储成功： \(fileName)")
            return filePath
        }else{
            IBCLog("文件存储失败： \(fileName)")
            return ""
        }
    }
    
    /// 根据文件名称获取数据
    ///
    /// - Parameter fileName: 文件名称
    /// - Returns: 返回数组集合
    public func getArrayWith(fileName: String) -> [Dictionary<String, Any>]{
        guard let array = NSArray.init(contentsOfFile: getFilePath(fileName: fileName)) as? [Dictionary<String, Any>] else{
            return [Dictionary<String, Any>]()
        }
        
        return array
    }
    
    
    /// 根据提供路径删除文件
    ///
    /// - Parameter paths: 文件路径
    public func deleteFiles(paths: [String]){
        let fileManager = FileManager.default
        for path in paths{
            do{
                try fileManager.removeItem(atPath: path)
            }catch{
                IBCLog("删除失败: \(error.localizedDescription)")
            }
        }
    }
    
    
    /// 删除所有
    public func deleteAll(){
        let fileManager = FileManager.default
        do{
            try fileManager.removeItem(atPath: getFilePath(fileName: ""))
            
        }catch{
            IBCLog("删除失败: \(error.localizedDescription)")
        }
    }
    
    /// 根据文件名删除
    ///
    /// - Parameter fileName: 文件名
    public func deleteFileWith(fileName: String){
        let fileManager = FileManager.default
        do{
            try fileManager.removeItem(atPath: getFilePath(fileName: fileName))
        }catch{
            IBCLog("删除失败: \(error.localizedDescription)")
        }
    }
    
    /// 获取当前APP沙盒路径
    ///
    /// - Returns: 返回路径
    fileprivate func getMainPath() -> String{
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    }
    
    /// 根据文件名获取全路径
    ///
    /// - Parameter fileName: 文件名
    /// - Returns: 返回路径
    public func getFilePath(fileName: String) -> String{
        let fileCatalog = getMainPath().appending(catalog)
        let fileManager = FileManager.default
        var directory: ObjCBool = ObjCBool(true)
        let exit = fileManager.fileExists(atPath: fileCatalog, isDirectory: &directory)
        
        if !exit{
            do{
                try fileManager.createDirectory(atPath: fileCatalog, withIntermediateDirectories: true, attributes: nil)
            }catch{
                IBCLog("创建目录失败: \(error.localizedDescription)")
            }
        }
        
        let filepath = "\(fileCatalog)/\(fileName)"
        
        return filepath
    }
}
