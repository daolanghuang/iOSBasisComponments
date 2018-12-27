//
//  CCWebViewController.swift
//  CCAppManager
//
//  Created by 道浪 on 2017/9/21.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit
import JavaScriptCore

open class CCWebViewController: IBCBaseViewController {
    /// 来源动画方式
//    public var isPush = true
    /// 访问链接
    public var url: String!
    /// html代码
    public var htmlCode: String!
    /// 来源网址
    public var sourceUrl = "www.laikang.com"
    /// WebView
    public var webview: UIWebView!
    /// 是否需要自动随页面切换更换标题
    public var shouldAutoCheckTitle = false
    /// 图片工具
    var photoUtil: IBCPhotoUtil!
    /// 状态栏颜色
    fileprivate var mUIStatusBarStyle: UIStatusBarStyle!
    
    fileprivate var shareView: CCShareMenuView!
    
    //是否加载完成
    fileprivate var isOver = false
    //加载进度条
    fileprivate let progressView: UIView = {
        let progress = UIView()
        progress.frame = CGRect(x: 0, y: 0, width: 0, height: 3)
        progress.backgroundColor = ThemeColor
        return progress
    }()
    
    /// 是否初始化导航栏(因为私有库跳转传参值赋值问题，初始化放到willAppear里，确保只初始化一次)
    fileprivate var isInitNav: Bool = true
    /// 导航栏显示样式 0 返回 1关闭 2分享
    public var navigationBarStyle = [ 0, 1, 2]
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        
        mUIStatusBarStyle = UIApplication.shared.statusBarStyle
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //定位
        let _ = CCLocationModel.sharedLocationModel
        
        if isInitNav {
            navigationInit()
            isInitNav = false
        }
        
