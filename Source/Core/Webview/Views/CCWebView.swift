//
//  CCWebView.swift
//  CCAppManager
//
//  Created by 道浪 on 2017/8/30.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit
import JavaScriptCore

public class CCWebView: UIWebView, UIWebViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    weak public var realizeDelegates: CCModuleBaseDelegate!
    //是否加载完成
    fileprivate var isOver = false
    //加载进度条
    fileprivate let progressView: UIView = {
        let progress = UIView()
        progress.frame = CGRect(x: 0, y: 0, width: 0, height: 3)
        progress.backgroundColor = UIColor(red: 135.0/255.0, green: 206.0/255.0, blue: 250.0/255.0, alpha: 1)
        return progress
    }()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
        self.addSubview(progressView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func webViewDidStartLoad(_ webView: UIWebView) {
        animationStart()
    }
    
    // MARK: 绑定JS交互事件
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        animationEnd()
        let jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        //基础Model注入
        let modelBase = CCJSBaseModel(context: jsContext)
        jsContext.setObject(modelBase, forKeyedSubscript: "ccbase" as NSCopying & NSObjectProtocol)
        
        //网络交互Model注入
        let modelHttp = CCJSHttpModel(context: jsContext)
        jsContext.setObject(modelHttp, forKeyedSubscript: "IBCHttp" as NSCopying & NSObjectProtocol)
        
        switch realizeDelegates {
        case is CCWebViewModuleDelegate:
            let modelWeb = CCJSWebViewMode(context: jsContext)
            modelWeb.withoutDelegate = realizeDelegates as? CCWebViewModuleDelegate
            jsContext.setObject(modelWeb, forKeyedSubscript: "ccview" as NSCopying & NSObjectProtocol)
            print("CCWebViewModuleDelegate")
            fallthrough
        case is CCSystemModuleDelegate:
            let modelSystem = CCJSSystemModel(context: jsContext)
            modelSystem.systemDelegate = realizeDelegates as? CCSystemModuleDelegate
            jsContext.setObject(modelSystem, forKeyedSubscript: "ccsystem" as NSCopying & NSObjectProtocol)
            print("CCWebViewModuleDelegate")
            fallthrough
        default:
            break
        }
        
        
        
        //WebView当前访问页面的链接 可动态注册
        guard let curUrl = webView.request?.url?.absoluteString else{
            return
        }
        
        do{
            let str = try String.init(contentsOf: URL.init(string: curUrl)!)
            jsContext.evaluateScript(str)
        }catch{
            
        }
        
        jsContext.exceptionHandler = { (context, exception) in
            print("exception：", exception ?? "nil")
        }
        print("`````````````````````````````````````````````````")
        
        //获取标题
        let title = webView.stringByEvaluatingJavaScript(from: "document.title") ?? "" as String
        
        
    }
}

extension CCWebView{
    func animationStart(){
        UIView.animate(withDuration: 1, animations: {
            self.progressView.frame.size.width = self.frame.width*0.8
        }, completion: {(over: Bool?) in
            if !self.isOver{
                UIView.animate(withDuration: 2, animations: {
                    self.progressView.frame.size.width = self.frame.width*0.9
                })
            }
            
        })
    }
    
    func animationEnd(){
        isOver = true
        progressView.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.2, animations: {
            self.progressView.frame.size.width = self.frame.width
        } , completion: {(over: Bool?) in
            self.progressView.frame.size.width = 0
        })
    }
}
