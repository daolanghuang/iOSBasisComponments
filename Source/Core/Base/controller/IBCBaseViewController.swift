//
//  IBCBaseViewController.swift
//  iOSBasisComponents
//
//  Created by 道浪 on 2018/8/23.
//  Copyright © 2018年 HDL. All rights reserved.
//

import UIKit

open class IBCBaseViewController: UIViewController {
    /// 来源方式 push present
    public var isPush = true
    
    /// 参数集
    public var commonParams: Dictionary<String, Any>!
    
    /// 加载View背景
    fileprivate var loadingBgView: IBCLoadingView!
    
    /// 加载计数
    fileprivate var loadingCount = 0
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        self.changeTheme()
        //参数处理
        paramsTransform()
        //网络状态变更
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChange), name: IBCReachableUtil.share.NLKReachabilityChangedNotification, object: nil)
        //导航栏初始化
        baseInit()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 管理导航栏显示隐藏策略
        if self.navigationItem.title == nil || self.navigationItem.title == ""{
            hiddenNavigationBar(true)
        }else{
            hiddenNavigationBar(false)
        }
        
        if loadingBgView != nil && loadingBgView.loadingView.isLoading{
            loadingBgView.loadingView.startLoading()
        }
    }
    /// 隐藏显示导航条
    ///
    /// - Parameter isHidden: 是否隐藏
    func hiddenNavigationBar(_ isHidden: Bool){
        if self.navigationController?.isNavigationBarHidden != isHidden{
            self.navigationController?.setNavigationBarHidden(isHidden, animated: true)
        }
    }
    
    deinit {
        /// 默认清除所有通知
        NotificationCenter.default.removeObserver(self)
        IBCLog("\(String(describing: self.title)) 释放了")
        loadingBgView?.removeFromSuperview()
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    /// 获取当前Window
    public func getNowWindow() -> UIWindow?{
        var window = UIApplication.shared.keyWindow
        
        if (window?.windowLevel != UIWindowLevelNormal)
        {
            let windows = UIApplication.shared.windows
            for w in windows{
                if w.windowLevel == UIWindowLevelNormal{
                    window = w
                    break
                }
            }
        }
        
        return window
    }
    
    /// 显示加载框
    public func showLoadingView(_ showWindow: Bool = true){
        if loadingBgView == nil{
            loadingBgView = IBCLoadingView.init(frame: CGRect.zero)
        }
        loadingCount += 1
        if loadingCount == 1{
            if showWindow{
                getNowWindow()?.addSubview(loadingBgView)
            }else{
                self.view.addSubview(loadingBgView)
            }
            loadingBgView.loadingView.startLoading()
            UIView.animate(withDuration: 0.2, animations: {
                self.loadingBgView.alpha = 1
            })
        }
    }
    
    /// 隐藏加载框
    public func hiddenLoadingView(){
        guard loadingBgView != nil else{
            return
        }
        
        loadingCount -= 1
        if loadingCount <= 0 && loadingBgView.alpha != 0{
            loadingCount = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.loadingBgView.alpha = 0
            }, completion: { (over) in
                if over{
                    self.loadingBgView.loadingView.stopLoading()
                    self.loadingBgView.removeFromSuperview()
                }
            })
        }
    }
    
    /// 切换rootViewController
    ///
    /// - Parameter objController: 目标Controller
    public func checkRootViewController(objController: UIViewController){
        
        let animation = CATransition.init()
        animation.duration = 1.5
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = "rippleEffect"
        animation.subtype = kCATransitionFromLeft
        self.view.window?.layer.add(animation, forKey: nil)
        
        UIApplication.shared.keyWindow?.rootViewController = objController
    }
    
    
    /// 检测是否登录
    ///
    /// - Returns: 是否登录
