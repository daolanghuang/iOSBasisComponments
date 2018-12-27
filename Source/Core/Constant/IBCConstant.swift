//
//  IBCConstant.swift
//  iOSBasisComponents
//
//  Created by 道浪 on 2018/8/23.
//  Copyright © 2018年 HDL. All rights reserved.
//

import UIKit


/// 手机系统版本
public let iOSVersion: Float = {
    return (UIDevice.current.systemVersion as NSString).floatValue
}()

/// 当前应用版本
public let APPVersion: String = {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
}()

/// 当前屏幕宽度
public let ScreenWidth: CGFloat = {
    return UIScreen.main.bounds.width
}()

/// 当前屏幕高度
public let ScreenHeight: CGFloat = {
    return UIScreen.main.bounds.height
}()
/// 导航条高度
public let NavigationBarHeight: CGFloat = {
    if ScreenWidth == 375 && ScreenHeight == 812{
        //iphone X
        return 88
    }else{
        return 64
    }
}()
/// 状态栏高度
public let StatusHeight: CGFloat = {
    if ScreenWidth == 375 && ScreenHeight == 812{
        //iphone X
        return 44
    }else{
        return 20
    }
}()

/// 标签栏高度
public let TabBarHeight: CGFloat = {
    if ScreenWidth == 375 && ScreenHeight == 812{
        //iphone X
        return 83
    }else{
        return 49
    }
}()


/// 当前主题色
public var ThemeColor: UIColor = {
    return UIColor.colorWithHexString("1296db")
}()
/// 背景色
public var BackgroundColor: UIColor = {
    return UIColor.colorWithHexString("#f0f0f0")
}()
/// 标题字体颜色
public var TitleColor: UIColor = {
    return UIColor.colorWithHexString("#222222")
}()
/// 内容字体颜色
public var ContentColor: UIColor = {
    return UIColor.colorWithHexString("#858585")
}()

/// 分割线颜色
public var LineColor: UIColor = {
    return UIColor.colorWithHexString("#dddddd")
}()

public var LineHeight: CGFloat{
    return 0.5
}
public enum Environment: String{
    /// 上传APPStore版本
    case appstore = "appstore"
    /// 开发版
    case dev = "dev"
    /// 企业测试
    case qa = "qa"
    /// 企业生产
    case company = "company"
}


/// 环境
public var ibcEnvironment = Environment.dev
/// 主TargetName
public var mainTargetName = ""

/// 调试日志
///
/// - Parameters:
///   - message: 调试信息
///   - function: 方法名定位
func IBCLog(_ message: Any, function: String = #function) {
    #if DEBUG
    print("---------------\n\(function):\n \(message)\n------------------")
    #endif
}
