//
//  UILabel+CCExtension.swift
//  CitizenCloud
//
//  Created by 道浪 on 2017/8/16.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit

public extension UILabel{
    /// 快速获取UILabel
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - font: 字体大小 默认15
    ///   - color: 字体颜色 默认黑色
    ///   - alignment: 对齐方式 默认左居中
    class func initWith(frame: CGRect, font: CGFloat, isBold: Bool = false, color: UIColor = UIColor.black, alignment: NSTextAlignment = .left) -> UILabel{
        let label = UILabel.init(frame: frame)
        label.textColor = color
        label.font = isBold ? UIFont.boldSystemFont(ofSize: font):UIFont.systemFont(ofSize: font)
        label.textAlignment = alignment
        return label
    }
}
