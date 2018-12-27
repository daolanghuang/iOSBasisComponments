//
//  UIColor+CCExtension.swift
//  CitizenCloud
//
//  Created by 道浪 on 2017/8/16.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit

public extension UIColor{
    /// 16进制颜色转换
    ///
    /// - Parameter hex: 16
    /// - Returns: color
    class func colorWithHexString (_ hex:String) -> UIColor {
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (cString.hasPrefix("#")) {
            
            cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = cString.substring(to: cString.characters.index(cString.startIndex, offsetBy: 2))
        let gString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 2)).substring(to: cString.characters.index(cString.startIndex, offsetBy: 2))
        let bString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 4))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green:CGFloat(g) / 255.0, blue:CGFloat(b) / 255.0, alpha:CGFloat(1))
    }
    
    
    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    /// 根据16进制颜色值获取UIColor
    ///
    /// - Parameter hex: 16进制
    /// - Returns:
    class func colorWithHex(_ hex: UInt) -> UIColor {
        let r: CGFloat = CGFloat((hex & 0xff0000) >> 16)
        let g: CGFloat = CGFloat((hex & 0x00ff00) >> 8)
        let b: CGFloat = CGFloat(hex & 0x0000ff)
        
        return rgb(r, green: g, blue: b)
    }
    
    /// 获取当前颜色的RGB值
    ///
    /// - Returns: 返回元组（Optional）
    func getRGB() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)?{
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        let sucess = self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        if sucess{
            return (r: CGFloat(red), g: CGFloat(green), b: CGFloat(blue), a: CGFloat(alpha))
        }else{
            return nil
        }
    }
}
