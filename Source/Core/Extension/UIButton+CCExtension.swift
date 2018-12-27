//
//  UIButton+CCExtension.swift
//  CitizenCloud
//
//  Created by 道浪 on 2017/8/16.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit

public extension UIButton{
    /// 设置背景色默认点击效果
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - title: 按钮标题 默认为空
    ///   - titleColor: 字体颜色 默认黑色
    ///   - titleFont: 字体大小 默认15
    ///   - backgroundColor: 按钮背景色 默认透明
    ///   - selectedBackgroundColor: 选中背景颜色 默认透明
    class func initWith(frame: CGRect, title: String = "", titleColor: UIColor = UIColor.black, isBold: Bool = false, titleFont: CGFloat, backgroundColor: UIColor = UIColor.clear, selectedBackgroundColor: UIColor = UIColor.clear) -> UIButton{
        let button = UIButton.init(frame: frame)
        
        button.setTitle(title, for: UIControlState.normal)
        button.setTitleColor(titleColor, for: UIControlState.normal)
        button.titleLabel?.font = isBold ? UIFont.boldSystemFont(ofSize: titleFont):UIFont.systemFont(ofSize: titleFont)
        
        if backgroundColor != UIColor.clear{
            var highlightedColor: UIColor?
            let rgba = backgroundColor.getRGB()
            if rgba != nil{
                highlightedColor = UIColor.init(red: rgba!.r, green: rgba!.g, blue: rgba!.b, alpha: rgba!.a*3/4)
            }
            
            button.setBackgroundImage(UIImage.initWithColor(backgroundColor), for: UIControlState.normal)
            if highlightedColor != nil{
                button.setBackgroundImage(UIImage.initWithColor(highlightedColor!), for: UIControlState.highlighted)
            }
        }
        
        if selectedBackgroundColor != UIColor.clear{
            button.setBackgroundImage(UIImage.initWithColor(selectedBackgroundColor), for: UIControlState.selected)
        }
        
        return button
    }
    
}
