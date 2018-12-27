//
//  IBCFileModel.swift
//  iOSBasisComponents
//
//  Created by 道浪 on 2018/9/18.
//  Copyright © 2018年 HDL. All rights reserved.
//

import UIKit

public class IBCFileModel: IBCModelBase {
    static let fileKey = "FilePaths"
    /// 文件名称
    public var fileName: String = ""
    /// 文件类型
    public var fileType: String = ""
    /// 本地存储路径
    public var filePath: String = ""
    /// 文件链接
    public var fileUrl: String = ""
    
    public override init() {
        super.init()
    }
    
    public override init(dic: Dictionary<String, Any>) {
        super.init(dic: dic)
        
        let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        filePath = "\(documentPath)/\(filePath)"
    }
    
    /// 存储至沙盒
    ///
    /// - Parameter model: 文件模型
    public class func saveToUserDefault(_ model: IBCFileModel){
        var arrays = IBCFileModel.getFileDics()
        arrays.append(model.values())
        
        UserDefaults.standard.setValue(arrays, forKey: fileKey)
    }
    
    /// 获取已存储
    ///
    /// - Returns:
    public class func getFileModels() -> [IBCFileModel]{
        var arrays = [IBCFileModel]()
        
        let historyArrays = getFileDics()
        
        for dic in historyArrays{
            arrays.append(IBCFileModel.init(dic: dic))
        }
        
        return arrays
    }
    
    /// 获取文件字典数组
    ///
    /// - Returns: 返回已存储
    public class func getFileDics() -> [Dictionary<String, Any>]{
        guard let historyArrays = UserDefaults.standard.array(forKey: fileKey) as? [Dictionary<String, Any>] else{
            return [Dictionary<String, Any>]()
        }
        
        return historyArrays
    }
}
