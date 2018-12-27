//
//  UIString+CCExtension.swift
//  CitizenCloud
//
//  Created by 道浪 on 2017/8/16.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit

public extension String {
    /// 截取指定区域字符串
    ///
    /// - Parameters:
    ///   - s: 起始位置
    ///   - lenght: 长度
    /// - Returns: 目标字符串
    func substring(_ s: Int, _ lenght: Int) -> String {
        
        guard self != "" else{
            return ""
        }
        
        guard s < self.count else{
            return ""
        }
        
        var l = lenght
        
        if s + l > self.count{
            l = self.count - s
        }
        
        return self.substring(with: Range<String.Index>(NSRange.init(location: s, length: l), in: self)!)
        
    }
    
    /// 替换指定字符串
    ///
    /// - Parameters:
    ///   - startIndex: 起始位置
    ///   - endIndex: 结束位置
    ///   - replaceStr: 替换字符串
    mutating func replace(startIndex: Int, endIndex: Int, replaceStr: String){
        self.replaceSubrange(self.index(self.startIndex, offsetBy: startIndex) ..< self.index(self.startIndex, offsetBy: endIndex), with: replaceStr)
    }
    
    /// 获取当前字符串所占宽度
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - width: 最大宽度 默认屏幕宽度
    ///   - height: 最大高度 默认屏幕高度
    ///   - lineSpace: 行间距 默认
    /// - Returns: 返回宽度
    func boundingRectWidth(font: CGFloat, width: CGFloat = ScreenWidth, height: CGFloat = ScreenHeight, lineSpace: CGFloat = 0) -> CGFloat{
        var attributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: font)]
        
        if lineSpace != 0{
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpace
            attributes.updateValue(paragraphStyle, forKey: NSAttributedStringKey.paragraphStyle)
        }
        let rect = self.boundingRect(with: CGSize(width: width, height: ScreenHeight), options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], attributes: attributes, context: nil)
        
        return rect.width
    }
    
    /// 获取当前字符串所占宽度
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - width: 最大宽度 默认屏幕宽度
    ///   - height: 最大高度 默认屏幕高度
    ///   - lineSpace: 行间距 默认
    /// - Returns: 返回宽度
    func boundingRectWidth(boldfont: CGFloat, width: CGFloat = ScreenWidth, height: CGFloat = ScreenHeight, lineSpace: CGFloat = 0) -> CGFloat{
        var attributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: boldfont)]
        
        if lineSpace != 0{
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpace
            attributes.updateValue(paragraphStyle, forKey: NSAttributedStringKey.paragraphStyle)
        }
        let rect = self.boundingRect(with: CGSize(width: width, height: ScreenHeight), options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], attributes: attributes, context: nil)
        
        return rect.width
    }
    
    /// 获取当前字符串所占高度
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - width: 最大宽度 默认屏幕宽度
    ///   - height: 最大高度 默认屏幕高度
    ///   - lineSpace: 行间距 默认
    /// - Returns: 返回高度
    func boundingRectHeight(font: CGFloat, width: CGFloat = ScreenWidth, height: CGFloat = ScreenHeight, lineSpace: CGFloat = 0) -> CGFloat{
        var attributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: font)]
        
        if lineSpace != 0{
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpace
            attributes.updateValue(paragraphStyle, forKey: NSAttributedStringKey.paragraphStyle)
        }
        
        let rect = self.boundingRect(with: CGSize(width: width, height: height), options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], attributes: attributes, context: nil)
        
        return rect.height
    }
    /// 获取当前字符串所占高度
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - width: 最大宽度 默认屏幕宽度
    ///   - height: 最大高度 默认屏幕高度
    ///   - lineSpace: 行间距 默认
    /// - Returns: 返回高度
    func boundingRectHeight(boldfont: CGFloat, width: CGFloat = ScreenWidth, height: CGFloat = ScreenHeight, lineSpace: CGFloat = 0) -> CGFloat{
        var attributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: boldfont)]
        
        if lineSpace != 0{
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpace
            attributes.updateValue(paragraphStyle, forKey: NSAttributedStringKey.paragraphStyle)
        }
        
        let rect = self.boundingRect(with: CGSize(width: width, height: height), options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], attributes: attributes, context: nil)
        
        return rect.height
    }
    
    func jsonStrToDic() -> Dictionary<String, Any>?{
        guard let jsonData = self.data(using: String.Encoding.utf8) else{
            return nil
        }
        
        guard let dic = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary else{
            return nil
        }
        
        return dic as? Dictionary<String, Any>
    }
}

