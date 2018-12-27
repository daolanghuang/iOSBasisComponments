//
//  ICDialogUtil.swift
//  IndustrialCloud
//
//  Created by 道浪 on 2017/11/30.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit

public enum IBCHintDialogType: Int{
    /// 提示类 显示1.5秒自动隐藏
    case autohide
    /// 消息通知  取消、确定按钮  有回调
    case notification
    /// 提示类  点击确定隐藏
    case handhide
    /// 引导类  点击按钮回调  右上角x隐藏
    case guide
    /// APP更新
    case appinstall
    /// 修改密码成功提示
    case autoHideWithBlock
    /// 再次提醒(取消，确定，没有X)
    case remind
}

open class IBCDialogUtil: UIView {
    /// 左边距
    fileprivate let leftSpace: CGFloat = 10
    
    /// 展示动画
    fileprivate let scaleAnimation: CAAnimation = {
        let animation = CABasicAnimation.init(keyPath: "transform.scale")
        animation.duration = 0.2
        animation.toValue = NSNumber.init(value: 1)
        animation.fromValue = NSNumber.init(value: 1.2)
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        
        return animation
    }()
    
    //当前提示类型
    fileprivate var hintType: IBCHintDialogType = .autohide
    //回调
    fileprivate var callBack: (() -> Void)?
    
    public var autoHiddenTime: CGFloat = 1.5
    
