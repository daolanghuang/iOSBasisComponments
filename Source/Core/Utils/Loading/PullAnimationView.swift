//
//  PullAnimationView.swift
//  iOSBasisComponents
//
//  Created by 道浪 on 2017/8/25.
//  Copyright © 2017年 enn. All rights reserved.
//

import UIKit

public class PullAnimationView: UIView {
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    fileprivate let spotLayer = CAShapeLayer()
    fileprivate let spotReplicatorLayer = CAReplicatorLayer()
    fileprivate let spotCount = 3
    public var isLoading = false
    fileprivate let positionAnimation: CAKeyframeAnimation = {
        let positionAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        positionAnimation.beginTime = CACurrentMediaTime()
        var values = [NSNumber]()
        values.append(NSNumber.init(value: 1))
        values.append(NSNumber.init(value: 0))
        values.append(NSNumber.init(value: 1))
        values.append(NSNumber.init(value: 2))
        values.append(NSNumber.init(value: 1))
        positionAnimation.values = values
        //positionAnimation.keyTimes = [0.0, 0.33, 0.63, 1.0]
        positionAnimation.repeatCount = Float.infinity
        positionAnimation.duration = 1
        
        return positionAnimation
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override public func didMoveToWindow() {
        super.didMoveToWindow()
        updateUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PullAnimationView{
    fileprivate func setupUI(){
        spotLayer.frame = CGRect(x: 0, y: 0, width: lineWidth, height: lineWidth)
        spotLayer.lineCap = kCALineCapRound
        spotLayer.lineJoin = kCALineJoinRound
        spotLayer.lineWidth = lineWidth
        spotLayer.fillColor = loadingTintColor.cgColor
        spotLayer.strokeColor = loadingTintColor.cgColor
        spotLayer.path = UIBezierPath(ovalIn: spotLayer.bounds).cgPath
        spotReplicatorLayer.addSublayer(spotLayer)
        
        spotReplicatorLayer.instanceCount = spotCount
        spotReplicatorLayer.instanceDelay = animationDuration / 5
        layer.addSublayer(spotReplicatorLayer)
        
    }
    
    fileprivate func updateUI() {
        spotLayer.frame = CGRect(x: lineWidth / 2.0, y: (bounds.height - lineWidth) / 2.0, width: lineWidth, height: lineWidth)
        spotReplicatorLayer.frame = bounds
        spotReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(bounds.width / CGFloat(spotCount), 0, 0)
    }
}

extension PullAnimationView{
    var animationDuration: TimeInterval {
        return 1
    }
    
    var lineWidth: CGFloat {
        return 4
    }
    
    var loadingTintColor: UIColor {
        return ThemeColor
    }
}

extension PullAnimationView{
    public func startLoading() {
        //        guard !isLoading else {
        //            return
        //        }
        isLoading = true
        
        //        let centerY = bounds.height / 2.0
        //        let downY = centerY + 15
        
        spotLayer.contentsScale = 0
        spotLayer.add(positionAnimation, forKey: "positionAnimation")
    }
    
    public func stopLoading() {
        guard isLoading else {
            return
        }
        self.isLoading = false
        self.spotLayer.removeAllAnimations()
    }
}

