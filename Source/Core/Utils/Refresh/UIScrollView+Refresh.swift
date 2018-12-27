//
//  UIScrollView+Refresh.swift
//  iOSBasisComponents
//
//  Created by 道浪 on 2017/8/25.
//  Copyright © 2017年 enn. All rights reserved.
//

import UIKit



public extension UIScrollView {
    func addHeaderWithCallback( _ callback:(() -> Void)!){
        if let _:RefreshHeaderView = self.viewWithTag(555) as? RefreshHeaderView{
            return
        }
        
        let header:RefreshHeaderView = RefreshHeaderView.footer(ScreenWidth)
        header.tag = 555
        self.addSubview(header)
        header.beginRefreshingCallback = callback
        header.addState(RefreshState.normal)
    }
    
    func addHeaderWithCallbackMaster( _ callback:(() -> Void)!){
        if let _:RefreshHeaderView = self.viewWithTag(555) as? RefreshHeaderView{
            return
        }
        
        let header:RefreshHeaderView = RefreshHeaderView.footer(ScreenWidth*0.827 - 7)
        header.tag = 555
        self.addSubview(header)
        header.beginRefreshingCallback = callback
        header.addState(RefreshState.normal)
    }
    
    func removeHeader()
    {
        
        for view : AnyObject in self.subviews{
            if view is RefreshHeaderView{
                (view as! RefreshHeaderView).removeFromSuperview()
            }
        }
    }
    
    
    func headerBeginRefreshing()
    {
        
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                (object as! RefreshHeaderView).beginRefreshing()
            }
        }
        
    }
    
    
    func headerEndRefreshing()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                (object as! RefreshHeaderView).endRefreshing()
            }
        }
        
    }
    
    func setHeaderHidden(_ hidden:Bool)
    {
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                let view:UIView  = object as! UIView
                view.isHidden = hidden
            }
        }
        
    }
    
    func isHeaderHidden()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                let view:UIView  = object as! UIView
                view.isHidden = isHidden
            }
        }
        
    }
    
   func addFooterWithCallback( _ callback:(() -> Void)!){
    
        if let _:RefreshFooterView = self.viewWithTag(556) as? RefreshFooterView{
            return
        }
    
        let footer:RefreshFooterView = RefreshFooterView.footer(ScreenWidth)
        footer.tag = 556
        self.addSubview(footer)
        footer.beginRefreshingCallback = callback
        
        footer.addState(RefreshState.normal)
    }
    
    
    func addFooterWithCallbackMaster( _ callback:(() -> Void)!){
        
        if let _:RefreshFooterView = self.viewWithTag(556) as? RefreshFooterView{
            return
        }
        
        let footer:RefreshFooterView = RefreshFooterView.footer(ScreenWidth*0.827 - 7)
        footer.tag = 556
        self.addSubview(footer)
        footer.beginRefreshingCallback = callback
        
        footer.addState(RefreshState.normal)
    }
    
     func removeFooter()
    {
    
        for view : AnyObject in self.subviews{
            if view is RefreshFooterView{
                (view as! RefreshFooterView).removeFromSuperview()
            }
        }
    }
    
    func footerBeginRefreshing()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                (object as! RefreshFooterView).beginRefreshing()
            }
        }
        
    }

    
    func footerEndRefreshing()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                (object as! RefreshFooterView).endRefreshing()
            }
        }
     
    }
  
    func setFooterHidden(_ hidden:Bool)
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                let view:UIView  = object as! UIView
                view.isHidden = hidden
            }
        }
        
    }
    
    func isFooterHidden()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                let view:UIView  = object as! UIView
                view.isHidden = isHidden
            }
        }
        
    }
  
 


}