    public init(with type: IBCHintDialogType, hintMessage: String = "", btnTitle: String = "确定", cancelTitle: String = "取消") {
        super.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.alpha = 0
        
        if type != .appinstall {
            self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.hiddenAndRemove)))
        }
        
        hintType = type
        
        switch type {
        case .autohide:
            autoHideViewInit(hintMessage)
            break
        case .handhide:
            handhideViewInit(hintMessage, btnTitle: btnTitle)
            break
        case .notification:
            notificationViewInit(hintMessage, btnTitle: btnTitle)
            break
        case .guide:
            guideViewInit(hintMessage, btnTitle: btnTitle, title: cancelTitle)
            break
        case .appinstall:
            updateViewInit(hintMessage, btnTitle: btnTitle)
            break
        case .autoHideWithBlock:
            hideWithBlockInit(hintMessage)
            break
        case .remind:
            remindViewInit(hintMessage, btnTitle: btnTitle, cancelTitle: cancelTitle)
        }
        
        getNowWindow()?.addSubview(self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func show(){
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
        
        if hintType == .autohide {
            let _ = Timer.scheduledTimer(timeInterval: TimeInterval(autoHiddenTime), target: self, selector: #selector(self.hiddenAndRemove), userInfo: nil, repeats: false)
        } else if hintType == .autoHideWithBlock {
            let _ = Timer.scheduledTimer(timeInterval: TimeInterval(autoHiddenTime), target: self, selector: #selector(self.autoHideBlockRemove), userInfo: nil, repeats: false)
        }
    }
    
    @objc public func hiddenAndRemove(){
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { (over) in
            if over{
                self.removeFromSuperview()
            }
        }
    }
    
    @objc public func autoHideBlockRemove(){
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { (over) in
            if over{
                self.callBack?()
                self.removeFromSuperview()
            }
        }
    }
    
    public func addCallBack(_ block: @escaping (() -> Void)){
        callBack = block
    }
}

//MARK: autohide
extension IBCDialogUtil{
    public func autoHideViewInit(_ hintMessage: String = ""){
        let bl = ScreenWidth/375
        let itemWidth = 260*bl
        let itemHeight = 80*bl
        
        let bgView = UIView.init(frame: CGRect.init(x: ScreenWidth/2 - itemWidth/2, y: ScreenHeight/2 - itemHeight/2, width: itemWidth, height: itemHeight))
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        
        self.addSubview(bgView)
        
        let label = UILabel.init(frame: CGRect.init(x: 15, y: 15, width: itemWidth - 30, height: itemHeight - 30))
        label.textColor = TitleColor
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.text = hintMessage
        label.numberOfLines = 0
        
        bgView.addSubview(label)
        
        bgView.layer.add(scaleAnimation, forKey: nil)
    }
}
//MARK: notification
extension IBCDialogUtil{
    public func notificationViewInit(_ hintMessage: String, btnTitle: String){
        let bl = ScreenWidth/375
        let itemWidth = 315*bl
        let itemHeight: CGFloat = 210
        
        let bgView = UIView.init(frame: CGRect.init(x: (ScreenWidth - itemWidth)/2, y: (ScreenHeight - itemHeight)/2, width: itemWidth, height: itemHeight))
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        
        self.addSubview(bgView)
        
        let imageIcon = UIImageView.init(frame: CGRect.init(x: (itemWidth - 90)/2, y: 20, width: 81, height: 81))
        imageIcon.image = UIImage.init(named: "popup_inf")
        
        bgView.addSubview(imageIcon)
        
        let label = UILabel.init(frame: CGRect.init(x: leftSpace, y: imageIcon.bottom() + 10, width: itemWidth - leftSpace*2, height: 50))
        label.textColor = TitleColor
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.text = hintMessage
        label.numberOfLines = 0
        
        bgView.addSubview(label)
        
        let textHeight = hintMessage.boundingRectHeight(font: 15, width: label.width(), height: ScreenHeight - 100)
        
        label.frame.size.height = textHeight + 10
        
        let knowBtn = UIButton.initWith(frame: CGRect.init(x: 42.5*bl, y: label.bottom() + 20, width: 100*bl, height: 33), title: "知道了", titleColor: ThemeColor, titleFont: 15, backgroundColor: UIColor.colorWithHexString("e3fef7"))
        knowBtn.layer.cornerRadius = 5
        knowBtn.clipsToBounds = true
        knowBtn.addTarget(self, action: #selector(self.hiddenAndRemove), for: UIControlEvents.touchUpInside)
        
        bgView.addSubview(knowBtn)
        
        let gotolook = UIButton.initWith(frame: CGRect.init(x: itemWidth - 142.5*bl, y: label.bottom() + 20, width: 100*bl, height: 33), title: btnTitle, titleColor: UIColor.white, titleFont: 15, backgroundColor: ThemeColor)
        gotolook.layer.cornerRadius = 5
        gotolook.clipsToBounds = true
        gotolook.addTarget(self, action: #selector(self.toLook), for: UIControlEvents.touchUpInside)
        
        bgView.addSubview(gotolook)
        
        let bgViewHeight = gotolook.bottom() + 20
        
        bgView.frame = CGRect.init(x: (ScreenWidth - itemWidth)/2, y: (ScreenHeight - bgViewHeight)/2, width: itemWidth, height: bgViewHeight)
        
        bgView.layer.add(scaleAnimation, forKey: nil)
    }
    
    @objc func toLook(){
        callBack?()
        hiddenAndRemove()
    }
}
//MARK: handhide
extension IBCDialogUtil{
    public func handhideViewInit(_ hintMessage: String, btnTitle: String){
        let bl = ScreenWidth/375
        let itemWidth = 315*bl
        let itemHeight: CGFloat = 210
        
        let bgView = UIView.init(frame: CGRect.init(x: (ScreenWidth - itemWidth)/2, y: (ScreenHeight - itemHeight)/2, width: itemWidth, height: itemHeight))
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        
        self.addSubview(bgView)
        let titleLabel = UILabel.init(frame: CGRect.init(x: leftSpace, y: 0, width: itemWidth - leftSpace*2, height: 50))
        titleLabel.textColor = ThemeColor
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.text = "温馨提示"
        
        bgView.addSubview(titleLabel)
        
        let line = UIView.init(frame: CGRect.init(x: 10, y: 50, width: itemWidth - 20, height: 0.5))
        line.backgroundColor = ThemeColor
        
        bgView.addSubview(line)
        
        let label = UILabel.init(frame: CGRect.init(x: leftSpace, y: titleLabel.bottom(), width: itemWidth - leftSpace*2, height: 80))
        label.textColor = TitleColor
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.text = hintMessage
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        
        bgView.addSubview(label)
        
        let knowBtn = UIButton.initWith(frame: CGRect.init(x: itemWidth/2 - 100*bl, y: itemHeight - 54, width: 200*bl, height: 33), title: btnTitle, titleColor: UIColor.white, titleFont: 15, backgroundColor: ThemeColor)
        knowBtn.layer.cornerRadius = 5
        knowBtn.clipsToBounds = true
        knowBtn.addTarget(self, action: #selector(self.toDo), for: UIControlEvents.touchUpInside)
        
        bgView.addSubview(knowBtn)
        
        bgView.layer.add(scaleAnimation, forKey: nil)
    }
}
//MARK: guide
extension IBCDialogUtil{
    func guideViewInit(_ hintMessage: String, btnTitle: String, title: String){
        let bl = ScreenWidth/375
        let itemWidth = 250*bl
        let itemHeight: CGFloat = 160
        
        let bgView = UIView.init(frame: CGRect.init(x: (ScreenWidth - itemWidth)/2, y: (ScreenHeight - itemHeight)/2, width: itemWidth, height: itemHeight))
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        
        self.addSubview(bgView)
        
        let titleLabel = UILabel.initWith(frame: CGRect.init(x: 0, y: 25, width: itemWidth, height: 25), font: 18, color: UIColor.init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1), alignment: .center)
        titleLabel.text = title
        
        bgView.addSubview(titleLabel)
        
        let contentLabel = UILabel.initWith(frame: CGRect.init(x: 10, y: titleLabel.bottom(), width: itemWidth - 20, height: 60), font: 15, color: UIColor.init(red: 105/255, green: 105/255, blue: 105/255, alpha: 1), alignment: .center)
        contentLabel.text = hintMessage
        
        bgView.addSubview(contentLabel)
        
        let cancleBtn = UIButton.initWith(frame: CGRect.init(x: 0, y: itemHeight - 45, width: itemWidth/2, height: 45), title: "取消", titleColor: UIColor.init(red: 178/255, green: 178/255, blue: 178/255, alpha: 1), titleFont: 16)
        cancleBtn.addTarget(self, action: #selector(self.hiddenAndRemove), for: UIControlEvents.touchUpInside)
        
        bgView.addSubview(cancleBtn)
        
        let sureBtn = UIButton.initWith(frame: CGRect.init(x: itemWidth/2, y: cancleBtn.top(), width: itemWidth/2, height: 45), title: btnTitle, titleColor: ThemeColor, titleFont: 16)
        sureBtn.addTarget(self, action: #selector(self.toDo), for: UIControlEvents.touchUpInside)
        
        bgView.addSubview(sureBtn)
        
        let line = UIView.init(frame: CGRect.init(x: 0, y: itemHeight - 45, width: itemWidth, height: 0.5))
        line.backgroundColor = LineColor
        
        bgView.addSubview(line)
        
        let shuLine = UIView.init(frame: CGRect.init(x: itemWidth/2, y: line.top(), width: 0.5, height: 45))
        shuLine.backgroundColor = LineColor
        
        bgView.addSubview(shuLine)
        
        bgView.layer.add(scaleAnimation, forKey: nil)
    }
    
    @objc func toDo(){
        callBack?()
        hiddenAndRemove()
    }
}

extension IBCDialogUtil{
    public func updateViewInit(_ hintMessage: String, btnTitle: String = "立即更新"){
        let bl = ScreenWidth/375
        let itemWidth = 315*bl
        
        let bgView = UIView.init()
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 10
        //        bgView.clipsToBounds = true
        
        self.addSubview(bgView)
        
        let imageIcon = UIImageView.init(frame: CGRect.init(x: 0, y: -23, width: itemWidth, height: itemWidth*0.462))
        imageIcon.image = UIImage.init(named: "popup_up_bg_w")
        
        bgView.addSubview(imageIcon)
        
        let label = UILabel.init(frame: CGRect.init(x: leftSpace, y: imageIcon.bottom() + 10, width: itemWidth - leftSpace*2, height: 50))
        label.textColor = TitleColor
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.text = hintMessage
        label.numberOfLines = 0
        
        bgView.addSubview(label)
        
        let textHeight = hintMessage.boundingRectHeight(font: 15, width: label.width(), height: ScreenHeight - 100)
        
        label.frame.size.height = textHeight + 10
        
        let toUpdate = UIButton.initWith(frame: CGRect.init(x: itemWidth/2 - 95*bl, y: label.bottom() + 20, width: 190*bl, height: 33), title: btnTitle, titleColor: UIColor.white, titleFont: 15, backgroundColor: ThemeColor)
        toUpdate.layer.cornerRadius = 5
        toUpdate.clipsToBounds = true
        toUpdate.addTarget(self, action: #selector(self.toUpdate), for: UIControlEvents.touchUpInside)
        
        bgView.addSubview(toUpdate)
        
        let bgViewHeight = toUpdate.bottom() + 20
        
        bgView.frame = CGRect.init(x: (ScreenWidth - itemWidth)/2, y: (ScreenHeight - bgViewHeight)/2, width: itemWidth, height: bgViewHeight)
        
        bgView.layer.add(scaleAnimation, forKey: nil)
        
        //        let cancleBtn = UIButton.init(frame: CGRect.init(x: ScreenWidth/2 - 18, y: bgView.bottom() + 25, width: 36, height: 36))
        //        cancleBtn.setImage(UIImage.init(named: "popup_del"), for: UIControlState.normal)
        //        cancleBtn.addTarget(self, action: #selector(self.hiddenAndRemove), for: UIControlEvents.touchUpInside)
        //
        //        self.addSubview(cancleBtn)
    }
    
    @objc func toUpdate(){
        callBack?()
        //        hiddenAndRemove()
    }
}

//MARK: handhide
extension IBCDialogUtil{
    public func hideWithBlockInit(_ hintMessage: String){
        let bl = ScreenWidth/375
        let itemWidth = 315*bl
        let itemHeight: CGFloat = 210
        
        let bgView = UIView.init(frame: CGRect.init(x: (ScreenWidth - itemWidth)/2, y: (ScreenHeight - itemHeight)/2, width: itemWidth, height: itemHeight))
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        
        self.addSubview(bgView)
        let titleLabel = UILabel.init(frame: CGRect.init(x: leftSpace, y: 0, width: itemWidth - leftSpace*2, height: 50))
        titleLabel.textColor = ThemeColor
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.text = "温馨提示"
        
        bgView.addSubview(titleLabel)
        
        let line = UIView.init(frame: CGRect.init(x: 10, y: 50, width: itemWidth - 20, height: 0.5))
        line.backgroundColor = ThemeColor
        
        bgView.addSubview(line)
        
        let label = UILabel.init(frame: CGRect.init(x: leftSpace, y: titleLabel.bottom(), width: itemWidth - leftSpace*2, height: itemHeight - titleLabel.bottom()))
        label.textColor = TitleColor
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.text = hintMessage
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        
        bgView.addSubview(label)
        
        bgView.layer.add(scaleAnimation, forKey: nil)
    }
}

//MARK: remind
extension IBCDialogUtil{
    public func remindViewInit(_ hintMessage: String, btnTitle: String, cancelTitle: String){
        let bl = ScreenWidth/375
        let itemWidth = 315*bl
        let itemHeight: CGFloat = 210
        
        let bgView = UIView.init(frame: CGRect.init(x: (ScreenWidth - itemWidth)/2, y: (ScreenHeight - itemHeight)/2, width: itemWidth, height: itemHeight))
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        
        self.addSubview(bgView)
        
        let imageIcon = UIImageView.init(frame: CGRect.init(x: (itemWidth - 90)/2, y: 20, width: 81, height: 81))
        imageIcon.image = UIImage.init(named: "popup_inf")
        
        bgView.addSubview(imageIcon)
        
        let label = UILabel.init(frame: CGRect.init(x: leftSpace, y: imageIcon.bottom() + 10, width: itemWidth - leftSpace*2, height: 50))
        label.textColor = TitleColor
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.text = hintMessage
        label.numberOfLines = 0
        
        bgView.addSubview(label)
        
        let textHeight = hintMessage.boundingRectHeight(font: 15, width: label.width(), height: ScreenHeight - 100)
        
        label.frame.size.height = textHeight + 10
        
        let knowBtn = UIButton.initWith(frame: CGRect.init(x: 42.5*bl, y: label.bottom() + 20, width: 100*bl, height: 33), title: cancelTitle, titleColor: ThemeColor, titleFont: 15, backgroundColor: UIColor.colorWithHexString("e3fef7"))
        knowBtn.layer.cornerRadius = 5
        knowBtn.clipsToBounds = true
        knowBtn.addTarget(self, action: #selector(self.hiddenAndRemove), for: UIControlEvents.touchUpInside)
        
        bgView.addSubview(knowBtn)
        
        let gotolook = UIButton.initWith(frame: CGRect.init(x: itemWidth - 142.5*bl, y: label.bottom() + 20, width: 100*bl, height: 33), title: btnTitle, titleColor: UIColor.white, titleFont: 15, backgroundColor: ThemeColor)
        gotolook.layer.cornerRadius = 5
        gotolook.clipsToBounds = true
        gotolook.addTarget(self, action: #selector(self.sureClick), for: UIControlEvents.touchUpInside)
        
        bgView.addSubview(gotolook)
        
        let bgViewHeight = gotolook.bottom() + 20
        
        bgView.frame = CGRect.init(x: (ScreenWidth - itemWidth)/2, y: (ScreenHeight - bgViewHeight)/2, width: itemWidth, height: bgViewHeight)
        
        bgView.layer.add(scaleAnimation, forKey: nil)
    }
    
    @objc private func sureClick(){
        callBack?()
        hiddenAndRemove()
    }
    
}
