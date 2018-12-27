//
//  UIViewController+CCExtension.swift
//  CitizenCloud
//
//  Created by 道浪 on 2017/8/16.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit

public extension UIViewController{
    
    @available(iOS 8.0, *)
    /// 毛玻璃效果
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - style: default is .light
    /// - Returns: return VisualEffectView
    func iOS8blurAction(_ frame: CGRect, style: UIBlurEffectStyle = .light) -> UIVisualEffectView{
        
        let beffect = UIBlurEffect(style: style)
        let vusualView = UIVisualEffectView(effect: beffect)
        
        vusualView.frame = frame
        
        return vusualView
    }
    
}