        //状态栏颜色
        if mUIStatusBarStyle != .lightContent{
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        }
        
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if mUIStatusBarStyle != UIApplication.shared.statusBarStyle{
            UIApplication.shared.setStatusBarStyle(mUIStatusBarStyle, animated: true)
        }
        
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
    }
    
    
    @objc override open func back(){
        if isPush{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //关闭浏览器
    @objc open func closeBack() {
        if isPush{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    open func getTextColor() -> UIColor{
        return UIColor.colorWithHexString("c9c9c9")
    }
    // 微信分享
    open func weixinShareClick() {
        
    }
    // 盆友圈分享
    open func penyouquanShareClick() {
        
    }
    // QQ分享
    open func qqShareClick() {
        
    }
    // QQ空间分享
    open func qzoneShareClick() {
        
    }
    // 微博分享
    open func weiboShareClick() {
        
    }
    // 刷新
    open func refreshClick() {
        self.webview.reload()
    }
    // 复制URL
    open func copyUrlClick() {
        UIPasteboard.general.string = self.url
    }
    // 打开URL
    open func openUrlClick() {
        guard UIApplication.shared.canOpenURL(URL.init(string: self.url)!) else {
            return
        }
        UIApplication.shared.openURL(URL.init(string: self.url)!)
    }
    
    //返回上一页
    @objc func backLastPage(){
        if webview.canGoBack{
            webview.goBack()
        }else{
            back()
        }
    }
    
    //显示菜单栏
    @objc open func showMenu(){
        shareView.showView()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension CCWebViewController{
    //UI初始化
    func setupUI(){
        
        webview = CCWebView.init(frame: CGRect.init(x: 0, y: NavigationBarHeight, width: ScreenWidth, height: ScreenHeight - NavigationBarHeight))
        webview.delegate = self
        webview.dataDetectorTypes = UIDataDetectorTypes(rawValue: 0)
        self.view.addSubview(webview)
        
        webview.addSubview(progressView)
        
        
        let bgView = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: webview.frame.size))
        bgView.backgroundColor = BackgroundColor
        
        
        
        /// 来源Label初始化
        let h5ComeFrom = UILabel.initWith(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 40), font: 13, color: getTextColor(), alignment: NSTextAlignment.center)
        h5ComeFrom.text = "此网页由\(sourceUrl)提供"
        
        /// 来源Label初始化
        let bottomLabel = UILabel.initWith(frame: CGRect.init(x: 0, y: ScreenHeight - 50 - NavigationBarHeight, width: ScreenWidth, height: 40), font: 13, color: getTextColor(), alignment: NSTextAlignment.center)
        bottomLabel.text = "没有更多了"
        
        bgView.addSubview(h5ComeFrom)
        bgView.addSubview(bottomLabel)
        
        let lineLeft = UIView.init(frame: CGRect.init(x: ScreenWidth/4 - 30, y: bottomLabel.top() + bottomLabel.height()/2, width: 60, height: 0.5))
        lineLeft.backgroundColor = getTextColor()
        
        bgView.addSubview(lineLeft)
        
        let lineRight = UIView.init(frame: CGRect.init(x: ScreenWidth/2 + ScreenWidth/4 - 30, y: bottomLabel.top() + bottomLabel.height()/2, width: 60, height: 0.5))
        lineRight.backgroundColor = getTextColor()
        
        bgView.addSubview(lineRight)
        
        
        
        webview.addSubview(bgView)
        webview.sendSubview(toBack: bgView)
        
        if url != nil{
            if let urlObj = URL(string: url){
                webview.loadRequest(URLRequest(url: urlObj))
            }else{
                webview.loadRequest(URLRequest(url: URL(string: "http://come.enn.cn/eai/EnnEAI/login.jsp")!))
            }
        }else if htmlCode != nil{
            webview.loadHTMLString(htmlCode, baseURL: nil)
        }
        
        self.shareInit()
    }
    
    //导航条初始化
    func navigationInit(){
        //        let statusBg = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 20))
        //        statusBg.backgroundColor = ThemeColor
        //
        //        self.view.addSubview(statusBg)
        
        let navigationView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: NavigationBarHeight))
        navigationView.backgroundColor = ThemeColor
        navigationView.tag = 1000
        
        //返回上一页按钮
        let backLastBtn = UIButton.init(frame: CGRect.init(x: 0, y: StatusHeight, width: 44, height: 44))
        backLastBtn.setImage(UIImage.bundleImage(bundleClass: CCWebViewController.self, bundleName: "Core", imageName: "ccshare_goback@2x"), for: .normal)
        backLastBtn.addTarget(self, action: #selector(self.backLastPage), for: UIControlEvents.touchUpInside)
        
        navigationView.addSubview(backLastBtn)
        
        if navigationBarStyle.contains(1){
            //返回按钮
            let backBtn = UIButton.init(frame: CGRect.init(x: backLastBtn.right(), y: StatusHeight, width: 44, height: 44))
            backBtn.setImage(UIImage.bundleImage(bundleClass: CCWebViewController.self, bundleName: "Core", imageName: "ccshare_close@2x"), for: .normal)
            backBtn.addTarget(self, action: #selector(self.closeBack), for: UIControlEvents.touchUpInside)
            
            navigationView.addSubview(backBtn)
        }
        
        
        //标题
        let titleLabel = UILabel.init(frame: CGRect.init(x: 100, y: StatusHeight, width: self.view.frame.width - 200, height: 44))
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.tag = 1001
        
        navigationView.addSubview(titleLabel)
        
        if navigationBarStyle.contains(2){
            // 更多按钮
            let moreBtn = UIButton.init(frame: CGRect.init(x: self.view.frame.width - 37, y: 11 + StatusHeight, width: 22, height: 22))
            moreBtn.setImage(UIImage.bundleImage(bundleClass: CCWebViewController.self, bundleName: "Core", imageName: "ccshare_more@2x"), for: .normal)
            moreBtn.addTarget(self, action: #selector(self.showMenu), for: UIControlEvents.touchUpInside)
            navigationView.addSubview(moreBtn)
        }
        
        self.view.addSubview(navigationView)
    }
    // 分享初始化
    private func shareInit(){
        // 分享view
        weak var weakSelf = self
        shareView = CCShareMenuView.init(frame: CGRect.zero)
        shareView.shareViewCallBackBlock = {(type) in
            switch type {
            case .WeiXinShareType:
                weakSelf?.weixinShareClick()
            case .PenYouQuanShareType:
                weakSelf?.penyouquanShareClick()
            case .QQShareType:
                weakSelf?.qqShareClick()
            case .QzoneShareType:
                weakSelf?.qzoneShareClick()
            case .SinaShareType:
                weakSelf?.weiboShareClick()
            case .RefreshType:
                weakSelf?.refreshClick()
            case .CopyUrlType:
                weakSelf?.copyUrlClick()
            case .OpenUrlType:
                weakSelf?.openUrlClick()
            }
        }
    }
}
//MARK: 预览图片
extension CCWebViewController{
    
}

//MARK: webView代理
extension CCWebViewController: UIWebViewDelegate{
    open func webViewDidStartLoad(_ webView: UIWebView) {
        animationStart()
    }
    
    // MARK: 绑定JS交互事件
    open func webViewDidFinishLoad(_ webView: UIWebView) {
        animationEnd()
        let jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        //基础Model注入
        let modelBase = CCJSBaseModel(context: jsContext)
        jsContext.setObject(modelBase, forKeyedSubscript: "ccbase" as NSCopying & NSObjectProtocol)
        
        //网络交互Model注入
        let modelHttp = CCJSHttpModel(context: jsContext)
        jsContext.setObject(modelHttp, forKeyedSubscript: "cchttp" as NSCopying & NSObjectProtocol)
        
        switch self {
        case is CCWebViewModuleDelegate:
            let modelWeb = CCJSWebViewMode(context: jsContext)
            modelWeb.withoutDelegate = self as? CCWebViewModuleDelegate
            jsContext.setObject(modelWeb, forKeyedSubscript: "ccview" as NSCopying & NSObjectProtocol)
            print("CCWebViewModuleDelegate")
            fallthrough
        case is CCSystemModuleDelegate:
            let modelSystem = CCJSSystemModel(context: jsContext)
            modelSystem.systemDelegate = self as? CCSystemModuleDelegate
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
        if shouldAutoCheckTitle{
            //获取标题
            let title = webView.stringByEvaluatingJavaScript(from: "document.title") ?? "" as String
            
            setControllerTitle(title)
        }
    }
    
    open func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("didFailLoadWithError: \(error.localizedDescription)")
        animationEnd()
    }
    
    /// 设置标题
    func setControllerTitle(_ title: String){
        if let label = self.view.viewWithTag(1001) as? UILabel{
            label.text = title
        }
    }
}
//MARK: - 动画
extension CCWebViewController{
    func animationStart(){
        UIView.animate(withDuration: 1, animations: {
            self.progressView.frame.size.width = ScreenWidth*0.8
        }, completion: {(over: Bool?) in
            if !self.isOver{
                UIView.animate(withDuration: 2, animations: {
                    self.progressView.frame.size.width = ScreenWidth*0.9
                })
            }
            
        })
    }
    
    func animationEnd(){
        isOver = true
        progressView.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.2, animations: {
            self.progressView.frame.size.width = ScreenWidth
        } , completion: {(over: Bool?) in
            self.progressView.frame.size.width = 0
        })
    }
}

//MARK: 显示隐藏导航栏
extension CCWebViewController: CCWebViewModuleDelegate{
    /// 隐藏导航栏
    public func hiddenNavigation(_ isHidden: Bool){
        if let navigationView = self.view.viewWithTag(1000){
            if isHidden{
                UIView.animate(withDuration: 0.2, animations: {
                    navigationView.frame.origin.y = -64
                    self.webview.frame = CGRect.init(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height - 20)
                }, completion: { (over: Bool) in
                    if over{
                        navigationView.isHidden = true
                    }
                })
                
            }else{
                navigationView.isHidden = false
                UIView.animate(withDuration: 0.2, animations: {
                    navigationView.frame.origin.y = 0
                    self.webview.frame.origin.y = 64
                }, completion: { (over: Bool) in
                    if over{
                        self.webview.frame.size.height = self.view.frame.height - 64
                    }
                })
            }
        }
    }
    
    /// 设置标题
    ///
    /// - Parameter params: title
    public func setMTitle(_ title: String){
        DispatchQueue.main.async {
            if let titleLabel = self.view.viewWithTag(1001) as? UILabel{
                titleLabel.text = title
            }
        }
    }
}

