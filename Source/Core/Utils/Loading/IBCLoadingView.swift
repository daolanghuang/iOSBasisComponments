//
//  ICLoadingView.swift
//  IndustrialCloud
//
//  Created by 道浪 on 2017/12/7.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit

class IBCLoadingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    /// 加载View
    let loadingView: PullAnimationView = {
        let activityView = PullAnimationView()
        activityView.frame = CGRect(x: ScreenWidth/2 - 23, y: ScreenHeight/2 - 25, width: 60, height: 50)
        return activityView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        self.addSubview(loadingView)
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
