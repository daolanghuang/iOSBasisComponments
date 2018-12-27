//
//  UIView+CCExtension.swift
//  CitizenCloud
//
//  Created by 道浪 on 2017/8/16.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit


public extension UIView{
    /// 顶部
    ///
    /// - Returns: self.frame.origin.y
    func top() -> CGFloat{
        return self.frame.origin.y
    }
    
    /// 底部坐标
    ///
    /// - Returns: self.frame.origin.y + self.frame.height
    func bottom() -> CGFloat{
        return self.frame.origin.y + self.frame.height
    }
    
    /// 左侧坐标
    ///
    /// - Returns: self.frame.origin.x
    func left() -> CGFloat{
        return self.frame.origin.x
    }
    
    /// 右侧坐标
    ///
    /// - Returns: self.frame.origin.x + self.frame.size.width
    func right() -> CGFloat{
        return self.frame.origin.x + self.frame.size.width
    }
    
    /// 宽
    ///
    /// - Returns: 宽
    func width() -> CGFloat{
        return self.frame.width
    }
    
    /// 髙
    ///
    /// - Returns: 髙
    func height() -> CGFloat{
        return self.frame.height
    }
    
    /// 相对屏幕的位置
    ///
    /// - Returns: self.convert(self.bounds, to: window)
    func rectToWindow() -> CGRect{
        let window = UIApplication.shared.windows[0]
        let rect = self.convert(self.bounds, to: window)
        
        return rect
    }
    
    /// 获取当前ViewController
    ///
    /// - Parameter view:
    /// - Returns:
    func getViewController(_ view: UIView) -> UIViewController{
        if let viewController = view.next as? UIViewController{
            return viewController
        }else{
            return getViewController(view.superview!)
        }
    }
    
    /// 获取当前Window
    func getNowWindow() -> UIWindow?{
        var window = UIApplication.shared.keyWindow
        
        if (window?.windowLevel != UIWindowLevelNormal)
        {
            let windows = UIApplication.shared.windows
            for w in windows{
                if w.windowLevel == UIWindowLevelNormal{
                    window = w
                    break
                }
            }
        }
        
        return window
    }
    
    
    /// 设置渐变颜色数组
    ///
    /// - Parameter colors: 颜色数组
    func setGradientBgColor(colors: [CGColor]){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
