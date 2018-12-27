//
//  IBCManager.swift
//  iOSBasisComponents
//
//  Created by 道浪 on 2018/8/23.
//  Copyright © 2018年 HDL. All rights reserved.
//

import UIKit

public class IBCManager: NSObject {
    public static var shared: IBCManager = IBCManager()
    
    fileprivate override init() {
        super.init()
    }
    
    /// 设置基础组件颜色
    ///
    /// - Parameters:
    ///   - themeColor: 主题色
    ///   - spaceColor: 背景色
    ///   - titleColor: 标题字体色
    ///   - contentColor: 文本字体色
    ///   - lineColor: 分割线颜色
    public func setColors(themeColor: UIColor, backgroundColor: UIColor, titleColor: UIColor, contentColor: UIColor, lineColor: UIColor){
        ThemeColor = themeColor
        BackgroundColor = backgroundColor
        TitleColor = titleColor
        ContentColor = contentColor
        LineColor = lineColor
    }
    
    /// 基础组件数据初始化
    ///
    /// - Parameters:
    ///   - ebEnvironmentRawvalue: 环境
    ///   - pMianTargetName: 当前TargetName
    public func initEB(_ environmentRawvalue: String, pMianTargetName: String){
        mainTargetName = pMianTargetName
        guard let env = Environment.init(rawValue: environmentRawvalue) else{
            return
        }
        ibcEnvironment = env
    }

}
