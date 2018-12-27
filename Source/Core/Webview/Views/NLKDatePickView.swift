//
//  NLKDatePickView.swift
//  EnnewLaikang
//
//  Created by 廖望 on 2018/5/4.
//  Copyright © 2018年 Enn. All rights reserved.
//

import UIKit

public class NLKDatePickView: UIView {

    public var selectedBlock: ((String)->Void)?
    private let screenSize = UIScreen.main.bounds.size
    private let showViewHeight: CGFloat = 250.0
    private var showView: UIView!
    private var pickView: UIDatePicker!

    private var selectDateStr: String = ""
    private var maxDateStr: String = ""
    
    public init(frame: CGRect, defaultDateStr: String = "", maxDateStr: String = "") {
        super.init(frame: frame)
        self.alpha = 0.0
        
        if defaultDateStr == ""{
            let dateFormater = DateFormatter.init()
            dateFormater.dateFormat = "YYYY-MM-dd"
            let strDate = dateFormater.string(from: Date())
            self.selectDateStr = strDate
        }else{
            self.selectDateStr = defaultDateStr
        }
        self.maxDateStr = maxDateStr
        
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(cancelClick)))
        self.customUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(){
        UIApplication.shared.keyWindow?.addSubview(self)
        self.showPickView()
    }
    
    
    
    private func customUI() {
        
        showView = UIView.init(frame: CGRect.init(x: 0, y: screenSize.height, width: screenSize.width, height: showViewHeight))
        showView.backgroundColor = UIColor.white
        self.addSubview(showView)
        
        let tmpView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenSize.width, height: 30))
        tmpView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        showView.addSubview(tmpView)
        
        let btnColor = UIColor.init(red: 46.0/255.0, green: 205.0/255.0, blue: 147.0/255.0, alpha: 1.0)
        let cancelBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 30))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(btnColor, for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cancelBtn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        showView.addSubview(cancelBtn)
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: 50, y: 0, width: screenSize.width-100, height: 30))
        titleLabel.text = "选择日期"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        showView.addSubview(titleLabel)
        
        let okBtn = UIButton.init(frame: CGRect.init(x: screenSize.width-50, y: 0, width: 50, height: 30))
        okBtn.setTitle("确定", for: .normal)
        okBtn.setTitleColor(btnColor, for: .normal)
        okBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        okBtn.addTarget(self, action: #selector(okClick), for: .touchUpInside)
        showView.addSubview(okBtn)
        
        
        pickView = UIDatePicker.init(frame: CGRect.init(x: 0, y: 30, width: screenSize.width, height: showViewHeight-30.0))
        pickView.datePickerMode = .date
        pickView.locale = Locale.init(identifier: "zh_CN")
        pickView.addTarget(self, action: #selector(chooseDate(_:)), for: .valueChanged)
        showView.addSubview(pickView)
        
        let dateFormater = DateFormatter.init()
        dateFormater.dateFormat = "YYYY-MM-dd"
        
        // 最大值
        if self.maxDateStr.count > 0 {
            if let maxDate = dateFormater.date(from: self.maxDateStr) {
                pickView.maximumDate = maxDate
            }
        }
        
        // 选中值
        guard let date = dateFormater.date(from: selectDateStr) else {
            return
        }
        pickView.date = date
    }
    
    @objc private func cancelClick() {
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.showView.frame = CGRect.init(x: 0, y: self.screenSize.height, width: self.screenSize.width, height: self.showViewHeight)
        }) { (isFinished) in
            self.removeFromSuperview()
        }
    }
    
    @objc private func okClick() {
        self.selectedBlock?(selectDateStr)
        self.cancelClick()
    }
    
    private func showPickView(){
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1.0
            self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.showView.frame = CGRect.init(x: 0, y: self.screenSize.height-self.showViewHeight, width: self.screenSize.width, height: self.showViewHeight)
        }
    }
    
    @objc private func chooseDate(_ datePicker:UIDatePicker) {
        let chooseDate = datePicker.date
        let dateFormater = DateFormatter.init()
        dateFormater.dateFormat = "YYYY-MM-dd"
        let strDate = dateFormater.string(from: chooseDate)
        self.selectDateStr = strDate
    }

}
