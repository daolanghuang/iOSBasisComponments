//
//  CCJSWebViewMode.swift
//  CCAppManager
//
//  Created by 道浪 on 2017/9/4.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit
import JavaScriptCore
/// 需要访问非本framework资源
public protocol CCWebViewModuleDelegate: CCModuleBaseDelegate {
    /// 隐藏导航栏
    func hiddenNavigation(_ isHidden: Bool)
    
    /// 设置标题
    ///
    /// - Parameter params: title
    func setMTitle(_ title: String)
}

///H5调用方法定义
@objc protocol CCJSWebViewModuleBaseDelegate: JSExport {
    /// 隐藏导航栏
    func hiddenNavigation(_ params: JSValue)
    
    /// 设置标题
    ///
    /// - Parameter params: title
    func setTitle(_ params: JSValue)
}

@objc public class CCJSWebViewMode: CCJSModel, CCJSWebViewModuleBaseDelegate {
    weak var withoutDelegate: CCWebViewModuleDelegate?
    
    /// 隐藏导航栏
    public func hiddenNavigation(_ params: JSValue){
        withoutDelegate?.hiddenNavigation(params.forProperty("isHidden")!.toBool())
    }
    
    /// 设置标题
    ///
    /// - Parameter params: title
    public func setTitle(_ params: JSValue){
        withoutDelegate?.setMTitle(params.forProperty("title")!.toString())
    }
}
