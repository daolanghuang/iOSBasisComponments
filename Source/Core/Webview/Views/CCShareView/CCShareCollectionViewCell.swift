//
//  CCShareCollectionViewCell.swift
//  CCAPPTest
//
//  Created by 廖望 on 2017/9/27.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit
import SnapKit

public class CCShareCollectionViewCell: UICollectionViewCell {
    var imgView: UIImageView?
    var textLabel: UILabel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customUI() {
        let cellWidth = self.bounds.width
        let bl = UIScreen.main.bounds.width/375.0
        imgView = UIImageView()
        self.contentView.addSubview(imgView!)
        imgView?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.contentView.snp.top)
            make.left.equalTo(self.contentView.snp.left)
            make.width.equalTo(cellWidth)
            make.height.equalTo(cellWidth)
        })
        textLabel = UILabel()
        textLabel?.font = UIFont.systemFont(ofSize: 11.0)
        textLabel?.textAlignment = .center
        textLabel?.textColor = UIColor.init(red: 92.0/255.0, green: 92.0/255.0, blue: 92.0/255.0, alpha: 1.0)
        self.contentView.addSubview(textLabel!)
        textLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo((imgView?.snp.bottom)!).offset(7.0*bl)
            make.left.equalTo(self.contentView.snp.left)
            make.right.equalTo(self.contentView.snp.right)
            make.height.equalTo(11.0*bl)
        })
    }
    
    func refreshShareCell(imgName: String, textName: String) {
        imgView?.image = UIImage.bundleImage(bundleClass: CCShareMenuView.self, bundleName: "Core", imageName: imgName)
        textLabel?.text = textName
    }
}