//    public func checkLogin() -> Bool{
//        if LKUser.shared.isLogin{
//            return true
//        }else{
//            let _ = jumpWithName("\(mainTargetName).NLKLoginViewController", tParams: ["isBackOldPage":true], jumpWithPush: false)
//            return false
//        }
//    }
    
}
//MARK: UI初始化
extension IBCBaseViewController{
    func setupColorForNavigationBar(_ color: UIColor){
        self.navigationController?.navigationBar.tintColor = color
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.backgroundColor = color
    }
    
    
    /// 导航栏初始化
    @objc open func baseInit(){
        //设置默认背景色
        self.view.backgroundColor = UIColor.white
        //添加返回按钮
        addBackBtn()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        //去除分割线
        self.navigationController?.navigationBar.shadowImage = UIImage.initWithColor(LineColor, height: 0.5)
        
        
        //标题颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: TitleColor, NSAttributedStringKey.font:UIFont.systemFont(ofSize: 18)]
        /// 导航栏偏移解决
        if #available(iOS 11.0, *){
            
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    /// 添加返回按钮
    @objc open func addBackBtn(){
        let backBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
        backBtn.setImage(UIImage.init(named: "icon_return_b")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(self.back), for: UIControlEvents.touchUpInside)
        backBtn.contentHorizontalAlignment = .left
        backBtn.setTitle("返回", for: UIControlState.normal)
        backBtn.setTitleColor(TitleColor, for: UIControlState.normal)
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
    }
    
    @objc open func back(){
        pop()
    }
}
// MARK: - 网络判断
extension IBCBaseViewController{
    /// 判断当前ViewController是否显示
    ///
    /// - Returns: 是否显示
    public func checkIsShow() -> Bool{
        if self.isViewLoaded && self.view.window != nil{
            //当前viewController在显示
            return true
        }
        return false
    }
    
    /// 网络状态更改
    @objc public func networkStatusChange(){
        if checkIsShow(){
            shouldUpdateDatas()
        }
    }
    
    /// 需要更新数据
    @objc open func shouldUpdateDatas(){
        
    }
}
// MARK: - 参数处理
extension IBCBaseViewController{
    /// 基础类型参数处理
    @objc open func paramsTransform(){
        guard commonParams != nil else{
            return
        }
        
        setValuesForKeys(commonParams)
    }
}

//MARK: 页面跳转
extension IBCBaseViewController{
    
    /// 通过className跳转控制器
    ///
    /// - Parameters:
    ///   - className: 控制器名称 注意格式：项目名.类名
    ///   - tParams: 参数集
    ///   - jumpWithPush: 是否为Push跳转
    /// - Returns: 成功标志
    public func jumpWithName(_ className: String, tParams: Dictionary<String, Any>? = nil, jumpWithPush: Bool = true) -> Bool{
        guard let vcType = NSClassFromString(className) as? UIViewController.Type else{
            return false
        }
        
        let vc = vcType.init()
        
        if vc is IBCBaseViewController{
            (vc as! IBCBaseViewController).isPush = jumpWithPush
            (vc as! IBCBaseViewController).commonParams = tParams
        }
        
        DispatchQueue.main.async {
            if jumpWithPush{
                //隐藏底部tab
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let navigator = UINavigationController(rootViewController: vc)
                
                self.present(navigator, animated: true, completion: nil)
            }
        }
        return true
    }
    
    /// push跳转
    ///
    /// - Parameters:
    ///   - view: 目标控制器
    ///   - tParams: 参数
    public func push(_ vc: UIViewController){
        if vc is IBCBaseViewController{
            (vc as! IBCBaseViewController).isPush = true
        }
        //隐藏底部tab
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// present跳转
    ///
    /// - Parameters:
    ///   - view: 目标控制器
    ///   - tParams: 参数
    public func present(_ vc: UIViewController){
        if vc is IBCBaseViewController{
            (vc as! IBCBaseViewController).isPush = false
        }
        
        let navigator = UINavigationController(rootViewController: vc)
        
        self.present(navigator, animated: true, completion: nil)
    }
    
    /// 返回上一页
    public func pop(){
        if isPush{
            let _ = self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /// 返回到root
    public func popToRoot(){
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    /// 显示系统黑色消息
    ///
    /// - Parameters:
    ///   - msg: 消息内容
    ///   - finishBlock: 显示完成后回调
    public func showBlackMsg(msg: String, finishBlock: (() -> Void)?) {
        let alert = UIAlertController.init(title: msg, message: nil, preferredStyle: .alert)
        self.present(alert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0, execute: {
                self.presentedViewController?.dismiss(animated: true, completion: {
                    finishBlock?()
                })
            })
        })
    }
}
